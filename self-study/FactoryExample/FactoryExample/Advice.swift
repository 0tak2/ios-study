//
//  Advice.swift
//  FactoryExample
//
//  Created by 임영택 on 10/3/25.
//

import Foundation

struct Advice: Decodable {
    let author: String
    let authorProfile: String
    let message: String
    
    var model: AdviceModel {
        AdviceModel(id: UUID(), author: author, authorProfile: authorProfile, message: message, createdAt: Date())
    }
}
