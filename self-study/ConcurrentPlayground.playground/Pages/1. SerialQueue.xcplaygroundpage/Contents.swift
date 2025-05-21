//: [Previous](@previous)
import Foundation

// MARK: - SerialQueue 테스트
let serialQueue = DispatchQueue(label: "com.0tak2.gcd.serialQueue")

serialQueue.sync { // Blocking
    print("\(serialQueue.label) start 1")
    sleep(2)
    print("\(serialQueue.label) end 1")
}

serialQueue.sync { // Blocking
    print("\(serialQueue.label) start 2")
    sleep(2)
    print("\(serialQueue.label) end 2")
}

print("sync test")


serialQueue.async { // Non Blocking
    print("\(serialQueue.label) start 3")
    sleep(2)
    print("\(serialQueue.label) end 3")
}

serialQueue.async { // Non Blocking
    print("\(serialQueue.label) start 4")
    sleep(2)
    print("\(serialQueue.label) end 4")
}

print("async test")

// DEADLOCK -> sync 안에 sync는 중첩 금지
//serialQueue.sync { // error: Execution was interrupted, reason: EXC_BREAKPOINT (code=1, subcode=0x18018ceec).
//    print("Outer")
//    
//    serialQueue.sync { // serialQueue를 기다리지만 끝나지 않는다...
//        print("Nested")
//    }
//}

// DEADLOCK 2
//serialQueue.async { // 이건 오류도 안난다
//    print("Outer")
//    
//    serialQueue.sync {
//        print("Nested")
//    }
//}

// FIX
serialQueue.sync {
    print("Outer")
    
    serialQueue.async { // serialQueue를 기다리지만 끝나지 않는다...
        print("Nested")
    }
}

//: [Next](@next)
