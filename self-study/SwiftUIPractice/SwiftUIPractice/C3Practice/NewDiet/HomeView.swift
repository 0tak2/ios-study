//
//  HomeView.swift
//  SwiftUIPractice
//
//  Created by 임영택 on 5/27/25.
//

import SwiftUI

struct HomeView: View {
    @State var showSelectActionShhet: Bool = false
    
    var body: some View {
        Button {
            showSelectActionShhet = true
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.buttonBackground)
                
                HStack {
                    Text("📸")
                        .font(.system(size: 36))
                    
                    Text("식사 기록하기")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                }
                .padding(16)
            }
        }
        .frame(width: 352, height: 123)
        .confirmationDialog("카메라 또는 사진첩 선택", isPresented: $showSelectActionShhet) {
            Button {
                print("카메라")
            } label: {
                Text("카메라")
            }

            Button {
                print("사진첩에서 선택")
            } label: {
                Text("사진첩에서 선택")
            }
        }
    }
}

fileprivate extension Color {
    static let buttonBackground: Color = .init(hex: "#FF3E00")
}

#Preview {
    HomeView()
}
