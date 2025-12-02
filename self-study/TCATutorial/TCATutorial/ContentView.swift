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
      
      Button(store.isTimerRunning ? "Stop timer" : "Start timer") {
        store.send(.toggleTimerButtonTapped)
      }
      .font(.largeTitle)
      .padding()
      .background(.black.opacity(0.1))
      .clipShape(RoundedRectangle(cornerRadius: 10))
      
      Button("Advice") {
        store.send(.adviceButtonTapped)
      }
      .font(.largeTitle)
      .padding()
      .background(.black.opacity(0.1))
      .clipShape(RoundedRectangle(cornerRadius: 10))
      
      if store.isLoading {
        ProgressView()
      } else if let fact = store.advice {
        Text(fact)
          .font(.largeTitle)
          .multilineTextAlignment(.center)
          .padding()
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
