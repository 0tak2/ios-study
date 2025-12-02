//
//  ContentView.swift
//  TCATutorial
//
//  Created by 임영택 on 12/1/25.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
  let store: StoreOf<CounterFeature>
  
  var body: some View {
    VStack {
      Text("\(store.count)")
        .font(.largeTitle)
        .padding()
        .background(.black.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
      
      HStack {
        Button("-") {
          store.send(.decrementButtonTapped)
        }
        .font(.largeTitle)
        .padding()
        .background(.black.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
        Button("+") {
          store.send(.incrementButtonTapped)
        }
        .font(.largeTitle)
        .padding()
        .background(.black.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      
    }
    .padding()
  }
}

#Preview {
  ContentView(store: Store(initialState: CounterFeature.State(), reducer: {
    CounterFeature()
  }))
}
