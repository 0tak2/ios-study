//
//  ContentView.swift
//  JsonDataPersistenceExample
//
//  Created by 임영택 on 4/16/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = DataStore()
    @State private var editingTitle = ""
    
    var body: some View {
        List {
            ForEach(store.data) { item in
                Label {
                    Text(item.title)
                } icon: {
                    Image(systemName: item.isCompleted ? "checkmark.square" : "square")
                }
                .onTapGesture {
                    store.updateData(Item(id: item.id, title: item.title, isCompleted: !item.isCompleted))
                }
            }
            .onDelete { indexSet in
                store.removeData(indexSet)
            }
            
            TextField("할 일을 입력하고 엔터를 입력해 추가", text: $editingTitle)
                .onSubmit {
                    store.appendData(Item(id: UUID(), title: editingTitle, isCompleted: false))
                    editingTitle = ""
                }
        }
        .onAppear() {
            store.viewOnAppear()
        }
    }
}

#Preview {
    ContentView()
}
