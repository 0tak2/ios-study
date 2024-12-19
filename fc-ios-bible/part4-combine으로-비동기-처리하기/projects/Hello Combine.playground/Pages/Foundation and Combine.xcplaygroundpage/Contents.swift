//: [Previous](@previous)

import Foundation
import Combine
import UIKit



// URLSessionTask Publisher and JSON Decoding Operator

struct SomeDecodable: Decodable { }

URLSession.shared.dataTaskPublisher(for: URL(string: "https://www.google.com")!)
    .map { data, response in data}
    .decode(type: SomeDecodable.self, decoder: JSONDecoder())


// Notifications

let center = NotificationCenter.default
let noti = Notification.Name("MyNoti")
let notiPublisher = center.publisher(for: noti, object: nil)
let notiSubscription = notiPublisher.sink { _ in
    print("notification received")
}

center.post(name: noti, object: nil)
notiSubscription.cancel()


// KeyPath binding to NSObject instances

let ageLabel = UILabel()
print("ageLabel.text: \(ageLabel.text ?? "nil")")

Just(20)
    .map { "Age is \($0)" }
    .assign(to: \.text, on: ageLabel)
print("ageLabel.text: \(ageLabel.text ?? "nil")")

// Timer
// autoconnect 를 이용하면 subscribe 되면 바로 시작함
let timerPublisher = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect() // 구독되면 바로 방출

let timerSubscription = timerPublisher.sink { time in
    print("time : \(time)")
}

DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // TODO: 이건 뭘까?
    // 5초 후 cancel
    print("will cancel timerSubscription")
    timerSubscription.cancel()
}

//: [Next](@next)
