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

extension ARContainerViewController {
    // MARK: - Layout
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
