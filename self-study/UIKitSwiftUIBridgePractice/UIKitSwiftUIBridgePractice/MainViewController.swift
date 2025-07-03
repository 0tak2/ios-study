//
//  MainViewController.swift
//  UIKitSwiftUIBridgePractice
//
//  Created by 임영택 on 7/3/25.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {
    var messageView: MessageView!
    var message: String = "Hello, World" {
        didSet {
            messageLabel.text = message
        }
    }
    let messageLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        messageView = MessageView(message: Binding(get: {
            self.message
        }, set: { newValue in
            self.message = newValue
        }))
        
        let messageViewHostingContoller = UIHostingController(rootView: messageView)
        
        view.addSubview(messageViewHostingContoller.view)
        view.addSubview(messageLabel)
        
        messageViewHostingContoller.view.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageViewHostingContoller.view.topAnchor.constraint(equalTo: view.topAnchor),
            messageViewHostingContoller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageViewHostingContoller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageViewHostingContoller.view.heightAnchor.constraint(equalToConstant: 150),
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: messageViewHostingContoller.view.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
