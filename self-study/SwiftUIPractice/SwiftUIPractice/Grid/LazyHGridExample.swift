//
//  LazyHGridExample.swift
//  SwiftUIPractice
//
//  Created by 임영택 on 4/27/25.
//

import SwiftUI

/**
 LazyHGrid는 2차원으로 배치된 여러 뷰들이 세로로 스크롤할 정도로 대형인 경우 사용할 수 있다.
 see: https://developer.apple.com/documentation/swiftui/lazyhgrid
 */
struct LazyHGridExample: View {
    let rows: [GridItem] = [
        .init(.fixed(30)),
        .init(.fixed(30)),
    ]
    
    var body: some View {
        LazyHGrid(rows: rows) {
            Text("Hello,") // 순서대로 행을
            Image(systemName: "hand.wave") // 채우고
            Image(systemName: "globe") // 다음 열로
            Text("World") // 넘어간다
        }
        .frame(height: 120)
        
        Divider()
        
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows) {
                ForEach(0x1f600...0x1f679, id: \.self) { unicode in
                    Text(String(format: "%x", unicode))
                    Text(getEmoji(unicode))
                }
            }
        }
        .frame(height: 100)
    }
}

#Preview {
    LazyHGridExample()
}
