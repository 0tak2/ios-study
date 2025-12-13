//
//  AdviceClient.swift
//  TCATutorial
//
//  Created by 임영택 on 12/13/25.
//

import ComposableArchitecture
import Foundation

struct AdviceClient {
  let dummyAdvice: String?
  
  init(dummyAdvice: String? = nil) {
    self.dummyAdvice = dummyAdvice
  }
  
  func fetchAdvice(idx: Int) async throws -> String {
    if let dummyAdvice { // For Test
      return dummyAdvice
    }
    
    let (data, _) = try await URLSession.shared
      .data(from: URL(string: "https://api.adviceslip.com/advice/\(idx)")!)
    let decoder = JSONDecoder()
    let adviceResponse = try? decoder.decode(AdviceResponse.self, from: data)
    
    if let adviceReponse = adviceResponse {
      return adviceReponse.slip.advice
    } else {
      throw NSError(domain: "Advice is nil", code: -100)
    }
  }
}

extension AdviceClient: DependencyKey {
  static let liveValue = AdviceClient()
}

extension DependencyValues {
  var adviceClient: AdviceClient {
    get { self[AdviceClient.self] }
    set { self[AdviceClient.self] = newValue }
  }
}
