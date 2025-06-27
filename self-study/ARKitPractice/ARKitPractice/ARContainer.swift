//
//  ARContainer.swift
//  ARKitPractice
//
//  Created by 임영택 on 6/26/25.
//

import SwiftUI

struct ARContainer: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        ARContainerViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
}
