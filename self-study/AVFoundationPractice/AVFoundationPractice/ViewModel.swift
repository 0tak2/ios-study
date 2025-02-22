//
//  ViewModel.swift
//  AVFoundationPractice
//
//  Created by 임영택 on 2/22/25.
//

import Foundation
import AVFoundation
import SwiftUI

@Observable
class ViewModel {
    var currentFrame: CGImage?
    private let camera = Camera()
    
    func handleCameraPreviews() async {
        for await frame in camera.previewStream {
            Task { @MainActor in
                currentFrame = frame.cgImage
            }
        }
    }
    
    init() {
        Task {
            await camera.start()
            await handleCameraPreviews()
        }
    }
}

fileprivate extension CIImage {
    var cgImage: CGImage? {
        let ciContext = CIContext()
        return ciContext.createCGImage(self, from: self.extent)
    }
}
