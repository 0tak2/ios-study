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

class ARContainerViewController: UIViewController {
    private let arView = ARView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupARView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
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
        resetSession()
        
        // Debug 옵션
//        arView.debugOptions = [.showAnchorOrigins, .showAnchorGeometry, .showFeaturePoints]
        
        // 평면에 큐브 추가
        addCubeModel()
    }
    
    private func resetSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal] // 수평 평면 감지
        arView.session.run(configuration)
    }
    
    private func addCubeModel() {
        // Create a cube model
        let model = Entity()
        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
        let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
        model.components.set(ModelComponent(mesh: mesh, materials: [material]))
        model.position = [0, 0.05, 0]
        
        // Create horizontal plane anchor for the content
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        anchor.addChild(model)
        
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
