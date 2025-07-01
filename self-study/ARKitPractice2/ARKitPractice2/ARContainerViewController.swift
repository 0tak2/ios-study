//
//  ARContainerViewController.swift
//  ARKitPractice2
//
//  Created by 임영택 on 6/30/25.
//

import UIKit
import ARKit
import RealityKit
import SwiftUI
import Combine
import Basketball

class ARContainerViewController: UIViewController {
    private let arView = ARView()
    private var subscription: Cancellable?
    private let ballRadius: Float = 0.12
    private var showingMesh = false
    private var feedback = UIImpactFeedbackGenerator()
    private var previousQueryResult: QueryResult<Entity>?
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    private let ballEntityName = "ball_basketball_realistic"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupARView()
        
        self.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            showingMesh.toggle()
            feedback.prepare()
            feedback.impactOccurred(intensity: 1)
        }
    }
}

/// MARK: UI
extension ARContainerViewController {
    private func setupLayout() {
        arView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(arView)
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

/// MARK: AR
extension ARContainerViewController {
    private func setupARView() {
        arView.environment.sceneUnderstanding.options.insert(.occlusion)
        arView.environment.sceneUnderstanding.options.insert(.physics)
        arView.environment.sceneUnderstanding.options.insert(.collision)
        arView.environment.sceneUnderstanding.options.insert(.receivesLighting)
        
        subscription = arView.scene.subscribe(to: SceneEvents.Update.self, onUpdate)
        
        resetSession()
        
        // Debug 옵션
        //        arView.debugOptions = [.showAnchorOrigins, .showAnchorGeometry, .showFeaturePoints]
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        arView.addGestureRecognizer(tapRecognizer)
    }
    
    /// 디버깅을 위해 sceneUnderstandingQuery를 찾고 텍스쳐를 씌운다
    private func onUpdate(_ event: Event) {
        guard showingMesh else {
            if let previousQueryResult = previousQueryResult {
                previousQueryResult.forEach { entity in
                    entity.components[ModelComponent.self]?.materials = []
                }
            }
            return
        }
        
        var debugMaterial = UnlitMaterial(color: .green)
        debugMaterial.triangleFillMode = .lines
        
        let sceneUnderstandingQuery = EntityQuery(where: .has(SceneUnderstandingComponent.self) && .has(ModelComponent.self))
        let queryResult = arView.scene.performQuery(sceneUnderstandingQuery)
        previousQueryResult = queryResult
        queryResult.forEach { entity in
            entity.components[ModelComponent.self]?.materials = [debugMaterial]
        }
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let tapLocation: CGPoint = sender.location(in: arView)
        
        let hitTestResult = arView.hitTest(tapLocation)
        var didApplyImpulse = false
        hitTestResult.forEach { result in
//            print(result.entity)
            if result.entity.name == ballEntityName {
                // ModelEntity를 찾지 말고, PhysicsBodyComponent가 있는 엔티티에 직접 impulse 적용
                if result.entity.components[PhysicsBodyComponent.self] != nil {
                    if let physicsEntity = result.entity as? HasPhysics,
                       result.entity.components[PhysicsBodyComponent.self] != nil {
                        let impulse = SIMD3<Float>(0, 2, -5)
                        physicsEntity.applyLinearImpulse(impulse, relativeTo: nil)
                        didApplyImpulse = true
                        print("Applied impulse to physics entity")
                    }
                }
            }
        }
        guard !didApplyImpulse else {
            return
        }
        
        let estimatedPlane: ARRaycastQuery.Target = .estimatedPlane
        let alignment: ARRaycastQuery.TargetAlignment = .horizontal
        
        let result: [ARRaycastResult] = arView.raycast(from: tapLocation,
                                                       allowing: estimatedPlane,
                                                       alignment: alignment)
        
        if let planeRaycastResult = result.first {
            addBall(at: planeRaycastResult.worldTransform)
            return
        }
    }
    
    private func findFirstChildModelEntity(in parent: Entity) -> ModelEntity? {
        if let model = parent as? ModelEntity {
            return model
        }
        
        for child in parent.children {
            if let found = findFirstChildModelEntity(in: child) {
                return found
            }
        }
        
        return nil
    }
    
    private func resetSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal] // 수평 평면 감지
        configuration.sceneReconstruction = .mesh
        arView.session.run(configuration)
    }
    
    private func addBall(at position: float4x4) {
        // Create a ball
        let entity = try! Entity.load(named: "Scene", in: basketballBundle)
        let anchor = AnchorEntity(world: position)
        anchor.addChild(entity)
        
        arView.scene.anchors.append(anchor)
    }
}

struct ARContainerView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ARContainerViewController {
        ARContainerViewController()
    }
    
    func updateUIViewController(_ uiViewController: ARContainerViewController, context: Context) {
    }
}
