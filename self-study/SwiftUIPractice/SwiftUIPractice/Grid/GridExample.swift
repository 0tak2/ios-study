//
//  GridExample.swift
//  SwiftUIPractice
//
//  Created by 임영택 on 4/27/25.
//

import SwiftUI

/**
 see:  https://developer.apple.com/documentation/swiftui/grid
 */
struct GridExample: View {
    var body: some View {
        VStack(spacing: 64) {
            Grid {
                GridRow {
                    Text("Hello")
                    Image(systemName: "globe")
                }
                
                Divider() // Grid는 GridRow 대신 다른 요소를 넘기면 이 요소로 전체 컬럼 너비 만큼을 채운다.
                // Divider는 부모가 제안하는 수평 공간을 모두 사용하므로 그리드의 전체 너비도 부모가 제공해준 너비만큼 커진다
                //
                // Case 1.
                // GridExample --이 만큼 쓸 수 있어--> Grid --이 만큼 쓸 수 있어--> GridRow
                //             <--이 만큼만 있으면 돼--     <--이 만큼만 있으면 돼--
                //
                // Case 2.
                // GridExample --이 만큼 쓸 수 있어--> Grid --이 만큼 쓸 수 있어--> Divider
                //              <--준 만큼 다 쓸게--      <--나 준 만큼 다 쓸래!!--
                
                GridRow {
                    Image(systemName: "hand.wave")
                    Text("World")
                }
            }
            
            // 그리드는 가장 컬럼이 많은 로우에 맞춰 렌더링한다
            // 이를 위해 컬럼이 적은 로우에는 뒤에 빈 셀을 렌더링한다
//            Grid {
            Grid(alignment: .bottom, horizontalSpacing: 1, verticalSpacing: 1) { // Cell spacing and alignment
                // 컬럼 별로, 로우 별로, 셀 별로 정렬 규칙을 지정해줄 수 있다.
                // see: https://developer.apple.com/documentation/swiftui/grid#Cell-spacing-and-alignment
                
                GridRow {
                    Text("Row 1")
                    ForEach(0..<3) { _ in Color.red }
                }
                GridRow {
                    Text("Row 2")
                    ForEach(0..<5) { _ in Color.blue }
                }
                GridRow {
                    Text("Row 3")
                    ForEach(0..<4) { _ in Color.green }
                }
            }
            .frame(height: 150)
            
            // Grid는 즉시 각 로우와 컬럼의 사이즈를 계산하고 렌더링한다.
            // 따라서 많은 데이터를 스크롤 뷰 안에서 렌더링해야하여 렌더링 초기 성능 저하가 발생하는 경우
            // LazyVGrid나 LazyHGrid를 사용하는 게 좋을 수 있다.
            // Lazy Grids는 화면에 표시되어야 하는 경우에 셀을 렌더링하기 때문에 렌더링을 위한
            // 초기 비용이 줄어든다. 대신 이로 인해 셀 배치 최적화 정도 역시 줄어들 수 있다.
        }
    }
}

#Preview {
    GridExample()
}
