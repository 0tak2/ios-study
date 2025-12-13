//
//  CounterFeatureTests.swift
//  TCATutorialTests
//
//  Created by 임영택 on 12/13/25.
//

import ComposableArchitecture
import XCTest
@testable import TCATutorial

@MainActor
final class CounterFeatureTests: XCTestCase {
  static func createStore(
    dummyClock: TestClock<Duration> = TestClock(),
    dummyAdvice: String = "Keep going!"
  ) -> TestStore<CounterFeature.State, CounterFeature.Action> {
    return TestStore(initialState: CounterFeature.State()) {
      CounterFeature()
    } withDependencies: {
      $0.continuousClock = dummyClock
      $0.adviceClient = AdviceClient(dummyAdvice: dummyAdvice)
    }
  }
  
  func testCounter() async {
    let store = Self.createStore()
    
    await store.send(.incrementButtonTapped) {
      $0.count = 1
    }
    await store.send(.decrementButtonTapped) {
      $0.count = 0
    }
  }
  
  func testTimer() async {
    let clock = TestClock()
    let store = Self.createStore(dummyClock: clock)
    
    await store.send(.toggleTimerButtonTapped) {
      $0.isTimerRunning = true
    }
    await clock.advance(by: .seconds(1))
    await store.receive(\.timerTick) {
      $0.count = 1
    }
    await store.send(.toggleTimerButtonTapped) {
      $0.isTimerRunning = false
    }
  }
  
  func testAdvice() async {
    let store = Self.createStore()
    
    await store.send(.incrementButtonTapped) {
      $0.count = 1
    }
    
    await store.send(.adviceButtonTapped) {
      $0.isLoading = true
    }
    
    await store.receive(\.adviceResponse, timeout: .seconds(2)) {
      $0.isLoading = false
      $0.advice = "Keep going!"
    }
  }
}
