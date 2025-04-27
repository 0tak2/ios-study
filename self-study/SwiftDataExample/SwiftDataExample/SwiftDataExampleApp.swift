//
//  SwiftDataExampleApp.swift
//  SwiftDataExample
//
//  Created by 임영택 on 4/17/25.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [ItemModel.self])
    }
}
