import Foundation

// MARK: - ConcurrentQueue 테스트
let concurrentQueue = DispatchQueue(label: "com.0tak2.gcd.concurrentQueue", attributes: .concurrent)

concurrentQueue.sync { // Blocking
    print("\(concurrentQueue.label) start 1")
    sleep(2)
    print("\(concurrentQueue.label) end 1")
}

concurrentQueue.sync { // Blocking
    print("\(concurrentQueue.label) start 2")
    sleep(2)
    print("\(concurrentQueue.label) end 2")
}

concurrentQueue.async { // Non Blocking
    print("\(concurrentQueue.label) start 3")
    sleep(2)
    print("\(concurrentQueue.label) end 3")
}

concurrentQueue.async {
    print("\(concurrentQueue.label) start 4")
    sleep(2)
    print("\(concurrentQueue.label) end 4")
}
