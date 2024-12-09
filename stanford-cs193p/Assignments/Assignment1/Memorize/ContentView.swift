//
//  ContentView.swift
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

struct ContentView: View {
    let emojis = [
        Theme.halloween: ["👻", "🎃", "🕷️", "😈", "💀", "🕸️", "🧙‍♂️", "🙀", "👹", "😱", "☠️", "🍭", "🍬"],
        Theme.faces: ["😀", "😃", "😄", "😆", "🥹", "😅", "😂", "🤣", "🥲", "☺️", "😊", "😇"],
        Theme.flags: ["🇰🇷", "🇬🇩", "🇬🇷", "🇬🇱", "🇬🇳", "🇬🇼", "🇳🇦", "🇳🇷", "🇳🇬", "🇦🇶"],
    ]
    
    @State var cardCount: Int = 6
    @State var theme: Theme = .halloween
    @State var renderedEmojis: [String] = ["🚫"] // placeholder
    
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
            
            ScrollView {
                cards
            }
            
            Spacer()
            themeChooser
        }
        .padding()
        .onAppear {
            renderedEmojis = getShouldRenderedEmojis() // 렌더링된 후 이모지 목록을 결정한다
        }
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
            ForEach(0..<cardCount*2, id: \.self) { index in
                if (index <= renderedEmojis.count - 1) {
                    CardView(content: renderedEmojis[index])
                        .aspectRatio(2/3, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                }
            }
        }
        .foregroundColor(.orange)
    }
    
    var cardCountAdjuster: some View {
        HStack {
            cardRemover
            Spacer()
            cardAdder
        }
        .imageScale(.large)
        .font(.largeTitle) // Image도 font를 따라간다
    }
    
    var themeChooser: some View {
        HStack {
            let themeList = Array(emojis.keys.sorted(by: { a, b in
                a.order < b.order
            }))
            ForEach(0..<themeList.count, id: \.self) { index in
                VStack {
                    Image(systemName: themeList[index].imageString)
                        .imageScale(.large)
                        .font(.largeTitle)
                    Text(themeList[index].description)
                        .font(.footnote)
                }
                .onTapGesture {
                    theme = themeList[index]
                    renderedEmojis = getShouldRenderedEmojis()
                }
                .padding()
            }
        }
        .foregroundColor(.blue)
    }
    
    func cardCountAdjuster(by offset: Int, symbol: String) -> some View {
        Button(action: {
            cardCount += offset
            renderedEmojis = getShouldRenderedEmojis()
        }, label: {
            Image(systemName: symbol)
        })
        .disabled(cardCount + offset < 1 || cardCount + offset > (emojis[theme] ?? [""]).count)
    }
    
    var cardRemover: some View {
        return cardCountAdjuster(by: -1, symbol: "rectangle.stack.badge.minus.fill")
    }
    
    var cardAdder: some View {
        return cardCountAdjuster(by: +1, symbol: "rectangle.stack.badge.plus.fill")
    }
    
    func getShouldRenderedEmojis() -> [String] {
        let selectedEmojis = emojis[theme] ?? [""]
        
        var retEmojis: [String] = []
        for idx in 0..<cardCount {
            retEmojis.append(selectedEmojis[idx])
            retEmojis.append(selectedEmojis[idx])
        }
        return retEmojis.shuffled()
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            let base = RoundedRectangle(cornerRadius: 12)
            
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content)
                    .font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            
            base.fill()
                .opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture() {
            isFaceUp.toggle() // similar opearation - isFaceUp = !isFaceUp
        }
    }
}

#Preview {
    ContentView()
}
