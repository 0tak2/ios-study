//
//  EmojiMemorizeGame.swift
//  Memorize
//
//  Created by 임영택 on 10/6/24.
//

import SwiftUI

class EmojiMemorizeGame: ObservableObject {
    private static let emojis = ["👻", "🎃", "🕷️", "😈", "💀", "🕸️", "🧙‍♂️", "🙀", "👹", "😱", "☠️", "🍭", "🍬"]
    
    static func createGame() -> MemorizeGame<String> {
        return MemorizeGame(numberOfPairsOfCards: 12) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            }
            
            return "🚫"
        }
    }
    
    @Published private var model = createGame()
    
    var cards: [MemorizeGame<String>.Card] {
        return model.cards
    }
    
    // MARK: - User Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemorizeGame<String>.Card) {
        model.choose(card)
    }
}
