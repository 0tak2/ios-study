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
                Spacer()
                
                HStack {
                    Button {
                        triggerAttach = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                    }
                    .frame(width: 64, height: 64)
                }
            }
            
            VStack {
                HStack {
                    Text("+")
                }
            }
        }
        .onAppear {
            try! GameManager.instance.config(totalCardCount: 15)
        }
    }
}

#Preview {
    ContentView()
}
