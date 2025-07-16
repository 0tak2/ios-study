//
//  GameModel.swift
//  FastGame
//
//  Created by 임영택 on 7/16/25.
//

import GameKit

class GameModel: ObservableObject {
    // - MARK: Properties
    // MARK: GameKit
    @Published var isAuthenticated = false
    @Published var playerName: String = ""
    
    // MARK: Game Rules
    @Published var cardCount: Int?
    @Published var mode = GameMode.notConfigured
    @Published var selectedLevel = GameLevel.easy
    var startTime: Date?
    @Published var tappedCardIndices = [Int]()
    @Published var elapsedTime: TimeInterval = 0
    private var timer: Timer?
    @Published var lastGameResult: LastGameResult?
    
    init() {
        authenticatePlayer()
    }
    
    // - MARK: Methods
    // MARK: GameKit
    func authenticatePlayer() {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                // TODO: UI에서 ViewController를 띄워야 함
            } else if localPlayer.isAuthenticated {
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                    self.playerName = localPlayer.displayName
                }
            } else {
                print("Game Center 인증 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
            }
        }
    }
    
    // MARK: Game Rules
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
        
        submitRecord()
    }
    
    func resetGame() {
        mode = .notConfigured
    }
    
    func submitRecord() {
        guard let elapsedTime = self.lastGameResult?.elapsedTime,
           let lastGameLevel = self.lastGameResult?.level else {
            print("❌ No last result")
            return
        }
        
        Task.detached {
            do {
                try await GKLeaderboard.submitScore(Int(elapsedTime),
                                                    context: 0,
                                                    player: GKLocalPlayer.local,
                                                    leaderboardIDs: [lastGameLevel.leaderboardId])
                print("score submitted")
            } catch {
                print("error during submitting score: \(error)")
            }
        }
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
        
        var leaderboardId: String {
            switch self {
            case .easy:
                return "leaderboard_easy_times"
            case .medium:
                return "leaderboard_medium_times"
            case .hard:
                return "leaderboard_hard_times"
            }
        }
    }
    
    struct LastGameResult {
        let elapsedTime: TimeInterval
        let level: GameLevel
    }
}
