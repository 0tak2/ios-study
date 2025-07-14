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
        //        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        //
        //        if let query = self.makeRaycastQuery(from: center, allowing: .existingPlaneGeometry, alignment: .any),
        //           let result = self.session.raycast(query).first,
        //           let anchorID = result.anchor?.identifier {
        //
        //            if let planeAnchor = self.session.currentFrame?.anchors.first(where: {
        //                $0.identifier == anchorID && $0 is ARPlaneAnchor
        //            }) as? ARPlaneAnchor {
        //                print("Plane anchor found: \(planeAnchor)")
        //                print("Center: \(planeAnchor.center), Extent: \(planeAnchor.planeExtent)")
        //
        //                attachModelEntitiesToPlane(to: planeAnchor, in: self)
        //            }
        //        }
        self.session.currentFrame?.anchors.forEach { anchor in
            if let planeAnchor = anchor as? ARPlaneAnchor {
                attachModelEntitiesToPlane(to: planeAnchor, in: self)
            }
        }
    }
    
    func createCardEntity() -> ModelEntity {
        let boxMesh = MeshResource.generateBox(size: [postItSize, postItHeight, postItSize]) // 50cm x 1cm x 50cm
        let material = SimpleMaterial(color: .red, isMetallic: false)
        let modelEntity = ModelEntity(mesh: boxMesh, materials: [material])
        modelEntity.components[LearningCardComponent.self] = LearningCardComponent()
        //        modelEntity.components[CollisionComponent.self] = CollisionComponent(
        //          shapes: [.generateBox(size: [postItSize, postItHeight, postItSize])],
        //          mode: .trigger,
        //          filter: .sensor
        //        ) // => 안된다
        modelEntity.generateCollisionShapes(recursive: true)
        
        let beginEventSub = self.scene.subscribe(
            to: CollisionEvents.Began.self,
            on: modelEntity
        ) { [weak self] event in
            // 충돌이 감지되면 한 쪽 엔티티를 제거한다
            //            modelEntity.model?.materials = [SimpleMaterial(color: .blue, isMetallic: false)]
            print("collision started")
            event.entityB.removeFromParent()
            self?.collisionSubscriptions.removeValue(forKey: event.entityB)
        }
        collisionSubscriptions[modelEntity] = beginEventSub
        
        return modelEntity
    }
    
    func attachModelEntitiesToPlane(to planeAnchor: ARPlaneAnchor, in arView: ARView) {
        let planeExtent = planeAnchor.planeExtent
        guard planeExtent.width >= postItSize && planeExtent.height >= postItSize else {
            print("skip the plane because it is too small")
            return
        }
        
        // 5개의 ModelEntity 생성 및 배치
        let modelCount = 1
        
        let anchorEntity = AnchorEntity(anchor: planeAnchor)
        
        let widthRangeEnd = (planeExtent.width - postItSize) / 2
        let heightRangedEnd = (planeExtent.height - postItSize) / 2
        for _ in 0..<modelCount {
            // 간단한 박스 모델 생성 (포스트잇 크기)
            let modelEntity = createCardEntity()
            
            let localX = Float.random(in: -widthRangeEnd...widthRangeEnd) // 원점을 기준으로 좌우
            let localY = Float(0.001) // 평면에서 살짝 앞으로 띄우기 => 수직 평면이므로 Y값을 조정하면 법선으로부터 튀어나오는 효과
            let localZ = Float.random(in: -heightRangedEnd...heightRangedEnd) // 원점을 기준으로 상하
            
            // 로컬 위치를 평면 좌표계 기준으로 설정 (수직 평면)
            let localPosition = SIMD3<Float>(localX, localY, localZ)
            modelEntity.position = localPosition
            
            // Anchor에 AnchorEntity 연결
            anchorEntity.addChild(modelEntity)
            arView.scene.addAnchor(anchorEntity)
            print("added modelEntity")
            
            // 중첩되는 포스트잇이라면 다시 제거
            if alreadyPostItExist(of: modelEntity) {
                print("remove modelEntity")
                modelEntity.removeFromParent()
            }
        }
    }
    
    func alreadyPostItExist(of newEntiy: ModelEntity) -> Bool {
        let newPos = newEntiy.position(relativeTo: nil)
        
        let newMin = SIMD3<Float>(
            newPos.x - postItSize / 2,
            newPos.y - postItHeight / 2,
            newPos.z - postItSize / 2
        )
        let newMax = SIMD3<Float>(
            newPos.x + postItSize / 2,
            newPos.y + postItHeight / 2,
            newPos.z + postItSize / 2
        )
        
        let query = EntityQuery(where: .has(LearningCardComponent.self))
        
        for entity in self.scene.performQuery(query) {
            guard newEntiy !== entity else { continue }
            
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
            
            print("=== Overlap Check ===")
            print("New: pos=\(newPos), min=\(newMin), max=\(newMax)")
            print("Existing: pos=\(existingPos), min=\(existingMin), max=\(existingMax)")
            print("X overlap: \(newMin.x) <= \(existingMax.x) && \(newMax.x) >= \(existingMin.x) = \(newMin.x <= existingMax.x && newMax.x >= existingMin.x)")
            print("Y overlap: \(newMin.y) <= \(existingMax.y) && \(newMax.y) >= \(existingMin.y) = \(newMin.y <= existingMax.y && newMax.y >= existingMin.y)")
            print("Z overlap: \(newMin.z) <= \(existingMax.z) && \(newMax.z) >= \(existingMin.z) = \(newMin.z <= existingMax.z && newMax.z >= existingMin.z)")
            print("Final result: \(isOverlapping)")
            
            if isOverlapping {
                print("중첩 발견: \(newPos) overlaps with \(existingPos)")
                return true // 이미 있음
            }
            print("중첩 아님: \(newPos) does not overlap with \(existingPos)")
        }
        
        return false
    }
}
