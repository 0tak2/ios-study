//
//  AppFeatureTests.swift
//  TCATutorialTests
//
//  Created by 임영택 on 12/13/25.
//

import ComposableArchitecture
import XCTest
@testable import TCATutorial

@MainActor
final class AppFeatureTests: XCTestCase {
  func testIncrementInTab1() async {
    let store = TestStore(initialState: AppFeature.State()) {
      AppFeature()
    }
    
    await store.send(.tab1(.incrementButtonTapped)) {
      $0.tab1.count = 1
    }
  }
  
  func testIncrementInTab2() async {
    let store = TestStore(initialState: AppFeature.State()) {
      AppFeature()
    }
    
    await store.send(.tab2(.incrementButtonTapped)) {
      $0.tab2.count = 1
    }
  }
}
