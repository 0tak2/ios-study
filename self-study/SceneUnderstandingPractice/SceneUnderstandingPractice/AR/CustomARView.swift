//
//  CustomARView.swift
//  SceneUnderstandingPractice
//
//  Created by 임영택 on 7/3/25.
//

import Foundation
import ARKit
import RealityKit
import Combine

class CustomARView: ARView {
    private var subscriptions: [Cancellable] = []
    
    // MARK: - Persistence: Saving and Loading
    lazy var mapSaveURL: URL = {
        do {
            return try FileManager.default
                .url(for: .documentDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: true)
                .appendingPathComponent("map.arexperience")
        } catch {
            fatalError("Can't get file save URL: \(error.localizedDescription)")
        }
    }()
    
    var captureButtonDidTap: (() -> Void)?
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.environment.sceneUnderstanding.options.insert(.occlusion)
        self.environment.sceneUnderstanding.options.insert(.receivesLighting)
        
        subscriptions.append(
            self.scene.subscribe(to: SceneEvents.Update.self, onUpdate)
        )
        
        resetSession()
    }
    
    func resetSession(initialWorldMap: ARWorldMap? = nil) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.vertical] // 평면 감지
        self.debugOptions = [
//            .showAnchorGeometry,
            .showFeaturePoints,
            .showWorldOrigin,
        ]
        self.session.run(configuration)
    }
    
    private func onUpdate(_ event: Event) {
        // logics by every frame updated
        
        // MARK: - 이전에 그렸던 엔티티를 제거한다.
        let query = EntityQuery(where: .has(DetectedPlaneComponent.self))
        self.scene.performQuery(query).forEach { entity in
            if let entity = entity as? AnchorEntity {
                print("entity deleted - \(entity.debugDescription.replacingOccurrences(of: "\n", with: ""))")
                self.scene.removeAnchor(entity)
            }
        }
        
        // MARK: - 평면을 그린다.
        session.currentFrame?.anchors.forEach { anchor in
            if let planeAnchor = anchor as? ARPlaneAnchor {
                
                // 테두리용 재질
                var borderMaterial = UnlitMaterial()
                borderMaterial.color = .init(tint: .green)
                
                let frameThickness: Float = 0.005
                let width = planeAnchor.planeExtent.width
                let height = planeAnchor.planeExtent.height
                
                // 평면의 방향에 따라 박스 크기와 방향 결정
                var topFrameSize: SIMD3<Float>
                var bottomFrameSize: SIMD3<Float>
                var leftFrameSize: SIMD3<Float>
                var rightFrameSize: SIMD3<Float>
                
                if planeAnchor.alignment == .vertical {
                    // 수직 평면 (벽) - Z축이 높이가 됨
                    topFrameSize = SIMD3<Float>(width, 0.01, frameThickness)
                    bottomFrameSize = SIMD3<Float>(width, 0.01, frameThickness)
                    leftFrameSize = SIMD3<Float>(frameThickness, 0.01, height)
                    rightFrameSize = SIMD3<Float>(frameThickness, 0.01, height)
                } else {
                    // 수평 평면 (바닥/천장) - Y축이 높이가 됨
                    topFrameSize = SIMD3<Float>(width, frameThickness, 0.01)
                    bottomFrameSize = SIMD3<Float>(width, frameThickness, 0.01)
                    leftFrameSize = SIMD3<Float>(frameThickness, height, 0.01)
                    rightFrameSize = SIMD3<Float>(frameThickness, height, 0.01)
                }
                
                // 테두리 프레임 생성
                let topFrame = ModelEntity(mesh: MeshResource.generateBox(size: topFrameSize), materials: [borderMaterial])
                let bottomFrame = ModelEntity(mesh: MeshResource.generateBox(size: bottomFrameSize), materials: [borderMaterial])
                let leftFrame = ModelEntity(mesh: MeshResource.generateBox(size: leftFrameSize), materials: [borderMaterial])
                let rightFrame = ModelEntity(mesh: MeshResource.generateBox(size: rightFrameSize), materials: [borderMaterial])
                
                // 프레임 위치 설정
                if planeAnchor.alignment == .vertical {
                    // 수직 평면일 때의 위치
                    topFrame.transform.translation = SIMD3<Float>(0, 0, height/2 - frameThickness/2)
                    bottomFrame.transform.translation = SIMD3<Float>(0, 0, -height/2 + frameThickness/2)
                    leftFrame.transform.translation = SIMD3<Float>(-width/2 + frameThickness/2, 0, 0)
                    rightFrame.transform.translation = SIMD3<Float>(width/2 - frameThickness/2, 0, 0)
                } else {
                    // 수평 평면일 때의 위치
                    topFrame.transform.translation = SIMD3<Float>(0, height/2 - frameThickness/2, 0)
                    bottomFrame.transform.translation = SIMD3<Float>(0, -height/2 + frameThickness/2, 0)
                    leftFrame.transform.translation = SIMD3<Float>(-width/2 + frameThickness/2, 0, 0)
                    rightFrame.transform.translation = SIMD3<Float>(width/2 - frameThickness/2, 0, 0)
                }
                
                // AnchorEntity 생성 및 평면 앵커에 연결
                let anchorEntity = AnchorEntity(anchor: planeAnchor)
                
                // 프레임들을 앵커에 추가
                anchorEntity.addChild(topFrame)
                anchorEntity.addChild(bottomFrame)
                anchorEntity.addChild(leftFrame)
                anchorEntity.addChild(rightFrame)
                
                anchorEntity.components[DetectedPlaneComponent.self] = DetectedPlaneComponent()
                
                // ARView에 추가
                self.scene.addAnchor(anchorEntity)
            }
        }
    }
}
