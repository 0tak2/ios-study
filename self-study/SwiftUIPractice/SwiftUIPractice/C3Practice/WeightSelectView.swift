//
//  WeightSelectView.swift
//  SwiftUIPractice
//
//  Created by 임영택 on 5/26/25.
//

import SwiftUI

struct WeightSelectView: View {
    @State private var selectedWeight: String = "59.6 kg"
    
    var body: some View {
        Picker("체중을 선택하세요", selection: $selectedWeight) {
            ForEach(stride(from: 0.0, to: 200.0, by: 0.1).map({ "\(String(format: "%.1f", $0)) kg" }), id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(.wheel)
        .padding(64)
    }
}

#Preview {
    WeightSelectView()
}
