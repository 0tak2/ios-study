//: [Previous](@previous)

import Foundation
import Combine

enum NetworkError: Error {
    case invalidRequest
    case responseError(statusCode: Int)
}

struct GithubProfile: Codable {
    let login: String
    let avatarUrl: String
    let htmlUrl: String
    let followers: Int
    let following: Int
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
        case followers
        case following
    }
}

final class NetworkService {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    func fetchProfile(username: String) -> AnyPublisher<GithubProfile, Error> {
        let url = URL(string: "https://api.github.com/users/\(username)")!
        
        let publisher = session
            .dataTaskPublisher(for: url)
            // 서버에서 받은 response 확인
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse,
                   (200..<300).contains(httpResponse.statusCode) else {
                    let response = result.response as? HTTPURLResponse
                    let statusCode = response?.statusCode ?? -1
                    throw NetworkError.responseError(statusCode: statusCode)
                }
                return result.data
            }
            // 디코딩할 떄 쓰는 오퍼레이터
            .decode(type: GithubProfile.self, decoder: JSONDecoder())
            .eraseToAnyPublisher() // 위까지 해서 타입이 매우 복잡하다. 이를 AnyPublisher로 래핑해준다.

        return publisher
    }
}

let service = NetworkService(configuration: .default)
let subscription = service.fetchProfile(username: "0tak2")
    .receive(on: RunLoop.main)
    //.retry(3) // 실패시 재시도하게 할 수도 있음
    .sink { completion in
        print("completion: \(completion)")
    } receiveValue: { profile in
        print("profile: \(profile)")
    }


//: [Next](@next)



