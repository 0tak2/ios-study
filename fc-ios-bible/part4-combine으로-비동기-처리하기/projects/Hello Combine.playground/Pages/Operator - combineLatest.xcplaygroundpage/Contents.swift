//: [Previous](@previous)

import Foundation
import Combine


// MARK: - Basic CombineLatest
// 두 Publisher를 결합한다.
// 특정 Publisher가 방출될 때마다 각 Publisher의 최신 값을 튜플로 방출한다.

let pub1 = PassthroughSubject<String, Never>()
let pub2 = PassthroughSubject<Int, Never>()

/*
                time -------------------------------->
 pub1           "a"            "b"             "c"
 pub2                  1                2                3
 CombineLastest        "a",1            "b",2           "c",3
 */

pub1.combineLatest(pub2).sink { (value: (String, Int)) in
    print("Combined Publisher Received: \(value)")
}
//Publishers.CombineLatest(pub1, pub2).sink { (value: (String, Int)) in
//    print("Combined Publisher Received: \(value)")
//}

pub1.send("a")
pub1.send("b")
pub1.send("c")

pub2.send(1)
pub2.send(2)
pub2.send(3)

pub1.send("d")
pub2.send(4)
pub1.send("e")
pub1.send("f")
pub2.send(5)

// Advanced CombineLatest
// ex> 아이디, 비밀번호

let usernamePub = PassthroughSubject<String, Never>()
let passwordPub = PassthroughSubject<String, Never>()

let validatedCredentialsSubscription = usernamePub.combineLatest(passwordPub)
    .map { (username, password) in
        return !username.isEmpty && !password.isEmpty && password.count > 12
    }
    .sink { isValid in
        print("Credentials valid? \(isValid ? "Yes :)" : "no ;(")")
    }
usernamePub.send("hongildong")
passwordPub.send("123")
passwordPub.send("1234567891234")


// MARK: - Merge
// 같은 타입의 값을 방출하는 두 퍼블리셔를 연결한다. (interleaved)
let pub3 = [1, 2, 3, 4, 5].publisher
let pub4 = [300, 400, 500].publisher
let mergedPub = pub3.merge(with: pub4)
    .sink { value in
        print("Merged Publisher Received: \(value)")
    }
//Publishers.Merge(pub3, pub4).sink { value in
//    print("Merged Publisher Received: \(value)")
//}

//: [Next](@next)
