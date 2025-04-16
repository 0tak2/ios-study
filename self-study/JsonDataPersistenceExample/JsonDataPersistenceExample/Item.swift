//
//  Item.swift
//  JsonDataPersistenceExample
//
//  Created by 임영택 on 4/16/25.
//

import Foundation

/**
 Codable은 Decodable과 Encodable을 결합한 프로토콜입니다. 두 개를 한 번에 따르는 것과 같습니다.
 https://developer.apple.com/documentation/swift/codable
 
 Decodable과 Encodable은 JSONDecoder나 JSONEncoder처럼 메모리 위 객체를 외부로 교환할 수 있는 형식으로 변환하고자 할 때 구현해요.
 */
struct Item: Hashable, Identifiable, Codable {
    let id: UUID
    let title: String
    let isCompleted: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case isCompleted = "is_completed"
        // isCompleted처럼 필드 명과 저장할 키 이름이 다른 경우가 있다면 CodingKeys를 구현해주세요. 아니라면 생략해도 됩니다.
    }
}
