//
//  TCANavigationTutorialApp.swift
//  TCANavigationTutorial
//
//  Created by 임영택 on 12/13/25.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCANavigationTutorialApp: App {
  static let store = Store(initialState: ContactsFeature.State()) {
    ContactsFeature()
      ._printChanges()
  }
  
  var body: some Scene {
    WindowGroup {
      ContactsView(store: Self.store)
    }
  }
}
