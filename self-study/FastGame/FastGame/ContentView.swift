//
//  ContentView.swift
//  FastGame
//
//  Created by 임영택 on 7/16/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = GameModel()
    @State private var showsGameCenterModal: Bool = false
    
    var body: some View {
        Group {
            if model.mode == .notConfigured {
                VStack {
                    HStack {
                        Text(model.playerName)
                        
                        Spacer()
                        
                        if model.isAuthenticated {
                            Button("대시보드") {
                                showsGameCenterModal = true
                            }
                        }
                    }
                    
                    Picker("게임 레벨", selection: $model.selectedLevel) {
                        ForEach(GameModel.GameLevel.allCases, id: \.self) { level in
                            Text(level.localizedDescription)
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    Button("게임 시작") {
                        model.startGame()
                    }
                }
            } else if model.mode == .finish {
                VStack {
                    Text("You Win!")
                    Text("\(model.lastGameResult?.elapsedTime ?? 0) 초 만에 성공했어요!")
                    Button("한 판 더") {
                        model.resetGame()
                    }
                }
            } else {
                MainGameView(model: model)
            }
        }
        .sheet(isPresented: $showsGameCenterModal) {
            GameCenterView()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
