//: [Previous](@previous)

import Foundation
import Combine

let subject = PassthroughSubject<String, Never>()

// The print() operator prints you all lifecycle events
let subscription = subject
//    .print()
    .print("[DEBUG]") // prefix 지정 가능
    .sink { value in
    print("received: \(value)")
}

subject.send("Hello")
subject.send("Hello Again")
subject.send("Hello for the last time!")
// subject.send(completion: .finished) // 끝났다고 알려주거나
subscription.cancel() // 취소할 수 있다.
subject.send("Hello ?")

//: [Next](@next)
