//
//  CustomARViewRepresentable.swift
//  SceneUnderstandingPractice
//
//  Created by 임영택 on 7/3/25.
//

import SwiftUI

struct CustomARViewRepresentable: UIViewRepresentable {
    @Binding var triggerAttach: Bool
    
    func makeUIView(context: Context) -> CustomARView {
        CustomARView(frame: .zero)
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
        if triggerAttach {
            uiView.attachToPlane()
            
            DispatchQueue.main.async {
                self.triggerAttach = false
            }
        }
    }
}
