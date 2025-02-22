//
//  CameraView.swift
//  AVFoundationPractice
//
//  Created by 임영택 on 2/22/25.
//

import SwiftUI

struct CameraView: View {
    @Binding var image: CGImage?
    
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                Image(decorative: image, scale: 1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            } else {
                ContentUnavailableView("No camera feed", systemImage: "xmark.circle.fill")
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

#Preview {
    @Previewable @State var image: CGImage? = nil
    CameraView(image: $image)
}
