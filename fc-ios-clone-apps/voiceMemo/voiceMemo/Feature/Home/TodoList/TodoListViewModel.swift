//
//  TodoListViewModel.swift
//  voiceMemo
//

import Foundation

class TodoListViewModel: ObservableObject {
  @Published var todos: [Todo]
  @Published var isEditMode: Bool
  @Published var removeTodos: [Todo] // 삭제 예정 항목
  @Published var isDisplayRemoveTodoAlert: Bool
  
  var removeTodosCount: Int {
    removeTodos.count
  }
  
  var navigationBarRightButtonMode: NavigationBtnType {
    isEditMode ? .complete : .edit
  }
  
  init(todos: [Todo] = [],
       isEditMode: Bool = false,
       removeTodos: [Todo] = [],
       isDisplayRemoveTodoAlert: Bool = false) {
    self.todos = todos
    self.isEditMode = isEditMode
    self.removeTodos = removeTodos
    self.isDisplayRemoveTodoAlert = isDisplayRemoveTodoAlert
  }
}


extension TodoListViewModel {
  func selectedBoxTapped(_ todo: Todo) {
    if let index = todos.firstIndex(of: todo) {
      todos[index].selected.toggle()
    }
  }
  
  func addTodo(_ todo: Todo) {
    todos.append(todo)
  }
  
  func navigationRightButtonTapped() {
    if !isEditMode {
      isEditMode = true
      return
    }
    
    if removeTodos.isEmpty {
      isEditMode = false
    } else {
      setIsDisplayRemoveTodoAlert(true)
    }
  }
  
  func setIsDisplayRemoveTodoAlert(_ isDisplay: Bool) {
    isDisplayRemoveTodoAlert = isDisplay
  }
  
  func todoRemoveSelectedBoxTapped(_ todo: Todo) {
    if let index = removeTodos.firstIndex(of: todo) {
      removeTodos.remove(at: index)
    } else {
      removeTodos.append(todo)
    }
  }
  
  func removeButtonTapped() {
    todos.removeAll { todo in
      removeTodos.contains(todo)
    }
    removeTodos.removeAll()
    isEditMode = false
  }
}
