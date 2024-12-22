//: [Previous](@previous)

/**
 실제 개발할 때에는 직접 URLSession을 호출하기 보다는,
 네트워크 작업을 수행하는 객체를 만들어 처리하는 경우가 많다.
 */

import Foundation

enum NetworkError: Error {
  case invalidRequest
  case transportError(Error)
  case responseError(statusCode: Int)
  case noData
  case decodingError(Error)
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
    
    func fetchProfile(username: String, completion: @escaping (Result<GithubProfile, Error>) -> Void) {
        // Result는 성공, 실패를 표현하는 열거형이다
        
        let url = URL(string: "https://api.github.com/users/\(username)")!

        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.transportError(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               !(200..<300).contains(httpResponse.statusCode) {
                completion(.failure(NetworkError.responseError(statusCode: httpResponse.statusCode))) 
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            let result = String(data: data, encoding: .utf8)
            
            // decode
            
            do {
                let decoder = JSONDecoder()
                let profile = try decoder.decode(GithubProfile.self, from: data)
                completion(.success(profile))
            } catch let error as NSError {
                completion(.failure(NetworkError.decodingError(error)))
            }
        }
        task.resume()
    }
}

// 요청
let service = NetworkService(configuration: URLSessionConfiguration.default)
let username = "0tak2"
//let username = "maybe404username"
service.fetchProfile(username: username) { result in
    switch result {
    case .success(let profile):
        print("Profile: \(profile)")
    case .failure(let error):
        print("Error: \(error)")
    }
}


//: [Next](@next)
