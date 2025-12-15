//
//  ContactsView.swift
//  TCANavigationTutorial
//
//  Created by 임영택 on 12/13/25.
//

import ComposableArchitecture
import SwiftUI

struct ContactsView: View {
  @Bindable var store: StoreOf<ContactsFeature>
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(store.contacts) { contact in
          Text(contact.name)
        }
      }
      .navigationTitle("Contacts")
      .toolbar {
        ToolbarItem {
          Button {
            store.send(.addButtonTapped)
          } label: {
            Image(systemName: "plus")
          }
        }
      }
    }
    .sheet(item: $store.scope(state: \.addContact, action: \.addContact)) { addContactStore in
      NavigationStack {
        AddContactView(store: addContactStore)
      }
    }
  }
}

#Preview {
  ContactsView(
    store: Store(initialState: ContactsFeature.State()) {
      ContactsFeature()
    }
  )
}
