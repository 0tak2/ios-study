//: [Previous](@previous)

import Foundation

// configuration -> urlsession -> urlsessionTask

let configuration = URLSessionConfiguration.default
let session = URLSession(configuration: configuration)

let url = URL(string: "https://api.github.com/users/0tak2")!
// let url = URL(string: "https://api.github.com/users/0taksfasdfasdfsafsdfasdf")!

let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: (any Error)?) in
    guard let httpResponse = response as? HTTPURLResponse,
          (200..<300).contains(httpResponse.statusCode) else {
        print("Received Error Response... response : \(response)")
        return
    }
    
    guard let data = data else { return }
    let result = String(data: data, encoding: .utf8)
    print(result)
}
task.resume()

//: [Next](@next)
