//
//  EmojiMemorizeGameView.swift
//  Memorize
//
//  Created by 임영택 on 9/26/24.
//

import SwiftUI

enum Theme {
    case halloween
    case faces
    case flags
    
    var description: String {
        switch self {
        case .halloween:
            "Halloween"
        case .faces:
            "Faces"
        case .flags:
            "Flags"
        }
    }
    
    var imageString: String {
        switch self {
        case .halloween:
            "01.circle"
        case .faces:
            "02.circle"
        case .flags:
            "03.circle"
        }
    }
    
    var order: Int {
        switch self {
        case .halloween:
            10
        case .faces:
            20
        case .flags:
            30
        }
    }
}

struct EmojiMemorizeGameView: View {
    @ObservedObject var viewModel: EmojiMemorizeGame
    
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
            
            ScrollView {
                cards
                    .animation(.default, value: viewModel.cards)
            }
            
            Spacer()
            
            Button("Shuffle") {
                viewModel.shuffle()
            }
            
            Spacer()
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0) {
            ForEach(viewModel.cards) { card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }
        .foregroundColor(.orange)
    }
}

struct CardView: View {
    let card: MemorizeGame<String>.Card
    
    init(_ card: MemorizeGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            let base = RoundedRectangle(cornerRadius: 12)
            
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content) // todo: 분석
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.1)
                    .aspectRatio(1, contentMode: .fit)
            }
                .opacity(card.isFaceUp ? 1 : 0)
            
            base.fill()
                .opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}

#Preview {
    EmojiMemorizeGameView(viewModel: EmojiMemorizeGame())
}
