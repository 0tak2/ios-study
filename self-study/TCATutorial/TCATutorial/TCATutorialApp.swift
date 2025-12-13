//
//  TCATutorialApp.swift
//  TCATutorial
//
//  Created by 임영택 on 12/1/25.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCATutorialApp: App {
  static let store = Store(initialState: AppFeature.State()) {
    AppFeature()
      ._printChanges()
  }

  var body: some Scene {
    WindowGroup {
      AppView(store: Self.store)
    }
  }
}
