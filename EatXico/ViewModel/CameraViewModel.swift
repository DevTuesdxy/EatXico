////
////  CameraViewModel.swift
////  EatXico
////
////  Created by Alan Cervantes on 02/10/25.
////
//
//import SwiftUI
//import Combine
//@preconcurrency import Vision
//import CoreML
//@preconcurrency import AVFoundation
//
//@MainActor
//class CameraViewModel: NSObject, ObservableObject {
//    
//    let session = AVCaptureSession()
//    private let photoOutput = AVCapturePhotoOutput()
//    
//    @Published var resultText: String = "Apunta y presiona el botón para capturar"
//    
//    private var visionModel: VNCoreMLModel?
//    
//    
//    //constructor: pasamos la base de avfundation para manejo de camara y las otras 2 funciones
//    override init() {
//        super.init()
//        setupVisionModel()
//        configureSession()
//    }
//    
//    //se configura y se carga el modelo de ia
//    private func setupVisionModel() {
//        do {
//            let configuration = MLModelConfiguration()
//            let coreMLModel = try MobileNetV2FP16(configuration: configuration)
//            self.visionModel = try VNCoreMLModel(for: coreMLModel.model)
//        } catch {
//            resultText = "Error: No se pudo cargar el modelo."
//        }
//    }
//    
//    //configura la sesion y la entrada de la camara
//    func configureSession() {
//        guard let videoDevice = AVCaptureDevice.default(for: .video) else {
//            resultText = "Error: No se encontró la cámara."
//            return
//        }
//        
//        session.beginConfiguration()
//        
//        do {
//            let input = try AVCaptureDeviceInput(device: videoDevice)
//            if session.canAddInput(input) { session.addInput(input) }
//
//            if session.canAddOutput(photoOutput) { session.addOutput(photoOutput) }
//            
//        } catch {
//            resultText = "Error al configurar la cámara."
//        }
//        
//        session.commitConfiguration()
//    }
//    
//    //enciende la sesion si esta apagada
//    func startRunning() {
//        let session = self.session
//        guard !session.isRunning else { return }
//        DispatchQueue.global(qos: .userInitiated).async {
//            session.startRunning()
//        }
//    }
//    
//    //apaga la sesion si esta encendida
//    func stopRunning() {
//        let session = self.session
//        guard session.isRunning else { return }
//        DispatchQueue.global(qos: .userInitiated).async {
//            session.stopRunning()
//        }
//    }
//    
//    //da la instuccion directa de tomar la foto con las configuraciones por defecto, y el resultado lo guarda lo aqui mismo(CameraViewModel)
//    func takePhoto() {
//        self.resultText = "Capturando..."
//        let settings = AVCapturePhotoSettings()
//        photoOutput.capturePhoto(with: settings, delegate: self)
//    }
//    
//    //Analizar  la imagen que se tomo y le da formato al texto que la ia responde
//    private func classify(image: UIImage) {
//        guard let visionModel = self.visionModel else { return }
//        
//        self.resultText = "Analizando..."
//        
//        let request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
//            guard let self = self else { return }
//            
//            if let results = request.results as? [VNClassificationObservation],
//               let topResult = results.first {
//                let objectName = topResult.identifier.components(separatedBy: ",")[0]
//                let confidence = Int(topResult.confidence * 100)
//                
//                self.resultText = "\(objectName.capitalized) (\(confidence)%)"
//            } else {
//                self.resultText = "No se pudo identificar."
//            }
//        }
//        
//        guard let ciImage = CIImage(image: image) else { return }
//        DispatchQueue.global(qos: .userInitiated).async {
//            try? VNImageRequestHandler(ciImage: ciImage, options: [:]).perform([request])
//        }
//    }
//}
//
//extension CameraViewModel: AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        guard let imageData = photo.fileDataRepresentation(),
//              let image = UIImage(data: imageData) else {
//            self.resultText = "Error: No se pudo procesar la foto."
//            return
//        }
//        self.classify(image: image)
//    }
//}
//
//
