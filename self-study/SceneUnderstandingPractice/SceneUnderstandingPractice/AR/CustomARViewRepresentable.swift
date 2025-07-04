//
//  CustomARViewRepresentable.swift
//  SceneUnderstandingPractice
//
//  Created by 임영택 on 7/3/25.
//

import SwiftUI

struct CustomARViewRepresentable: UIViewRepresentable {
    @Binding var triggerLoad: Bool
    @Binding var triggerSave: Bool
    
    func makeUIView(context: Context) -> CustomARView {
        CustomARView(frame: .zero)
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
        if triggerSave {
            uiView.saveMap()
            
            DispatchQueue.main.async {
                self.triggerSave = false
            }
        }
        
        if triggerLoad {
            uiView.loadMap()
            
            DispatchQueue.main.async {
                self.triggerLoad = false
            }
        }
    }
}
