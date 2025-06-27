//
//  ARKitPracticeApp.swift
//  ARKitPractice
//
//  Created by 임영택 on 6/26/25.
//

import SwiftUI

@main
struct ARKitPracticeApp: App {
    var body: some Scene {
        WindowGroup {
            ARDetectImageContainer()
                .ignoresSafeArea()
        }
    }
}
