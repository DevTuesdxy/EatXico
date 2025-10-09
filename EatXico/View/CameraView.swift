//
//  CameraView.swift
//  EatXico
//
//  Created by Alan Cervantes on 02/10/25.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject private var viewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            CameraPreviewView(session: viewModel.session)
                .ignoresSafeArea()
            
            cameraOverlay
        }
        .onAppear(perform: viewModel.startRunning)
        .onDisappear(perform: viewModel.stopRunning)
        .navigationTitle("Escanear Platillo")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $viewModel.analysisResult) { result in
            ResultView(result: result)
        }
        .alert("Error de Análisis", isPresented: .constant(viewModel.analysisError != nil), actions: {
            Button("OK") { viewModel.analysisError = nil }
        }, message: {
            Text(viewModel.analysisError ?? "Ocurrió un error desconocido.")
        })
    }
    
    private var cameraOverlay: some View {
        ZStack {
            if viewModel.isAnalyzing {
                Color.black.opacity(0.5).ignoresSafeArea().transition(.opacity)
            }
            VStack {
                Spacer()
                Text(viewModel.analysisStatus)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal)
                
                if viewModel.isAnalyzing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2)
                        .frame(height: 80)
                        .padding(.bottom, 40)
                } else {
                    Button(action: viewModel.takePhoto) {
                        ZStack {
                            Circle().fill(Color.white).frame(width: 70, height: 70)
                            Circle().stroke(Color.white, lineWidth: 4).frame(width: 80, height: 80)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .animation(.easeInOut, value: viewModel.isAnalyzing)
    }
}

#Preview {
    CameraView()
}
