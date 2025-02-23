//
//  ToolBarView.swift
//  AVFoundationPractice
//
//  Created by 임영택 on 2/23/25.
//

import SwiftUI

struct ToolBarView: View {
    @Environment(CameraViewModel.self) var viewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        viewModel.switchDevice()
                    } label: {
                        Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.camera")
                            .resizable()
                            .scaledToFit()
                    }
                }
                .frame(maxHeight: 36)
                
                Spacer()
                
                Button {
                    print("tapped")
                } label: {
                    Image(systemName: "record.circle.fill")
                        .resizable()
                        .scaledToFit()
                }
                .frame(maxWidth: .infinity, maxHeight: 48, alignment: .center)
            }
            .padding(16)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

#Preview {
    ToolBarView()
}
