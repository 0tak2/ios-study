//
//  ContentView.swift
//  ARKitPractice2
//
//  Created by 임영택 on 6/27/25.
//

import SwiftUI
import RealityKit

struct ContentView : View {

    var body: some View {
        ARContainerView()
        .edgesIgnoringSafeArea(.all)
    }

}

#Preview {
    ContentView()
}
