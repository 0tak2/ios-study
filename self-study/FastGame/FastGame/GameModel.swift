//
//  GameModel.swift
//  FastGame
//
//  Created by 임영택 on 7/16/25.
//

import Foundation

class GameModel: ObservableObject {
    @Published var cardCount: Int?
    @Published var mode = GameMode.notConfigured
    @Published var selectedLevel = GameLevel.easy
    var startTime: Date?
    @Published var tappedCardIndices = [Int]()
    @Published var elapsedTime: TimeInterval = 0
    private var timer: Timer?
    
    @Published var lastGameResult: LastGameResult?
    
    func startGame() {
        mode = .playing
        startTime = Date()
        cardCount = selectedLevel.cardCount
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self,
            let startTime = self.startTime else { return }
            self.elapsedTime = Date().timeIntervalSince1970 - startTime.timeIntervalSince1970
        }
    }
    
    func endGame() {
        timer?.invalidate()
        timer = nil
        
        mode = .finish
        
        lastGameResult = .init(elapsedTime: elapsedTime, level: selectedLevel)
        
        elapsedTime = 0
        tappedCardIndices = []
        cardCount = nil
        selectedLevel = .easy
    }
    
    func resetGame() {
        mode = .notConfigured
    }
    
    func cardTapped(at index: Int) {
        guard let cardCount = cardCount else {
            print("❌ Game not configured")
            return
        }
        
        tappedCardIndices.append(index)
        
        if tappedCardIndices.count == cardCount {
            endGame()
        }
    }
    
    enum GameMode {
        case notConfigured
        case playing
        case finish
    }
    
    enum GameLevel: CaseIterable {
        case easy
        case medium
        case hard
        
        var cardCount: Int {
            switch self {
            case .easy:
                return 8
            case .medium:
                return 16
            case .hard:
                return 32
            }
        }
        
        var localizedDescription: String {
            switch self {
            case .easy:
                return "Easy"
            case .medium:
                return "Medium"
            case .hard:
                return "Hard"
            }
        }
    }
    
    struct LastGameResult {
        let elapsedTime: TimeInterval
        let level: GameLevel
    }
}
