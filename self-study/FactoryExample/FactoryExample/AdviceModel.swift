//
//  AdviceModel.swift
//  FactoryExample
//
//  Created by 임영택 on 10/3/25.
//

import Foundation
import SwiftData

@Model
class AdviceModel {
    var id: UUID?
    var author: String
    var authorProfile: String
    var message: String
    var createdAt: Date
    
    init(id: UUID, author: String, authorProfile: String, message: String, createdAt: Date) {
        self.id = id
        self.author = author
        self.authorProfile = authorProfile
        self.message = message
        self.createdAt = createdAt
    }
}
