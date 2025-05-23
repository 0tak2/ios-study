//: [Previous](@previous)

import Foundation
import PlaygroundSupport

// MARK: - Playground Setting
// see: https://stackoverflow.com/a/78557392
PlaygroundPage.current.needsIndefiniteExecution = true
defer {
    PlaygroundPage.current.finishExecution()
}

// MARK: - Without Actor
class ConterClass {
    var count: Int = 0
    
    func incremnet() {
        count += 1
    }
    
    func longRunningTask() {
        for _ in (0..<10000) {
            count += 1
        }
    }
}

let counter = ConterClass()

for _ in (0..<10) {
    // Main Thread
    counter.longRunningTask()

    Task.detached {
        counter.longRunningTask()
    }

    Task.detached {
        counter.longRunningTask()
    }
}

sleep(3)

print(counter.count) // 300000? => 매번 다름. 252990, 240934, 252995, ...

// MARK: - Actor

actor CounterActor {
    var count: Int = 0
    
    func incremnet() {
        count += 1
    }
    
    func longRunningTask() {
        for _ in (0..<10000) {
            count += 1
        }
    }
    
    func getCount() -> Int {
        return count
    }
}

let counter2 = CounterActor()

for _ in (0..<10) {
    // Main Thread
    await counter2.longRunningTask()

    Task.detached {
        await counter2.longRunningTask()
    }

    Task.detached {
        await counter2.longRunningTask()
    }
}

sleep(3)

print(await counter2.getCount()) // 300000

//: [Next](@next)
