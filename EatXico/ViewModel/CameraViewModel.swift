//
//  CameraViewModel.swift
//  EatXico
//
//  Created by Alan Cervantes on 02/10/25.
//

import SwiftUI
import Combine
@preconcurrency import Vision
import CoreML
@preconcurrency import AVFoundation

@MainActor
class CameraViewModel: NSObject, ObservableObject {
    
    let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    
    private var classifierModel: VNCoreMLModel?
    private var objectDetectorModel: VNCoreMLModel?
    private let chatViewModel = ChatViewModel()
    
    @Published var analysisStatus: String = "Apunta y presiona para capturar"
    @Published var isAnalyzing: Bool = false
    @Published var analysisResult: AnalysisResult?
    @Published var analysisError: String?

    override init() {
        super.init()
        loadModels()
        configureSession()
    }
    
    private func loadModels() {
        do {
            let config = MLModelConfiguration()
            let sharedModel = try MyObjectDetector_1_Iteration_25000(configuration: config)
            self.classifierModel = try VNCoreMLModel(for: sharedModel.model)
            self.objectDetectorModel = try VNCoreMLModel(for: sharedModel.model)
            
        } catch {
            analysisStatus = "Error: No se pudieron cargar los modelos de IA."
            analysisError = error.localizedDescription
        }
    }
    
    func takePhoto() {
        guard !isAnalyzing else { return }
        analysisStatus = "Capturando foto..."
        isAnalyzing = true
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    private func analyze(image: UIImage) {
        Task {
            do {
                analysisStatus = "Identificando platillo..."
                let dishIdentifier = try await classifyDish(from: image)
                
                analysisStatus = "Consultando receta base..."
                let foodInfo = try await chatViewModel.getInfo(for: dishIdentifier)
                
                analysisStatus = "Detectando ingredientes visibles..."
                let detectedIngredients = try await detectVisibleIngredients(from: image)
                
                analysisStatus = "Combinando resultados..."
                var combined = Set(foodInfo.ingredientes)
                detectedIngredients.forEach { combined.insert($0.capitalized) }
                
                self.analysisResult = AnalysisResult(
                    dishName: foodInfo.nombre,
                    capturedImage: image,
                    combinedIngredients: Array(combined).sorted()
                )
                
                self.isAnalyzing = false
                self.analysisStatus = "¡Análisis completo!"
                
            } catch {
                self.analysisError = error.localizedDescription
                self.isAnalyzing = false
                self.analysisStatus = "Error en el análisis. Intenta de nuevo."
            }
        }
    }
    
    private func classifyDish(from image: UIImage) async throws -> String {
        guard let classifierModel = self.classifierModel else { throw URLError(.badURL) }
        return try await performVisionRequest(for: classifierModel, on: image) { request in
            guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No se pudo clasificar el platillo."])
            }
            return topResult.identifier
        }
    }
    
    private func detectVisibleIngredients(from image: UIImage) async throws -> [String] {
        guard let objectDetectorModel = self.objectDetectorModel else { throw URLError(.badURL) }
        return try await performVisionRequest(for: objectDetectorModel, on: image) { request in
            guard let results = request.results as? [VNRecognizedObjectObservation] else { return [] }
            return results.compactMap { observation in observation.labels.first?.identifier }
        }
    }
    
    private func performVisionRequest<T>(for model: VNCoreMLModel, on image: UIImage, handler: @escaping (VNRequest) throws -> T) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNCoreMLRequest(model: model) { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                do {
                    let result = try handler(request)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
            guard let ciImage = CIImage(image: image) else {
                continuation.resume(throwing: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error al convertir imagen."]))
                return
            }
            DispatchQueue.global().async {
                do {
                    let orientation = CGImagePropertyOrientation(image.imageOrientation)
                    try VNImageRequestHandler(ciImage: ciImage, orientation: orientation).perform([request])
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func configureSession() {
        guard let videoDevice = AVCaptureDevice.default(for: .video) else {
            analysisStatus = "Error: No se encontró la cámara."
            return
        }
        session.beginConfiguration()
        do {
            let input = try AVCaptureDeviceInput(device: videoDevice)
            if session.canAddInput(input) { session.addInput(input) }
            if session.canAddOutput(photoOutput) { session.addOutput(photoOutput) }
        } catch {
            analysisStatus = "Error al configurar la cámara."
            analysisError = error.localizedDescription
        }
        session.commitConfiguration()
    }
    
    func startRunning() {
        Task { @MainActor in
            guard !session.isRunning else { return }
            session.startRunning()
        }
    }
    
    func stopRunning() {
        Task { @MainActor in
            guard session.isRunning else { return }
            session.stopRunning()
        }
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else {
            self.analysisStatus = "Error: No se pudo procesar la foto."
            self.isAnalyzing = false
            return
        }
        analyze(image: image)
    }
}

private extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .up; case .down: self = .down; case .left: self = .left; case .right: self = .right
        case .upMirrored: self = .upMirrored; case .downMirrored: self = .downMirrored
        case .leftMirrored: self = .leftMirrored; case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}
