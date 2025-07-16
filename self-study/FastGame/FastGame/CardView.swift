//
//  CardView.swift
//  FastGame
//
//  Created by 임영택 on 7/16/25.
//

import SwiftUI

struct CardView: View {
    let index: Int
    let color: Color
    let didTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(isPressed ? Color(red: 242, green: 242, blue: 242) : color)
            .overlay {
                Text("\(index + 1)")
                    .font(.title)
                    .foregroundStyle(isPressed ? .black : .white)
            }
            .onTapGesture {
                isPressed = true
                didTap()
            }
    }
}

#Preview {
    CardView(index: 1, color: .blue) {
        print("did tap")
    }
        .frame(width: 64, height: 64)
}
