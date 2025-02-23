//
//  ContentView.swift
//  AVFoundationPractice
//
//  Created by 임영택 on 2/21/25.
//

import SwiftUI

struct CameraView: View {
    var body: some View {
        ZStack {
            ViewFinderView()
            ToolBarView()
        }
        .statusBar(hidden: true)
        .environment(CameraViewModel())
    }
}

#Preview {
    ContentView()
}
