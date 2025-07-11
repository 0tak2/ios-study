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
    var postItSize: Float { 0.2 }
    var postItHeight: Float { 0.01 }
    
    func attachToPlane() {
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)

        if let query = self.makeRaycastQuery(from: center, allowing: .existingPlaneGeometry, alignment: .any),
           let result = self.session.raycast(query).first,
           let anchorID = result.anchor?.identifier {

            if let planeAnchor = self.session.currentFrame?.anchors.first(where: {
                $0.identifier == anchorID && $0 is ARPlaneAnchor
            }) as? ARPlaneAnchor {
                print("Plane anchor found: \(planeAnchor)")
                print("Center: \(planeAnchor.center), Extent: \(planeAnchor.planeExtent)")
                
                attachModelEntitiesToPlane(to: planeAnchor, in: self)
            }
        }
    }
    
    func attachModelEntitiesToPlane(to planeAnchor: ARPlaneAnchor, in arView: ARView) {
        let planeExtent = planeAnchor.planeExtent
        
        // 5개의 ModelEntity 생성 및 배치
        let modelCount = 5
        
        for _ in 0..<modelCount {
            // 간단한 박스 모델 생성 (포스트잇 크기)
            let boxMesh = MeshResource.generateBox(size: [postItSize, postItHeight, postItSize]) // 50cm x 1cm x 50cm
            let material = SimpleMaterial(color: .red, isMetallic: false)
            let modelEntity = ModelEntity(mesh: boxMesh, materials: [material])
            
            let localX = Float.random(in: -planeExtent.width / 2...planeExtent.width / 2) // 원점을 기준으로 좌우
            let localY = Float(0.001) // 평면에서 살짝 앞으로 띄우기 => 수직 평면이므로 Y값을 조정하면 법선으로부터 튀어나오는 효과
            let localZ = Float.random(in: -planeExtent.height / 2...planeExtent.height / 2) // 원점을 기준으로 상하
            
            // 로컬 위치를 평면 좌표계 기준으로 설정 (수직 평면)
            let localPosition = SIMD3<Float>(localX, localY, localZ)
            modelEntity.position = localPosition
            
            // AnchorEntity 생성 및 평면 앵커에 연결
            let anchorEntity = AnchorEntity(anchor: planeAnchor)
            anchorEntity.addChild(modelEntity)
            
            // ARView에 추가
            arView.scene.addAnchor(anchorEntity)
        }
    }
}
