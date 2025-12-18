//
//  ContactsFeatureTest.swift
//  TCANavigationTutorialTests
//
//  Created by 임영택 on 12/18/25.
//

import ComposableArchitecture
import XCTest

@testable import TCANavigationTutorial

@MainActor
final class ContactsFeatureTest: XCTestCase {
  static func createTestStore(
    contacts: IdentifiedArrayOf<Contact> = [],
    uuidGenerator: UUIDGenerator = UUIDGenerator { UUID() }
  ) -> TestStoreOf<ContactsFeature> {
    TestStore(
      initialState: ContactsFeature.State(
        contacts: contacts
      )
    ) {
      ContactsFeature()
    } withDependencies: {
      $0.uuid = uuidGenerator
    }
  }
  
  func testAddFlow() async {
    let store = Self.createTestStore(uuidGenerator: .incrementing)
    
    await store.send(.addButtonTapped) {
      $0.destination = .addContact(
        AddContactFeature.State(
          contact: Contact(id: UUID(0), name: "")
        )
      )
    }
    
    await store.send(\.destination.addContact.setName, "Bob") {
      $0.$destination[case: \.addContact]?.contact.name = "Bob"
    }
    
    await store.send(\.destination.addContact.saveButtonTapped)
    await store.receive(
      \.destination.addContact.delegate.saveContact,
       Contact(id: UUID(0), name: "Bob")
    ) {
      $0.contacts = [
        Contact(id: UUID(0), name: "Bob")
      ]
    }

    /*
     다음을 생략하면,
     
     failed - The store received 1 unexpected action.

       Unhandled actions:
         .destination(.dismiss)

     To fix, explicitly assert against these actions using "store.receive", skip these actions by performing "await store.skipReceivedActions()", or consider using a non-exhaustive test store: "store.exhaustivity = .off".
     
     이런 오류가 발생함.
     
     테스트하지 않아도 되는 Action이 있다면 exhaustivity를 .off로 지정하면 됨
     */
    await store.receive(\.destination.dismiss) {
      $0.destination = nil
    }
  }
  
  func testAddFlow_NonExhaustive() async {
    let store = Self.createTestStore(uuidGenerator: .incrementing)
    store.exhaustivity = .off
    
    await store.send(.addButtonTapped)
    await store.send(\.destination.addContact.setName, "Bob")
    await store.send(\.destination.addContact.saveButtonTapped)
    await store.skipReceivedActions()
    store.assert {
      $0.contacts = [
        Contact(id: UUID(0), name: "Bob")
      ]
      $0.destination = nil
    }
  }
  
  func testDeleteContact() async {
    let store = Self.createTestStore(
      contacts: [
        Contact(id: UUID(0), name: "Bob"),
        Contact(id: UUID(1), name: "Guk"),
      ],
      uuidGenerator: .incrementing
    )
    
    await store.send(.deleteButtonTapped(id: UUID(1))) {
      $0.destination = .alert(.createDeleteConfirmation(id: UUID(1)))
    }
    
    await store.send(.destination(.presented(.alert(.confirmDeletion(id: UUID(1)))))) {
      $0.contacts.remove(id: UUID(1))
      $0.destination = nil
    }
  }
}
