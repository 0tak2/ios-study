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
  
  @Dependency(\.dismiss) var dismiss
  
  enum Action {
    case cancelButtonTapped
    case delegate(Delegate)
    case saveButtonTapped
    case setName(String)
    
    @CasePathable
    enum Delegate: Equatable {
      case saveContact(Contact)
    }
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .cancelButtonTapped:
        return .run { _ in
          await dismiss()
        }
      case .delegate:
        return .none
      case .saveButtonTapped:
        return .run { [contact = state.contact] send in
          await send(.delegate(.saveContact(contact)))
          await dismiss()
        }
      case .setName(let name):
        state.contact.name = name
        return .none
      }
    }
  }
}
