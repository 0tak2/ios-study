//
//  ArcGraphPanelView.swift
//  SwiftUIPractice
//
//  Created by 임영택 on 5/26/25.
//

import SwiftUI

struct ArcGraphPanelView: View {
    @State var startWieghts: Double = 57.0
    @State var goalWeights: Double = 62.0
    @State var currentWeights: Double = 59.6 {
        didSet {
            if currentWeights < startWieghts {
                currentWeights = startWieghts
            }
            
            if currentWeights > goalWeights {
                currentWeights = goalWeights
            }
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    Text("최근 몸무게")
                    Text("\(String(format: "%.1f", currentWeights))kg")
                }
                
                VStack {
                    ArcGraphView(startWieghts: startWieghts, currentWeights: currentWeights, goalWeights: goalWeights)
                    
                    HStack {
                        Text("\(Int(startWieghts))kg")
                        Spacer()
                        Text("\(Int(goalWeights))kg")
                    }
                    .padding(.horizontal, 24)
                }
            }
            
            HStack {
                Button {
                    currentWeights -= 0.1
                } label: {
                    Image(systemName: "minus")
                }
                
                Button {
                    currentWeights += 0.1
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    ArcGraphPanelView()
}
