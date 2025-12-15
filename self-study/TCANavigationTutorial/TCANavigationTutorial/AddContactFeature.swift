//
//  AddContactFeature.swift
//  TCANavigationTutorial
//
//  Created by 임영택 on 12/15/25.
//

import ComposableArchitecture

@Reducer
struct AddContactFeature {
  @ObservableState
  struct State: Equatable {
    var contact: Contact
  }
  
  enum Action {
    case cancelButtonTapped
    case saveButtonTapped
    case setName(String)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .cancelButtonTapped:
        return .none
      case .saveButtonTapped:
        return .none
      case .setName(let name):
        state.contact.name = name
        return .none
      }
    }
  }
}
