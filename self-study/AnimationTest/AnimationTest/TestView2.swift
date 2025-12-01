//
//  TestView.swift
//  QueenCam
//
//  Created by 임영택 on 11/12/25.
//

import SwiftUI

struct TestView2: View {
  @State var isPlaying = false
  
  var body: some View {
    VStack {
      Button("시작") {
        isPlaying.toggle()
      }
      
      Image(systemName: "heart")
        .resizable()
        .scaledToFit()
        .frame(width: 300)
//        .phaseAnimator([0.1, 0.3, 0.5, 0.2]) { contentView, phase in
//          contentView.scaleEffect(phase)
//        }
        .phaseAnimator([0.1, 0.3, 0.5, 0.2], trigger: isPlaying) { contentView, phase in
          contentView.scaleEffect(phase)
        }

    }
  }
}

#Preview {
  TestView2()
}
