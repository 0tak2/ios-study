//
//  MemorizeGame.swift
//  Memorize
//
//  Created by 임영택 on 10/6/24.
//

import Foundation

// 모델 역할
struct MemorizeGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card] // access control: set에 대해서만 private. get은 여전히 public
    
    private var currentlyFaceUpCardIndex: Int? {
        get {
            cards.indices.filter { cards[$0].isFaceUp }.only
        }
        
        set {
            cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue)}
        }
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        
        // add numberOfPairsOfCards * 2 cards
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(id: "\(pairIndex)a", content: content)) // id=1a
            cards.append(Card(id: "\(pairIndex)b", content: content)) // id=1b
        }
    }
    
    mutating func shuffle() { // copy-on-write
        cards.shuffle()
        print(cards)
    }
    
    mutating func choose(_ card: Card) {
        guard let targetCardIndex = cards.firstIndex(where: {
            $0.id == card.id
        }) else {
            print("[warn] requested to flip a card(\(card) but it is not found on model...")
            return
        }
        
        if !cards[targetCardIndex].isFaceUp && !cards[targetCardIndex].isMatched {
            if let faceUpCardIndex = currentlyFaceUpCardIndex {
                if cards[faceUpCardIndex].content == cards[targetCardIndex].content {
                    cards[faceUpCardIndex].isMatched = true
                    cards[targetCardIndex].isMatched = true
                }
            } else {
                currentlyFaceUpCardIndex = targetCardIndex
            }
            
            cards[targetCardIndex].isFaceUp = true
        }
    }
    
    // MemorizeGame.Card
    // 구조체 중첩: 네임스페이싱 효과가 있다
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var id: String // Identifiable 요구사항. 이 구조체의 인스턴스 각각을 구분할 수 있는 식별자
        
        // 모든 저장 프로퍼티가 Equatable를 준수하는 구조체의 경우 Equatable을 명시하기만 하면 자동으로 구현된다.
        // 아래의 == 메서드처럼, 스위프트는 위에 해당하는 경우 각 프로퍼티에 대한 비교를 자동으로 합성해준다. (문서 참고)
//        static func == (lhs: Card, rhs: Card) -> Bool { // 생략 가능
//            lhs.isFaceUp == rhs.isFaceUp &&
//            lhs.isMatched == rhs.isMatched &&
//            lhs.content == rhs.content
//        }
        
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        let content: CardContent
        
        var debugDescription: String { // CustomDebugStringConvertible 요구사항. print로 이 구조체 인스턴스가 넘겨진 경우 출력될 디버그용 문자열
            "id=\(id) | \(content) | \(isFaceUp ? "Up" : "Down") | \(isMatched ? "Matched" : "Not Matched")"
        }
    }
}

extension Array {
    var only: Element? {
        self.count == 1 ? self[0] : nil
    }
}
