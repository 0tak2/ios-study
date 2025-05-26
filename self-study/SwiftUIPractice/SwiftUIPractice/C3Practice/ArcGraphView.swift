//
//  ArcGraphView.swift
//  SwiftUIPractice
//
//  Created by 임영택 on 5/26/25.
//

import SwiftUI

/**
 전체 180도 : goalWeights - startWeights = x도 : currentWeights - startWeights
 */
struct ArcGraphView: View {
    let startWieghts: Double
    let currentWeights: Double
    let goalWeights: Double
    
    var currentAngle: Double {
        let totalAngle: Double = 180
        let currentAngle: Double = (currentWeights - startWieghts) / (goalWeights - startWieghts) * totalAngle
        return currentAngle + 180
    }
    
    var body: some View {
        ZStack {
            Arc(startAngle: 0)
                .foregroundStyle(Color.arcBackground)
            
            Arc(startAngle: currentAngle)
                .foregroundStyle(RadialGradient(
                    stops: [
                        .init(color: .start, location: 0.25),
                        .init(color: .middle, location: 0.38),
                        .init(color: .end, location: 0.51),
                    ],
                    center: .center,
                    startRadius: 180,
                    endRadius: 0))
        }
        .frame(width: 324, height: 162)
        .padding(12)
    }
}

// https://stackoverflow.com/a/57034585
struct Arc: Shape {
    let startAngle: Angle
    
    init(startAngle: Double) {
        self.startAngle = .degrees(startAngle)
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()

        p.addArc(center: CGPoint(x: rect.midX, y: rect.maxY), radius: rect.width / 2, startAngle: startAngle, endAngle: .degrees(180), clockwise: true) // 오른쪽에서 왼쪽으로

        return p.strokedPath(.init(lineWidth: 24, lineCap: .round))
    }
}

fileprivate extension Color {
    static let start = Color(hex: "#D03807")
    static let middle = Color(hex: "#FF3E00")
    static let end = Color(hex: "#FFBB00")
    static let arcBackground = Color(hex: "#D9D9D9")
}

#Preview {
    ArcGraphView(startWieghts: 57.0, currentWeights: 59.6, goalWeights: 62.0)
        .padding(32)
}
