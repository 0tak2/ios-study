//
//  ContentView.swift
//  FactoryExample
//
//  Created by 임영택 on 10/3/25.
//

import SwiftUI

struct ContentView: View {
    @State private var model = ViewModel()
    
    var body: some View {
        VStack {
            if let advice = model.advice {
                Text(advice.message)
                Text("- \(advice.author) (\(advice.authorProfile))")
            } else {
                Text("명언을 불러오는 중입니다.")
            }
        }
        .task {
            await model.fetchAdvice()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
