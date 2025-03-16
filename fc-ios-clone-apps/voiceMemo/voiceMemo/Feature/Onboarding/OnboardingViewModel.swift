//
//  OnboardingViewModel.swift
//  voiceMemo
//

import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var onboardingContents: [OnboardingContent] = []
    
    init(onboardingContents: [OnboardingContent] = [
        .init(title: "오늘의 할 일", subtitle: "To do list로 언제 어디서든 해야할 일을 한 눈에", imageName: "onboarding_1"),
        .init(title: "똑똑한 나만의 기록장", subtitle: "메모장으로 생각나는 기록은 언제든지", imageName: "onboarding_2"),
        .init(title: "하나라도 놓치지 않도록", subtitle: "음성메모 기능으로 놓치고 싶지않은 기록까지", imageName: "onboarding_3"),
        .init(title: "정확한 시간의 경과", subtitle: "타이머 기능으로 원하는 시간을 확인", imageName: "onboarding_4")
    ]) {
        self.onboardingContents = onboardingContents
    }
}
