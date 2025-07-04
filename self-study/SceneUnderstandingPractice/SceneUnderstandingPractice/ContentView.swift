//
//  ContentView.swift
//  SceneUnderstandingPractice
//
//  Created by 임영택 on 7/3/25.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @State private var triggerLoad = false
    @State private var triggerSave = false

    var body: some View {
        ZStack {
            CustomARViewRepresentable(triggerLoad: $triggerLoad, triggerSave: $triggerSave)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button {
                        triggerLoad = true
                    } label: {
                        Text("로드")
                    }
                    
                    Button {
                        triggerSave = true
                    } label: {
                        Text("캡쳐")
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
