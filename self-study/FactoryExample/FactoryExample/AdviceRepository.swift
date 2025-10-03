//
//  AdviceRepository.swift
//  FactoryExample
//
//  Created by 임영택 on 10/3/25.
//

import Foundation

final class AdviceRepository {
    let baseURL: String = "https://korean-advice-open-api.vercel.app/api"
    
    nonisolated init() { }
    
    func getAdvice() async throws -> Advice? {
        guard let endpoint = URL(string: "\(baseURL)/advice") else {
            throw AdviceRepositoryError.invalidURL
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(from: endpoint)
        } catch {
            throw AdviceRepositoryError.network(error) // 원인 보존
        }

        guard let http = response as? HTTPURLResponse else {
            throw AdviceRepositoryError.invalidServerResponse
        }
        guard (200...299).contains(http.statusCode) else {
            throw AdviceRepositoryError.httpStatus(code: http.statusCode)
        }

        do {
            return try JSONDecoder().decode(Advice.self, from: data)
        } catch {
            throw AdviceRepositoryError.decoding(error) // 디코딩 실패만 분리
        }
    }
}

enum AdviceRepositoryError: Error {
    case network(Error)
    case httpStatus(code: Int)
    case invalidURL
    case invalidServerResponse
    case decoding(Error)
}
