//: [Previous](@previous)

import Foundation
import Combine

let arrPublisher = [1, 2, 3].publisher

print("### Example 1 ###")
let subscription1 = arrPublisher
    .map({ value in
        print("transform: \(value), thread: \(Thread.current)")
    })
    .sink { value in
        print("Received: \(value), thread: \(Thread.current)")
    }

print("\n### Example 2 ###")

let queue = DispatchQueue(label: "customQueue") // 또 나왔다...

let subscription2 = arrPublisher
    .subscribe(on: queue) // 작업할 쓰레드 지정 (ex> 무겁고 오래걸리는 작업)
    .map({ value in
        print("transform: \(value), thread: \(Thread.current)")
    })
    .receive(on: DispatchQueue.main) // 받을 쓰레드 지정 (ex> UI 업데이트)
    .sink { value in
        print("Received: \(value), thread: \(Thread.current)")
    }

//: [Next](@next)
