//
//  OnboardingView.swift
//  voiceMemo
//

import SwiftUI

struct OnboardingView: View {
  @StateObject var viewModel = OnboardingViewModel()
  
  var body: some View {
    OnboardingContentView(viewModel: viewModel)
  }
}

private struct OnboardingContentView: View {
  @ObservedObject private var viewModel: OnboardingViewModel
  
  fileprivate init(viewModel: OnboardingViewModel) {
    self.viewModel = viewModel
  }
  
  fileprivate var body: some View {
    VStack {
      // 셀 리스트 뷰
      OnboardingCellListView(viewModel: viewModel)
      
      Spacer()
      
      // 시작 버튼 뷰
      StartButton()
    }
    .edgesIgnoringSafeArea(.top)
  }
}

private struct OnboardingCellListView: View {
  @ObservedObject private var viewModel: OnboardingViewModel
  @State private var selectedIndex: Int = 0
  
  fileprivate init(viewModel: OnboardingViewModel) {
    self.viewModel = viewModel
  }
  
  fileprivate var body: some View {
    TabView(selection: $selectedIndex) {
      // EnumeratedSequence -> Array
      ForEach(Array(viewModel.onboardingContents.enumerated()), id: \.element) { index, content in
        OnboardingCellView(content: content)
          .tag(index)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
    .background(
      selectedIndex % 2 == 0
      ? Color.customSky
      : Color.customBackgroundGreen
    )
    .clipped()
  }
}

private struct OnboardingCellView: View {
  private var content: OnboardingContent
  
  fileprivate init(content: OnboardingContent) {
    self.content = content
  }
  
  fileprivate var body: some View {
    VStack {
      Image(content.imageName)
        .resizable()
        .scaledToFit()
      
      HStack {
        Spacer()
        
        VStack {
          Spacer()
            .frame(height: 46)
          
          Text(content.title)
            .font(.system(size: 16, weight: .bold))
          
          Text(content.subtitle)
            .font(.system(size: 16))
        }
        
        Spacer()
      }
      .background(Color.customWhite)
      .cornerRadius(0)
    }
    .shadow(radius: 10)
  }
}

private struct StartButton: View {
  fileprivate var body: some View {
    Button {
      // TODO
    } label: {
      HStack {
        Text("시작하기")
          .font(.system(size: 16, weight: .medium))
          .foregroundStyle(Color.customGreen)
        
        Image("startHome")
          .renderingMode(.template) // 컬러 지정 가능
          .foregroundStyle(Color.customGreen)
      }
    }
    .padding(.bottom, 50)
  }
}

struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView()
  }
}
