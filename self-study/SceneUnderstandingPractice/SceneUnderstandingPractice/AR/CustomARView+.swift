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
        
        //        planeAnchors.forEach { planeAnchor in
        //            print(planeAnchor)
        //
        //            let center = planeAnchor.center
        //
        //            let iterateCount: Int = 5
        //            let modelWidth: Float = 0.1
        //            let padding: Float = 0.1
        //            let startXPos: Float = center.x - Float(iterateCount / 2) * (modelWidth + padding)
        //            for i in 0..<iterateCount {
        //                let xPos = startXPos + Float(i) * (modelWidth + padding)
        //                let position = SIMD3<Float>(x: xPos, y: center.y, z: center.z)
        //
        //                let customAnchor = AnchorEntity(world: position)
        //                customAnchor.name = "ManualAnchor"
        //
        //                // Entity 추가
        //                let box = ModelEntity(mesh: .generateBox(size: modelWidth))
        //                customAnchor.addChild(box)
        //                self.scene.addAnchor(customAnchor)
        //            }
        //        }
    }
    
    func attachModelEntitiesToPlane(to planeAnchor: ARPlaneAnchor, in arView: ARView) {
        guard let frame = arView.session.currentFrame else { return }

        // MARK: Camera
        let cameraTransform = frame.camera.transform
        let cameraPosition = SIMD3<Float>(cameraTransform.columns.3.x,
                                           cameraTransform.columns.3.y,
                                           cameraTransform.columns.3.z)
        let cameraForward = -SIMD3<Float>(cameraTransform.columns.2.x,
                                           cameraTransform.columns.2.y,
                                           cameraTransform.columns.2.z)
        
        // 평면까지 거리
        let anchorPosition = SIMD3<Float>(planeAnchor.transform.columns.3.x,
                                          planeAnchor.transform.columns.3.y,
                                          planeAnchor.transform.columns.3.z)
        let distance = simd_distance(cameraPosition, anchorPosition)

        // 카메라 앞 distance 만큼 떨어진 지점에 포스트잇 배치
        let basePosition = cameraPosition + cameraForward * distance
        
        // 평면의 중심점과 크기 정보
        let planeCenter = planeAnchor.center
        let planeExtent = planeAnchor.extent
        
        // 평면의 변환 행렬
        let planeTransform = planeAnchor.transform
        
        // 5개의 ModelEntity 생성 및 배치
        let modelCount = 5
        
        for i in 0..<modelCount {
            let boxMesh = MeshResource.generateBox(size: [postItSize, postItSize, postItHeight])
            let material = SimpleMaterial(color: .green, isMetallic: false)
            let modelEntity = ModelEntity(mesh: boxMesh, materials: [material])
            
            let offsetX = Float(i - modelCount / 2) * planeExtent.x / 4.0
            let position = basePosition + SIMD3<Float>(offsetX, 0, 0) // 수평 정렬

            // 정면을 향하게 하고 싶으면 카메라 회전 유지
            let cameraRotation = simd_quatf(cameraTransform)
            
            modelEntity.transform = Transform(
                scale: .one,
                translation: position
            )
            
            let anchorEntity = AnchorEntity(world: position)
            anchorEntity.addChild(modelEntity)
            arView.scene.addAnchor(anchorEntity)
        }
        
        for i in 0..<modelCount {
            // 간단한 박스 모델 생성 (포스트잇 크기)
            let boxMesh = MeshResource.generateBox(size: [postItSize, postItHeight, postItSize]) // 50cm x 1cm x 50cm
            let material = SimpleMaterial(color: .red, isMetallic: false)
            let modelEntity = ModelEntity(mesh: boxMesh, materials: [material])
            
            // 평면 위에서의 로컬 위치 계산 (5개를 격자 형태로 배치)
            let row = i / 3 // 3개씩 한 줄
            let col = i % 3
            
            // 평면 크기를 고려한 위치 계산
            let spacingX = planeExtent.x / 4.0 // 평면 너비의 1/4씩 간격
            let spacingY = planeExtent.y / 3.0 // 평면 높이의 1/3씩 간격 (수직이므로 z가 높이)
            
            let localX = Float(col - 1) * spacingX // -1, 0, 1 위치 (좌우)
            let localY = Float(row - 1) * spacingY // -1, 0, 1 위치 (위아래)
            let localZ = Float(0.001) // 평면에서 살짝 앞으로 띄우기
            
            // 로컬 위치를 평면 좌표계 기준으로 설정 (수직 평면)
            let localPosition = SIMD3<Float>(localX, localY, localZ)
            
            // 평면의 월드 변환 행렬 적용
            let worldTransform = Transform(matrix: planeTransform)
            modelEntity.transform = Transform(
                scale: SIMD3<Float>(1, 1, 1),
                rotation: worldTransform.rotation,
                translation: worldTransform.translation +
                worldTransform.rotation.act(localPosition)
            )
            
            // 수직으로 세우기
            modelEntity.orientation = simd_quatf(angle: .pi/2, axis: SIMD3<Float>(0, 1, 0))
            
            // AnchorEntity 생성 및 평면 앵커에 연결
            let anchorEntity = AnchorEntity(anchor: planeAnchor)
            anchorEntity.addChild(modelEntity)
            
            // ARView에 추가
            arView.scene.addAnchor(anchorEntity)
        }
        
        for i in 0..<modelCount {
            // 간단한 박스 모델 생성 (포스트잇 크기)
            let boxMesh = MeshResource.generateBox(size: [postItSize, postItSize, postItHeight]) // 50cm x 50cm x 1cm
            let material = SimpleMaterial(color: .blue, isMetallic: false)
            let modelEntity = ModelEntity(mesh: boxMesh, materials: [material])
            
            // 평면 위에서의 로컬 위치 계산 (5개를 격자 형태로 배치)
            let row = i / 3 // 3개씩 한 줄
            let col = i % 3
            
            // 평면 크기를 고려한 위치 계산
            let spacingX = planeExtent.x / 4.0 // 평면 너비의 1/4씩 간격
            let spacingY = planeExtent.z / 3.0 // 평면 높이의 1/3씩 간격 (수직이므로 z가 높이)
            
            let localX = Float(col - 1) * spacingX // -1, 0, 1 위치 (좌우)
            let localY = Float(row - 1) * spacingY // -1, 0, 1 위치 (위아래)
            let localZ = Float(0.001) // 평면에서 살짝 앞으로 띄우기
            
            // 로컬 위치를 평면 좌표계 기준으로 설정 (수직 평면)
            let localPosition = SIMD3<Float>(localX, localY, localZ)
            
            // 평면의 월드 변환 행렬 적용
            let worldTransform = Transform(matrix: planeTransform)
            modelEntity.transform = Transform(
                scale: SIMD3<Float>(1, 1, 1),
                rotation: worldTransform.rotation,
                translation: worldTransform.translation +
                worldTransform.rotation.act(localPosition)
            )
            
            // AnchorEntity 생성 및 평면 앵커에 연결
            let anchorEntity = AnchorEntity(anchor: planeAnchor)
            anchorEntity.addChild(modelEntity)
            
            // ARView에 추가
            arView.scene.addAnchor(anchorEntity)
        }
    }
    
    func attachModelEntitiesToPlane(to planeAnchor: ARPlaneAnchor, in arView: ARView) {
        guard let frame = arView.session.currentFrame else { return }

        let planeExtent = planeAnchor.planeExtent
        let planeTransform = planeAnchor.transform
        
        // 5개의 ModelEntity 생성 및 배치
        let modelCount = 5
        
        for _ in 0..<modelCount {
            // 간단한 박스 모델 생성 (포스트잇 크기)
            let boxMesh = MeshResource.generateBox(size: [postItSize, postItHeight, postItSize]) // 50cm x 1cm x 50cm
            let material = SimpleMaterial(color: .red, isMetallic: false)
            let modelEntity = ModelEntity(mesh: boxMesh, materials: [material])
            
//            // 평면 위에서의 로컬 위치 계산 (5개를 격자 형태로 배치)
//            let row = i / 3 // 3개씩 한 줄
//            let col = i % 3
//            
//            // 평면 크기를 고려한 위치 계산
//            let spacingX = planeExtent.width / 4.0 // 평면 너비의 1/4씩 간격
//            let spacingY = planeExtent.height / 3.0 // 평면 높이의 1/3씩 간격 (수직이므로 z가 높이)
//            
//            let localX = Float(col - 1) * spacingX // -1, 0, 1 위치 (좌우)
//            let localY = Float(row - 1) * spacingY // -1, 0, 1 위치 (위아래)
//            let localZ = Float(0.001) // 평면에서 살짝 앞으로 띄우기
            
            let localX = Float.random(in: -planeExtent.width / 2...planeExtent.width / 2) // 원점을 기준으로 좌우
            let localY = Float.random(in: -planeExtent.height / 2...planeExtent.height / 2) // 원점을 기준으로 상하
            let localZ = Float(0.001) // 평면에서 살짝 앞으로 띄우기
            
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
