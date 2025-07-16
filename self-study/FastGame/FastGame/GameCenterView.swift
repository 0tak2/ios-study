//
//  GameCenterView.swift
//  FastGame
//
//  Created by 임영택 on 7/16/25.
//

import SwiftUI
import GameKit

struct GameCenterView: UIViewControllerRepresentable {
    private let viewController: GKGameCenterViewController
    
    init(viewController: GKGameCenterViewController = GKGameCenterViewController()) {
        self.viewController = GKGameCenterViewController(state: .default)
    }
    
    func makeUIViewController(context: Context) -> GKGameCenterViewController {
        let gkVC = viewController
//        gkVC.gameCenterDelegate = context.coordinator
        return gkVC
    }
    
    func updateUIViewController(_ uiViewController: GKGameCenterViewController, context: Context) {
        return
    }
}

#Preview {
    GameCenterView()
}
