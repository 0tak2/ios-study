//: [Previous](@previous)

import Foundation
import Combine

// Transform - Map
let publisher1 = PassthroughSubject<Int, Never>()
let subscription1 = publisher1.map { $0 * 2}
    .sink { value in
        print("received transformed value: \(value)")
    }

[10, 20, 30].forEach { publisher1.send($0) }

// Filter
let publisher2 = PassthroughSubject<String, Never>()
let subscription2 = publisher2.filter { $0.contains("a") }
    .sink { value in
        print("received filtered value: \(value)")
    }

["apple", "banana", "kiwi"].forEach { publisher2.send($0) }

//: [Next](@next)
