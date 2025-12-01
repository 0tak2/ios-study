//
//  ContentView.swift
//  GlassTest
//
//  Created by 임영택 on 11/4/25.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    ZStack {
      LinearGradient(colors: [
        Color.white,
        Color.black,
      ], startPoint: .top, endPoint: .bottom)
      
      VStack {
        VStack {
          Text("안녕하세요")
            .font(.largeTitle)
            .foregroundStyle(Color.white)
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 8)
  //              .foregroundStyle(.purple)
  //              .glassEffect(.regular, in: .rect(cornerRadius: 8))
                .glassEffect(.clear.tint(.purple), in: .rect(cornerRadius: 8))
            )
        }
        
        Spacer()
          .frame(height: 48)
        
        VStack {
          Text("안녕하세요")
            .font(.largeTitle)
            .foregroundStyle(Color.white)
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 8)
//                .foregroundStyle(.purple)
  //              .glassEffect(.regular, in: .rect(cornerRadius: 8))
                .glassEffect(.clear, in: .rect(cornerRadius: 8))
            )
        }
      }
    }
    .ignoresSafeArea()
  }
}

#Preview {
  ContentView()
}
