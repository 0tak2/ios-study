import Foundation
import Combine

// PassthroughSubject

let relay = PassthroughSubject<String, Never>() // Never -> 실패할 수 없다
let sub1 = relay.sink { value in
    print("sub1 received: \(value)")
}

"Good Bye 2024 ! Hello 2025".split(separator: " ").forEach { word in
    relay.send(String(word))
}

// CurrentValueSubject

let current = CurrentValueSubject<String, Never>("initial value")
let sub2_1 = current.sink { value in
    print("sub2_1 received: \(value)")
}

let sub2_2 = current.sink { value in
    print("sub2_2 received: \(value)")
}

current.send("second message")

let sub2_3 = current.sink { value in
    print("sub2_3 received: \(value)") // 직전 값이 방출됨
}

current.send("third message")
print("current current.value : \(current.value)")

// experiment
let expPub = ["here", "we", "go"].publisher
expPub.subscribe(relay) // relay.send("here"); relay.send("we"); relay.send("go");
expPub.subscribe(current)
// TODO: ^ 이거 잘 아해 안됨

