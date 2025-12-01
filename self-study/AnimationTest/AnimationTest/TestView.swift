//
//  TestView.swift
//  QueenCam
//
//  Created by 임영택 on 11/12/25.
//

import SwiftUI

struct TestView: View {
  @State var animationPhase: GoodAnimationPhase = .step0
  @State var isPlaying: Bool = false
  @State var animationPhaser: Timer?
  
  var body: some View {
    VStack {
      Button("시작") {
        isPlaying.toggle()
      }
      
      Image(systemName: "heart")
        .resizable()
        .scaledToFit()
        .frame(width: 300)
        .scaleEffect(animationPhase.scale)
    }
    .onChange(of: isPlaying) { oldValue, newValue in
      if newValue {
        animationPhaser = Timer.scheduledTimer(withTimeInterval: 1 / 30, repeats: true, block: { timer in
          if let nextPhase = animationPhase.next {
            self.animationPhase = nextPhase
          } else {
            timer.invalidate()
            self.animationPhaser = nil
            self.animationPhase = .step0
          }
        })
      } else {
        self.animationPhase = .step0
        animationPhaser?.invalidate()
        animationPhaser = nil
      }
    }
  }
}

#Preview {
  TestView()
}

enum GoodAnimationPhase: Int {
  case step0 = 0
  case step1
  case step2
  case step3
  case step4
  case step5
  
  var next: Self? {
    switch self {
    case .step0: return .step1
    case .step1: return .step2
    case .step2: return .step3
    case .step3: return .step4
    case .step4: return .step5
    case .step5: return nil
    }
  }

  var scale: CGFloat {
    switch self {
    case .step0: return 0.1
    case .step1: return 0.3
    case .step2: return 0.5
    case .step3: return 0.2
    case .step4: return 0.9
    case .step5: return 0.8
    }
  }
}
