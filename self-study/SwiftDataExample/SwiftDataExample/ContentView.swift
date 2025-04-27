//
//  ContentView.swift
//  JsonDataPersistenceExample
//
//  Created by 임영택 on 4/16/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var data: [ItemModel]
    @State private var editingTitle = ""
    
    var body: some View {
        List {
            ForEach(data) { item in
                Label {
                    Text(item.title)
                } icon: {
                    Image(systemName: item.isCompleted ? "checkmark.square" : "square")
                }
                .onTapGesture {
                    toggleItem(item)
                }
            }
            .onDelete { indexSet in
                let item = data[indexSet.first!]
                deleteItem(item)
            }
            
            TextField("할 일을 입력하고 엔터를 입력해 추가", text: $editingTitle)
                .onSubmit {
                    insertItem(ItemModel(id: UUID(), title: editingTitle, isCompleted: false))
                    editingTitle = ""
                }
        }
    }
    
    func insertItem(_ item: ItemModel) {
        context.insert(item)
    }
    
    func toggleItem(_ item: ItemModel) {
        item.isCompleted.toggle()
    }
    
    func deleteItem(_ item: ItemModel) {
        context.delete(item)
    }
}

#Preview {
    ContentView()
}
