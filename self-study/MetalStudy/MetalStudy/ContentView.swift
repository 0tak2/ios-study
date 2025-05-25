//
//  ContentView.swift
//  MetalStudy
//
//  Created by 임영택 on 5/26/25.
//

import SwiftUI

struct ContentView: View {
    @State var resultLabelContent: String = ""
    @State var elapsedTime: String = "0"
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            TextEditor(text: $resultLabelContent)
            Text("\(elapsedTime) 경과")
            
            Button {
                let start = Date()
                let result = MultiplicationExample.mpsMatrixMultiplication()
                let end = Date()
                elapsedTime = String(end.timeIntervalSince1970 - start.timeIntervalSince1970)
                
                resultLabelContent = result
            } label: {
                Text("GPU로 행렬 계산")
            }

            Button {
                let start = Date()
                let result = MultiplicationExample.cpuMatrixMultiplication()
                let end = Date()
                elapsedTime = String(end.timeIntervalSince1970 - start.timeIntervalSince1970)
                
                resultLabelContent = result
            } label: {
                Text("CPU로 행렬 계산")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
