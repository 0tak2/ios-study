//
//  CustomARView+ARSessionDelegate.swift
//  SceneUnderstandingPractice
//
//  Created by 임영택 on 7/5/25.
//

import Foundation
import ARKit

extension CustomARView: ARSessionDelegate {
    /// MARK: 평면 앵커가 추가되면 로깅
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        anchors.compactMap { $0 as? ARPlaneAnchor }
            .forEach { planeAnchor in
                let center = planeAnchor.center // simd_float3 (x, 0, z)
                let extent = planeAnchor.planeExtent // ARPlaneExtent
                
                print("Added ARPlaneAnchor: center(\(center)), extent(\(extent))")
            }
    }
}
