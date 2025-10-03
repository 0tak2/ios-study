//
//  AdviceService.swift
//  FactoryExample
//
//  Created by 임영택 on 10/3/25.
//

import Foundation
import FactoryKit

final class AdviceService {
    private let repository: AdviceRepository
    
    nonisolated init(repository: AdviceRepository) {
        self.repository = repository
    }
    
    func fetchAdvice() async throws -> Advice? {
        do {
            return try await repository.getAdvice()
        } catch {
            throw AdviceServiceError.repository(error)
        }
    }
}

enum AdviceServiceError: Error {
    case repository(Error)
}
