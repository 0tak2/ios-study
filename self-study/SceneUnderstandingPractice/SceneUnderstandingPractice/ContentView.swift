//
//  ContentView.swift
//  SceneUnderstandingPractice
//
//  Created by 임영택 on 7/3/25.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @State private var triggerAttach = false

    var body: some View {
        ZStack {
            CustomARViewRepresentable(triggerAttach: $triggerAttach)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button {
                        triggerAttach = true
                    } label: {
                        Text("붙이기")
                    }
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
