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
        configuration.planeDetection = [.horizontal, .vertical] // 평면 감지
        self.session.run(configuration)
    }
    
    private func onUpdate(_ event: Event) {
        // logics by every frame updated
    }
}
