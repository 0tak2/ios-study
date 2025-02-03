//
//  ViewController.swift
//  UIPractice
//
//  Created by 임영택 on 2/3/25.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presentBeaulabVC()
    }
    
    private func presentBeaulabVC() {
        let vc = BeaulabMyPageViewController()
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.title = "마이페이지"
        
        let window = view.window
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

