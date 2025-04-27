//
//  ItemModel.swift
//  SwiftDataExample
//
//  Created by 임영택 on 4/17/25.
//

import Foundation
import SwiftData

@Model
class ItemModel: Hashable, Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var isCompleted: Bool
    
    init(id: UUID, title: String, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}
