//: [Previous](@previous)

import Foundation
//import UIKit
import Combine

final class SomeViewModel {
    @Published var name: String = "Jack"
    var age: Int = 20
}

final class Label {
    var text: String = "" {
        didSet {
            print("text updated : \(text)")
        }
    }
}

let label = Label()
let vm = SomeViewModel()
print("text: \(label.text)")

vm.$name.assign(to: \.text, on: label)
vm.name = "Jason"
vm.name = "Buck"


//: [Next](@next)
