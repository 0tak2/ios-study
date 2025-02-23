//
//  ContentView.swift
//  AVFoundationPractice
//
//  Created by 임영택 on 2/21/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CameraView()
            .statusBar(hidden: true)
    }
}

#Preview {
    ContentView()
}
