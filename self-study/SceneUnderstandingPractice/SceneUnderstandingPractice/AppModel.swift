//
//  AppModel.swift
//  SceneUnderstandingPractice
//
//  Created by 임영택 on 7/15/25.
//

import Foundation
import Combine

class AppModel: ObservableObject {
    @Published var currentGameMode: GameManager.GameMode = .initialized
    @Published var attachedCardsCount: Int = 0
    
    private var subscriptions: [AnyCancellable] = []
    
    init() {
        GameManager.instance.currentModePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] gameMode in
                self?.currentGameMode = gameMode
            }
            .store(in: &subscriptions)
        
        GameManager.instance.attachedCardsCountPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] attachedCardsCount in
                self?.attachedCardsCount = attachedCardsCount
            }
            .store(in: &subscriptions)
    }
}
