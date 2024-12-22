//: [Previous](@previous)

import Foundation

/*
 public typealias Codable = Decodable & Encodable
 디코드, 인코드를 다 할 수 있는 타입
 */

struct GithubProfile: Codable {
    let login: String
    let avatarUrl: String
    let htmlUrl: String
    let followers: Int
    let following: Int
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url" // 실제 응답의 키와 프로퍼티 이름이 다르면 명시해줌
        case htmlUrl = "html_url"
        case followers
        case following
    }
}

let configuration = URLSessionConfiguration.default
let session = URLSession(configuration: configuration)

let url = URL(string: "https://api.github.com/users/0tak2")!
// let url = URL(string: "https://api.github.com/users/0taksfasdfasdfsafsdfasdf")!

let task = session.dataTask(with: url) { data, response, error in
    guard let httpResponse = response as? HTTPURLResponse,
          (200..<300).contains(httpResponse.statusCode) else {
        print("Received Error Response... response : \(response)")
        return
    }
    
    guard let data = data else { return }
    let result = String(data: data, encoding: .utf8)
    
    // decode
    
    do {
        let decoder = JSONDecoder()
        let profile = try decoder.decode(GithubProfile.self, from: data)
        print("profile: \(profile)")
    } catch let error as NSError {
        print("error: \(error)")
    }
}
task.resume()




//: [Next](@next)
