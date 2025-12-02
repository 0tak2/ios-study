//
//  Advice.swift
//  TCATutorial
//
//  Created by 임영택 on 12/2/25.
//

import Foundation

// https://api.adviceslip.com/advice/{id}
struct AdviceResponse: Decodable {
  let slip: AdvicePayload
  
  struct AdvicePayload: Decodable {
    let id: Int
    let advice: String
  }
}
