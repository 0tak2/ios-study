//
//  ContactDetailFeature.swift
//  TCANavigationTutorial
//
//  Created by 임영택 on 12/18/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ContactDetailFeature {
  @ObservableState
  struct State: Equatable {
    @Presents var alert: AlertState<Action.Alert>?
    let contact: Contact
  }
  
  enum Action {
    case alert(PresentationAction<Alert>)
    case delegate(Delegate)
    case deleteButtonTapped
    enum Alert {
      case confirmDeletion
    }
    enum Delegate {
      case confirmDeletion
    }
  }
  
  @Dependency(\.dismiss) var dismiss
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .alert(.presented(.confirmDeletion)):
        return .run { send in
          await send(.delegate(.confirmDeletion))
          await self.dismiss()
        }
      case .alert:
        return .none
      case .delegate:
        return .none
      case .deleteButtonTapped:
        state.alert = .confirmDeletion
        return .none
      }
    }
    .ifLet(\.alert, action: \.alert)
  }
}

extension AlertState where Action == ContactDetailFeature.Action.Alert {
  static let confirmDeletion = Self {
    TextState("정말로 삭제하시겠습니까?")
  } actions: {
    ButtonState(role: .destructive, action: .confirmDeletion) {
      TextState("삭제")
    }
  }
}
