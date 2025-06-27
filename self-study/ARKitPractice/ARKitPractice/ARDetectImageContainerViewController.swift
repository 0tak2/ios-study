//
//  ARDetectImageContainerViewController.swift
//  ARKitPractice
//
//  Created by 임영택 on 6/26/25.
//

import UIKit
import ARKit

class ARDetectImageContainerViewController: UIViewController {
    // MARK: - ARKit Scene
    let sceneView = ARSCNView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        setLayout()
    }
    
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! +
        ".serialSceneKitQueue")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }

        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors]) // MARK: run a ARKit session
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause() // MARK: pause the session
    }
}

/// MARK: - Layout
extension ARDetectImageContainerViewController {
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
extension ARDetectImageContainerViewController {

}

/// MARK: - Delegate
extension ARDetectImageContainerViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        updateQueue.async {
            // Add the box visualization to the scene.
//            let box = SCNBox(width: 5, height: 5, length: 5, chamferRadius: 0.0) // 1 = 1 meter
//            let boxNode = SCNNode(geometry: box)
//            boxNode.geometry = box
//            node.addChildNode(boxNode)
            
            let scene = SCNScene(named: "seahorse.usdz")!
            let sceneContainerNode = SCNNode()
            scene.rootNode.childNodes.forEach { node in
                sceneContainerNode.addChildNode(node)
            }
            node.addChildNode(sceneContainerNode)
        }
    }
}
