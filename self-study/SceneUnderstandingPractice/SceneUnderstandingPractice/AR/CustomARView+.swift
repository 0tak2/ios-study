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
    
    // TODO: 자동으로 N 장의 카드를 겹치지 않게 배치하기
    // TODO: 카드가 평면을 벗어나지 않게 하기
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
        
        let anchorEntity = AnchorEntity(anchor: planeAnchor)
        for _ in 0..<modelCount {
            // 간단한 박스 모델 생성 (포스트잇 크기)
            let boxMesh = MeshResource.generateBox(size: [postItSize, postItHeight, postItSize]) // 50cm x 1cm x 50cm
            let material = SimpleMaterial(color: .red, isMetallic: false)
            let modelEntity = ModelEntity(mesh: boxMesh, materials: [material])
            modelEntity.components[LearningCardComponent.self] = LearningCardComponent()
            
            let widthEndPoint = (planeExtent.width - postItSize) / 2
            let heightEndPoint = (planeExtent.height - postItSize) / 2
            
            let localX = Float.random(in: -widthEndPoint...widthEndPoint) // 원점을 기준으로 좌우
            let localY = Float(0.001) // 평면에서 살짝 앞으로 띄우기 => 수직 평면이므로 Y값을 조정하면 법선으로부터 튀어나오는 효과
            let localZ = Float.random(in: -heightEndPoint...heightEndPoint) // 원점을 기준으로 상하
            
            // 로컬 위치를 평면 좌표계 기준으로 설정 (수직 평면)
            let localPosition = SIMD3<Float>(localX, localY, localZ)
            modelEntity.position = localPosition

            // Anchor에 AnchorEntity 연결
            anchorEntity.addChild(modelEntity)
            
            let globalPosition = modelEntity.position(relativeTo: nil)
            guard !alreadyPostItExist(of: globalPosition) else {
                print("skip add modelEntity")
                modelEntity.removeFromParent()
                return
            }
            print("added modelEntity")
            
            // ARView에 추가
            arView.scene.addAnchor(anchorEntity)
        }
    }
    
    func alreadyPostItExist(of position: SIMD3<Float>) -> Bool {
        let newMin = SIMD3<Float>(
            position.x - postItSize / 2,
            position.y - postItHeight / 2,
            position.z - postItSize / 2
        )
        let newMax = SIMD3<Float>(
            position.x + postItSize / 2,
            position.y + postItHeight / 2,
            position.z + postItSize / 2
        )
        
        let query = EntityQuery(where: .has(LearningCardComponent.self))
        
        for entity in self.scene.performQuery(query) {
            let existingPos = entity.position(relativeTo: nil)
            
            let existingMin = SIMD3<Float>(
                existingPos.x - postItSize / 2,
                existingPos.y - postItHeight / 2,
                existingPos.z - postItSize / 2
            )
            let existingMax = SIMD3<Float>(
                existingPos.x + postItSize / 2,
                existingPos.y + postItHeight / 2,
                existingPos.z + postItSize / 2
            )

            let isOverlapping = (newMin.x <= existingMax.x && newMax.x >= existingMin.x) &&
                                (newMin.y <= existingMax.y && newMax.y >= existingMin.y) &&
                                (newMin.z <= existingMax.z && newMax.z >= existingMin.z)

            if isOverlapping {
                print("중첩 발견: \(position) overlaps with \(existingPos)")
                return true // 이미 있음
            }
        }
        
        return false
    }
}
