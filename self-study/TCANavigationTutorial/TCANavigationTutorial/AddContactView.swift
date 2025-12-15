//
//  AddContactView.swift
//  TCANavigationTutorial
//
//  Created by 임영택 on 12/15/25.
//

import ComposableArchitecture
import SwiftUI

struct AddContactView: View {
  @Bindable var store: StoreOf<AddContactFeature>
  
  var body: some View {
    Form {
      TextField("Name", text: $store.contact.name.sending(\.setName))
      Button("Save") {
        store.send(.saveButtonTapped)
      }
    }
    .toolbar {
      ToolbarItem {
        Button("Cancel") {
          store.send(.cancelButtonTapped)
        }
      }
    }
  }
}

#Preview {
  AddContactView(
    store: Store(
      initialState: AddContactFeature.State(contact: .init(id: UUID(), name: "Bob"))
    ) {
      AddContactFeature()
    }
  )
}
