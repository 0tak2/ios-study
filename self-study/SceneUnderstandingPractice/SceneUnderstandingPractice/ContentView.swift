//
//  ContentView.swift
//  SceneUnderstandingPractice
//
//  Created by 임영택 on 7/3/25.
//

import SwiftUI
import RealityKit

struct ContentView : View {

    var body: some View {
        CustomARViewRepresentable()
        .edgesIgnoringSafeArea(.all)
    }

}

#Preview {
    ContentView()
}
