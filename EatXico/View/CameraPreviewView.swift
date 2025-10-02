//
//  CameraPreviewView.swift
//  EatXico
//
//  Created by Alan Cervantes on 02/10/25.
//

import SwiftUI
import AVFoundation

private final class CameraPreview: UIView {
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    init(session: AVCaptureSession) {
        super.init(frame: .zero)
        videoPreviewLayer.session = session
        videoPreviewLayer.videoGravity = .resizeAspectFill
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) no implementado")
    }
}

struct CameraPreviewView: UIViewRepresentable {
    var session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        CameraPreview(session: session)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let preview = uiView as? CameraPreview {
            if preview.videoPreviewLayer.session !== session {
                preview.videoPreviewLayer.session = session
            }
        }
    }
}

