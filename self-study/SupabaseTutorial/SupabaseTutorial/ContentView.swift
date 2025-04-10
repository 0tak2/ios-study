//
//  ContentView.swift
//  SupabaseTutorial
//
//  Created by 임영택 on 4/9/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isSignedIn = false
    
    var body: some View {
        Group {
            if isSignedIn {
                ProfileView()
            } else {
                AuthView()
            }
        }
        .task {
            for await state in await supabase.auth.authStateChanges {
                print("state.event - \(state.event)")
                print("state.session - \(state.session)")
                if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                    isSignedIn = state.session != nil
                    print(isSignedIn)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
