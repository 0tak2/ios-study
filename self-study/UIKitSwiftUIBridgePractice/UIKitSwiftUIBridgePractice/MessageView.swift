//
//  MessageView.swift
//  UIKitSwiftUIBridgePractice
//
//  Created by 임영택 on 7/3/25.
//

import SwiftUI

struct MessageView: View {
    @Binding var message: String
    
    var body: some View {
        VStack {
            Text(message)
                .font(.largeTitle)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.yellow)
                )
            
            Button {
                message = message + "!"
            } label: {
                Text("Add !")
            }
        }
    }
}

#Preview {
    struct PreviewWrapperView: View {
        @State var message: String = "Hello, World!"
        
        var body: some View {
            MessageView(message: $message)
        }
    }
    
    return PreviewWrapperView()
}
