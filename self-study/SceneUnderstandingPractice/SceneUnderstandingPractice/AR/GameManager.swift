//
//  GameManager.swift
//  SceneUnderstandingPractice
//
//  Created by 임영택 on 7/15/25.
//

import Foundation
import RealityKit
import Combine

class GameManager {
    static let instance = GameManager()
    
    private(set) var totalCardCount: Int?
    private(set) var currentMode: GameMode = .initialized {
        didSet {
            currentModePublisher.send(currentMode)
        }
    }
    private(set) var attachedCardsCount = 0 {
        didSet {
            attachedCardsCountPublisher.send(attachedCardsCount)
        }
    }
    
    let currentModePublisher: CurrentValueSubject<GameMode, Never> = .init(.initialized)
    let attachedCardsCountPublisher: CurrentValueSubject<Int, Never> = .init(0)
    
    private init() { }
    
    func config(totalCardCount: Int) throws {
        guard currentMode == .initialized else {
            throw GameManagerError.gameAlreadyConfigured
        }
        
        self.totalCardCount = totalCardCount
        self.currentMode = .idle
    }
    
    func cardsAttached(count: Int = 1) {
        print("\(count) of Cards attached")
        
        attachedCardsCount += count
        
        currentMode = attachedCardsCount == totalCardCount! ? .ready : .idle
    }
    
    func cardDetached(count: Int = 1) {
        print("\(count) of Cards detached")
        
        attachedCardsCount -= count
        
        currentMode = attachedCardsCount == totalCardCount! ? .ready : .idle
    }
    
    enum GameMode: String {
        case initialized // 처음 초기화됨
        case idle // 게임 설정이 완료됨
        case ready // 모든 카드를 붙여서 게임 준비가 완료됨
        case playing // 게임이 시작됨
    }
    
    enum GameManagerError: Error, LocalizedError {
        case gameAlreadyConfigured
        
        var errorDescription: String? {
            switch self {
            case .gameAlreadyConfigured:
                return "Game is already configured."
            }
        }
    }
}
