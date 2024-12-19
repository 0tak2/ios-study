//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()


// MARK: - removeDuplicates
// 중복된 값은 방출하지 않음
let wordsPub = "hey hey there! Mr Mr ?"
    .components(separatedBy: " ")
    .publisher

wordsPub.removeDuplicates()
    .sink { value in
        print("received word \(value)")
    }
    .store(in: &subscriptions) // 셋에 저장해두기


// MARK: - compactMap
// transform 결과가 nil이면 방출하지 않음
let strings = ["a", "1.24", "3", "def", "45", "0.23"].publisher
// print(Float("a"))
// print(Float("1.24"))

strings.map { Float($0) }
    .sink { value in
        print("[map] received float value \(String(describing: value))")
    }
    .store(in: &subscriptions)

strings.compactMap { Float($0) }
    .sink { value in
        print("[compactMap] received float value \(value)")
    }
    .store(in: &subscriptions)


// MARK: - ignoreOutput
// 방출되는 값을 무시

let numbers = (1...100_000).publisher
numbers.ignoreOutput()
    .sink { print("numbers #1 - completed with \($0)") } receiveValue: { print("numbers #1 - recevied value \($0)") }
    .store(in: &subscriptions)


// MARK: - prefix
// 방출되는 값의 수를 제한

numbers.prefix(3)
    .sink { completion in
        print("numbers #2 - completed with \(completion)")
    } receiveValue: { value in
        print("numbers #2 - recevied value \(value)")
    }
    .store(in: &subscriptions)



//: [Next](@next)
