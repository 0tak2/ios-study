//
//  ContentView.swift
//  New26DesignPractice
//
//  Created by 임영택 on 9/29/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Button {
                print("didTap")
            } label: {
                Text("첫번째 버튼 테스트")
                    .frame(width: 240, height: 60)
            }
            .buttonStyle(.glass)
            
            Button {
                print("didTap")
            } label: {
                Text("첫번째 버튼 테스트")
                    .frame(width: 240, height: 60)
            }
            .buttonStyle(.bordered)

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
