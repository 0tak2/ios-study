//
//  CameraView.swift
//  AVFoundationPractice
//
//  Created by 임영택 on 2/22/25.
//

import SwiftUI

struct ViewFinderView: View {
    @Environment(CameraViewModel.self) var viewModel
    
    var body: some View {
        GeometryReader { geometry in
            if let image = viewModel.currentFrame {
                Image(decorative: image, scale: 1)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            } else {
                ContentUnavailableView("No camera feed", systemImage: "xmark.circle.fill")
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    @Previewable @State var image: CGImage? = nil
    ViewFinderView()
        .environment(CameraViewModel())
}
