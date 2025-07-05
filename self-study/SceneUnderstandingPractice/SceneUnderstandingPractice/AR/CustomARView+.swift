//
//  CustomARView+.swift
//  SceneUnderstandingPractice
//
//  Created by 임영택 on 7/5/25.
//

import Foundation
import ARKit
import RealityKit

extension CustomARView {
    func attachToPlane() {
        guard let anchors = self.session.currentFrame?.anchors else {
            print("No anchors in currentFrame")
            return
        }
        
        let planeAnchors = anchors.compactMap { $0 as? ARPlaneAnchor }
        guard !planeAnchors.isEmpty else {
            print("No plane anchors in currentFrame")
            return
        }
        
        planeAnchors.forEach { planeAnchor in
            let center = planeAnchor.center
            
            let iterateCount: Int = 5
            let modelWidth: Float = 0.1
            let padding: Float = 0.1
            let startXPos: Float = center.x - Float(iterateCount / 2) * (modelWidth + padding)
            for i in 0..<iterateCount {
                let xPos = startXPos + Float(i) * (modelWidth + padding)
                let position = SIMD3<Float>(x: xPos, y: center.y, z: center.z)
                
                let customAnchor = AnchorEntity(world: position)
                customAnchor.name = "ManualAnchor"
                
                // Entity 추가
                let box = ModelEntity(mesh: .generateBox(size: modelWidth))
                customAnchor.addChild(box)
                self.scene.addAnchor(customAnchor)
            }
        }
    }
}
