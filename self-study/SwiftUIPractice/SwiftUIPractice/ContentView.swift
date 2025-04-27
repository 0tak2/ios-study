//
//  ContentView.swift
//  SwiftUIPractice
//
//  Created by 임영택 on 4/27/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Grid") {
                    NavigationLink("GridExample") {
                        GridExample()
                    }
                    
                    NavigationLink("LazyVGridExample") {
                        LazyVGridExample()
                    }
                    
                    NavigationLink("LazyHGridExample") {
                        LazyHGridExample()
                    }
                    
                    NavigationLink("LockScreenView") {
                        LockScreenView()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
