//: [Previous](@previous)

import Foundation
import Combine

// Publisher & Subscriber

// just
let just = Just(10000)
let sub1 = just.sink { val in
    print(val)
}

// sink
let arrayPub = [1, 2, 3, 4, 5].publisher
let sub2 = arrayPub.sink { val in
    print(val)
}

// assign
class MyData {
    var value: Int = 0 {
        didSet {
            print("didSet value : \(value)")
        }
    }
}
let obj = MyData()
let sub3 = arrayPub.assign(to: \.value, on: obj)
print("obj.value: \(obj.value)")

//: [Next](@next)


