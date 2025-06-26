//
//  ARContainerViewController.swift
//  ARKitPractice
//
//  Created by 임영택 on 6/26/25.
//

import UIKit
import ARKit

class ARContainerViewController: UIViewController {
    // GQ: SwiftUI에 바로 통합된 API는 없나?
    
    // MARK: - ARKit Scene
    let sceneView = ARSCNView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        prepareARSceneView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration() // ARConfiguration의 하위 타입 중 WorldTracking 선택 - GQ: 다른 트래킹 방법에는 뭐가 있지?
        sceneView.session.run(configuration) // MARK: run a ARKit session
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause() // MARK: pause the session
    }
}

/// MARK: - Layout
extension ARContainerViewController {
    private func setLayout() {
        view.addSubview(sceneView)
        
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

/// MARK: - Configure the scene
extension ARContainerViewController {
    private func prepareARSceneView() {
        addBox()
        addTapGestureToSceneView()
    }
    
    private func addBox() {
        // create a SceneKit geometry object
        let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0.0) // 1 = 1 meter
        
        // create a SceneKit node with the box geometry
        let boxNode = SCNNode(geometry: box)
        boxNode.geometry = box
        boxNode.position = SCNVector3(0, 0, -0.2)
        
        // add the node to scene
//        let scene = SCNScene()
//        scene.rootNode.addChildNode(boxNode)
//        sceneView.scene = scene
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
    private func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sceneViewDidTap))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func sceneViewDidTap(recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, options: nil) // ARSCNView에 탭 좌표를 넘기면 힛 테스트가 가능
        
        if let node = hitTestResults.first?.node {
            node.removeFromParentNode()
        }
    }
}
