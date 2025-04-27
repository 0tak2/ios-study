//
//  LazyVGridExample.swift
//  SwiftUIPractice
//
//  Created by 임영택 on 4/27/25.
//

import SwiftUI

/**
 LazyVGrid는 2차원으로 배치된 여러 뷰들이 가로로 스크롤할 정도로 대형인 경우 사용할 수 있다.
 see: https://developer.apple.com/documentation/swiftui/lazyvgrid
 */
struct LazyVGridExample: View {
    let columns: [GridItem] = [ // row 수는 제약이 없지만, 한 row의 column은 이런 식으로 정의해야한다
        .init(.flexible()),
        .init(.flexible()),
    ]
    // GridItem에 대해서는: https://developer.apple.com/documentation/swiftui/griditem
    
    var body: some View {
        LazyVGrid(columns: columns) {
            Text("Hello,") // 순서대로 행을
            Image(systemName: "hand.wave") // 채우고
            Image(systemName: "globe") // 다음 행으로
            Text("World") // 넘어간다
        }
        
        Divider()
        
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(0x1f600...0x1f679, id: \.self) { unicode in
                    Text(String(format: "%x", unicode))
                    Text(getEmoji(unicode))
                }
            }
        }
    }
}

#Preview {
    LazyVGridExample()
}
