//
//  ContentView.swift
//  CoreGraphicPractice
//
//  Created by 임영택 on 7/24/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            Text("Hello, world!")
            
            Image(uiImage: RendererExample.example1())
            
            Image(uiImage: RendererExample.example2())
            
            Image(uiImage: RendererExample.example3())
            
            Image(uiImage: RendererExample.example4())
            
            Image(uiImage: RendererExample.example5())
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
