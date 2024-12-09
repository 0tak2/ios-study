//
//  MemorizeApp.swift
//  Memorize
//
//  Created by 임영택 on 9/26/24.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game: EmojiMemorizeGame = EmojiMemorizeGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemorizeGameView(viewModel: game)
        }
    }
}
