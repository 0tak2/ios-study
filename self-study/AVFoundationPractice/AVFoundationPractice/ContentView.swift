//
//  ContentView.swift
//  AVFoundationPractice
//
//  Created by 임영택 on 2/21/25.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = ViewModel()
    
    var body: some View {
        CameraView(image: $viewModel.currentFrame)
    }
}

#Preview {
    ContentView()
}
