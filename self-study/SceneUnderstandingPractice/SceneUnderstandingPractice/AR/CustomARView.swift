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
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.environment.sceneUnderstanding.options.insert(.occlusion)
        self.environment.sceneUnderstanding.options.insert(.physics)
        self.environment.sceneUnderstanding.options.insert(.collision)
        self.environment.sceneUnderstanding.options.insert(.receivesLighting)
        
        subscriptions.append(
            self.scene.subscribe(to: SceneEvents.Update.self, onUpdate)
        )
        
        resetSession()
    }
    
    private func resetSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal] // 수평 평면 감지
        configuration.sceneReconstruction = .mesh
        self.session.run(configuration)
    }
    
    private func onUpdate(_ event: Event) {
        var debugMaterial = UnlitMaterial(color: .green)
        debugMaterial.triangleFillMode = .lines
        
        let sceneUnderstandingQuery = EntityQuery(where: .has(SceneUnderstandingComponent.self) && .has(ModelComponent.self))
        let queryResult = self.scene.performQuery(sceneUnderstandingQuery)
        queryResult.forEach { entity in
            entity.components[ModelComponent.self]?.materials = [debugMaterial]
        }
    }
}
