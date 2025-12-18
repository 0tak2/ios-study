//
//  ContactDetailView.swift
//  TCANavigationTutorial
//
//  Created by 임영택 on 12/18/25.
//

import ComposableArchitecture
import SwiftUI

struct ContactDetailView: View {
  @Bindable var store: StoreOf<ContactDetailFeature>

  var body: some View {
    Form {
      Button("삭제") {
        store.send(.deleteButtonTapped)
      }
    }
    .navigationTitle(store.contact.name)
    .alert($store.scope(state: \.alert, action: \.alert))
  }
}

#Preview {
  NavigationStack {
    ContactDetailView(
      store: Store(
        initialState: ContactDetailFeature.State(contact: Contact(id: UUID(), name: "Bob"))
      ) {
        ContactDetailFeature()
      }
    )
  }
}
