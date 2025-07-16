//
//  MainGameView.swift
//  FastGame
//
//  Created by 임영택 on 7/16/25.
//

import SwiftUI

struct MainGameView: View {
    @ObservedObject var model: GameModel
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)

    let colors: [Color] = [
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .purple,
    ]
    
    var body: some View {
        ZStack {
            ScrollView {
                Spacer()
                    .frame(height: 32)
                
                LazyVGrid(columns: columns) {
                    ForEach(0..<(model.cardCount ?? 16), id: \.self) { index in
                        GameCard(index: index)
                    }
                }
            }
            
            VStack {
                Text("경과 시간: \(model.elapsedTime)")
                
                Spacer()
            }
        }
    }
    
    func GameCard(index: Int) -> some View {
        let color = colors[index % colors.count]
        return CardView(index: index, color: color) {
            model.cardTapped(at: index)
        }
            .frame(width: 72, height: 72)
    }
}

#Preview {
    MainGameView(model: GameModel())
}
