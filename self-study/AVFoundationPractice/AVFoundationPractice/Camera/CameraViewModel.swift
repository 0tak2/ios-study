//
//  CameraViewModel.swift
//  AVFoundationPractice
//
//  Created by 임영택 on 2/22/25.
//

import Foundation
import AVFoundation
import SwiftUI

@Observable
class CameraViewModel {
    var currentFrame: CGImage?
    private let camera = Camera()
    
    init() {
        Task {
            await camera.start()
            await handleCameraPreviews()
        }
    }
    
    func handleCameraPreviews() async {
        for await frame in camera.previewStream {
            Task { @MainActor in
                currentFrame = frame.cgImage
            }
        }
    }
    
    func switchDevice() {
        camera.switchCaptureDevice()
    }
}

fileprivate extension CIImage {
    var cgImage: CGImage? {
        let ciContext = CIContext()
        return ciContext.createCGImage(self, from: self.extent)
    }
}
