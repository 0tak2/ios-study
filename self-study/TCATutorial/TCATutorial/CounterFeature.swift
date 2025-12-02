//
//  CounterFeature.swift
//  TCATutorial
//
//  Created by 임영택 on 12/1/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct CounterFeature {
  @ObservableState
  struct State {
    var count = 0
    var advice: String?
    var isLoading = false
    var isTimerRunning = false
  }
  
  enum Action {
    case decrementButtonTapped
    case incrementButtonTapped
    case adviceButtonTapped
    case adviceResponse(String)
    case toggleTimerButtonTapped
    case timerTick
  }
  
  enum CancelID { case timer }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .decrementButtonTapped:
        state.count -= 1
        state.advice = nil
        return .none
        
      case .incrementButtonTapped:
        state.count += 1
        state.advice = nil
        return .none
        
      case .adviceButtonTapped:
        state.advice = nil
        state.isLoading = true
        
//        let (data, _) = try await URLSession.shared
//          .data(from: URL(string: "https://api.adviceslip.com/advice/\(state.count)")!)
//        let decoder = JSONDecoder()
//        let adviceResponse = decoder.decode(AdviceResponse.self, from: data)
//        
//        state.advice = adviceResponse.slip.advice
//        state.isLoading = false
//        
//        return .none
        
        return .run { [count = state.count] send in
          // ✅ Do async work in here, and send actions back into the system.
          let (data, _) = try await URLSession.shared
            .data(from: URL(string: "https://api.adviceslip.com/advice/\(count)")!)
          let decoder = JSONDecoder()
          let adviceResponse = try? decoder.decode(AdviceResponse.self, from: data)
          
          if let adviceReponse = adviceResponse {
            await send(.adviceResponse(adviceReponse.slip.advice))
          }
        }
      case .adviceResponse(let advice):
        state.advice = advice
        state.isLoading = false
        return .none
        
      case .timerTick:
        state.count += 1
        state.advice = nil
        return .none
        
      case .toggleTimerButtonTapped:
        state.isTimerRunning.toggle()
        
        if state.isTimerRunning {
          return .run { send in
            while true {
              try await Task.sleep(for: .seconds(1))
              await send(.timerTick)
            }
          }
          .cancellable(id: CancelID.timer)
        } else {
          return .cancel(id: CancelID.timer)
        }
      }
    }
  }
}
