//
//  EmojiUtil.swift
//  SwiftUIPractice
//
//  Created by 임영택 on 4/27/25.
//

import Foundation

func getEmoji(_ unicode: Int) -> String {
    guard let scalar = UnicodeScalar(unicode) else {
        return "?"
    }
    return String(scalar)
}
