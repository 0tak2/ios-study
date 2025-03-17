//
//  ToodoListView.swift
//  voiceMemo
//

import SwiftUI

struct TodoListView: View {
  @EnvironmentObject private var pathModel: PathModel
  @EnvironmentObject private var todoListViewModel: TodoListViewModel
  
  var body: some View {
    ZStack {
      // Todo Cell List
      VStack {
        if !todoListViewModel.todos.isEmpty {
          CustomNavigationBar(
            isDisplayLeftButton: false,
            rightButtonAction: todoListViewModel.navigationRightButtonTapped,
            rightButtonType: todoListViewModel.navigationBarRightButtonMode
          )
        } else {
          Spacer()
          .frame(height: 30)
        }
        
        TitleView()
          .padding(.top, 20)
        
        if todoListViewModel.todos.isEmpty {
          ExampleView()
        } else {
          TodoListContentView()
        }
      }
      
      WriteTodoButtonView()
        .padding(.trailing, 20)
        .padding(.bottom, 50)
    }
    .alert("To do \(todoListViewModel.removeTodosCount)개를 삭제하시겠습니까?", isPresented: $todoListViewModel.isDisplayRemoveTodoAlert) {
      Button("삭제", role: .destructive) {
        todoListViewModel.removeButtonTapped()
      }

      Button("취소", role: .cancel) { }
    }
  }
}

private struct TitleView: View {
  @EnvironmentObject private var todoListViewModel: TodoListViewModel
  
  fileprivate var body: some View {
    HStack {
      if todoListViewModel.todos.isEmpty {
        Text("To do list를\n추가해 보세요.")
      } else {
        Text("To do \(todoListViewModel.todos.count)개가\n있습니다.")
      }
      
      Spacer()
    }
    .font(.system(size: 30, weight: .bold))
    .padding(.leading, 20)
  }
}

private struct ExampleView: View {
  fileprivate var body: some View {
    VStack(spacing: 15) {
      Spacer()
      
      Image("pencil")
        .renderingMode(.template)
      Text("\"매일 아침 5시 운동하기\"")
      Text("\"내일 8시 수강신청\"")
      Text("\"1시 반 점심 약속\"")
      
      Spacer()
    }
    .font(.system(size: 16))
    .foregroundStyle(Color.customGray2)
  }
}

private struct TodoListContentView: View {
  @EnvironmentObject private var todoListViewModel: TodoListViewModel
  
  fileprivate var body: some View {
    VStack(spacing: 15) {
      HStack {
        Text("할 일 목록")
          .font(.system(size: 16, weight: .bold))
          .padding(.leading, 20)
        
        Spacer()
      }
      
      ScrollView(.vertical) {
        VStack(spacing: 0) {
          Rectangle()
            .fill(Color.customGray0)
            .frame(height: 1)
          
          ForEach(todoListViewModel.todos, id: \.self) { todo in
            TodoCellView(todo: todo)
          }
        }
      }
    }
  }
}

private struct TodoCellView: View {
  @EnvironmentObject private var todoListViewModel: TodoListViewModel
  @State private var isRemoveSelected: Bool
  private var todo: Todo
  
  init(isRemoveSelected: Bool = false,
       todo: Todo) {
//    self.isRemoveSelected = isRemoveSelected
    _isRemoveSelected = State(initialValue: isRemoveSelected)
    self.todo = todo
  }
  
  fileprivate var body: some View {
    VStack(spacing: 20) {
      HStack {
        if !todoListViewModel.isEditMode {
          Button {
            todoListViewModel.selectedBoxTapped(todo)
          } label: {
            todo.selected
            ? Image(systemName: "selectBox")
            : Image(systemName: "unSelectBox")
          }

        }
        
        VStack(alignment: .leading, spacing: 5) {
          Text(todo.title)
            .font(.system(size: 16))
            .foregroundStyle(todo.selected ? Color.customIconGray : Color.customBlack)
          
          Text(todo.convertedDayAndTime)
            .font(.system(size: 12))
            .foregroundStyle(Color.customIconGray)
          
          Spacer()
          
          if todoListViewModel.isEditMode {
            Button {
              isRemoveSelected.toggle()
              todoListViewModel.todoRemoveSelectedBoxTapped(todo)
            } label: {
              isRemoveSelected
              ? Image(systemName: "selectBox")
              : Image(systemName: "unSelectBox")
            }
          }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
      }
      
      Rectangle()
        .fill(Color.customGray0)
        .frame(height: 1)
    }
  }
}

private struct WriteTodoButtonView: View {
  @EnvironmentObject private var pathModel: PathModel
  
  fileprivate var body: some View {
    VStack {
      Spacer()
      
      HStack {
        Spacer()
        
        Button {
          pathModel.paths.append(.todo)
        } label: {
          Image("writeBtn")
        }
      }
    }
  }
}

struct TodoListView_Previews: PreviewProvider {
  static var previews: some View {
    TodoListView()
      .environmentObject(PathModel())
      .environmentObject(TodoListViewModel())
  }
}
