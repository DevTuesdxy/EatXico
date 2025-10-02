////
////  CameraView.swift
////  EatXico
////
////  Created by Alan Cervantes on 02/10/25.
////
//
//import SwiftUI
//import AVFoundation
//
//struct CameraView: View {
//    @StateObject private var viewModel = CameraViewModel()
//    
//    @State private var hasPermission: Bool? = nil
//    @State private var showDeniedAlert = false
//    
//    var body: some View {
//        ZStack {
//            if hasPermission == true {
//                CameraPreviewView(session: viewModel.session)
//                    .ignoresSafeArea()
//            } else if hasPermission == false {
//                Text("Permiso de cámara denegado.\nActívalo en Ajustes para continuar.")
//                    .multilineTextAlignment(.center)
//                    .padding()
//            } else {
//                ProgressView()
//            }
//            
//            if hasPermission == true {
//                VStack {
//                    Spacer()
//                    
//                    Text(viewModel.resultText)
//                        .font(.title3)
//                        .fontWeight(.bold)
//                        .foregroundStyle(.white)
//                        .padding()
//                        .background(Color.black.opacity(0.7))
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                        .padding(.horizontal)
//                    
//                    Button(action: {
//                        viewModel.takePhoto()
//                    }) {
//                        ZStack {
//                            Circle()
//                                .fill(Color.white)
//                                .frame(width: 70, height: 70)
//                            Circle()
//                                .stroke(Color.white, lineWidth: 4)
//                                .frame(width: 80, height: 80)
//                        }
//                    }
//                    .padding(.bottom, 40)
//                }
//            }
//        }
//        .onAppear {
//            requestCameraPermission { granted in
//                hasPermission = granted
//                if granted {
//                    viewModel.startRunning()
//                } else {
//                    showDeniedAlert = true
//                }
//            }
//        }
//        .onDisappear {
//            viewModel.stopRunning()
//        }
//        .alert("Acceso a la cámara denegado", isPresented: $showDeniedAlert) {
//            Button("Abrir Ajustes") {
//                if let url = URL(string: UIApplication.openSettingsURLString) {
//                    UIApplication.shared.open(url)
//                }
//            }
//            Button("Cancelar", role: .cancel) {}
//        } message: {
//            Text("Ve a Ajustes y permite el acceso a la cámara para usar esta función.")
//        }
//    }
//}
//
//func requestCameraPermission(completion: @escaping (Bool) -> Void) {
//    switch AVCaptureDevice.authorizationStatus(for: .video) {
//    case .authorized:
//        completion(true)
//    case .notDetermined:
//        AVCaptureDevice.requestAccess(for: .video) { granted in
//            DispatchQueue.main.async { completion(granted) }
//        }
//    case .denied, .restricted:
//        completion(false)
//    @unknown default:
//        completion(false)
//    }
//}
//
//#Preview {
//    CameraView()
//}
//
