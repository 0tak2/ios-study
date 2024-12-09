import Foundation

// MARK: - Closures
/**
 클로져는 자체적으로 기능을 가지고 있는 코드 블록으로, 인자로서 넘겨질 수 있고 코드의 다른 부분에서 실행될 수 있다.
 
 클로저는 정의된 컨텍스트에서 접근 가능한 상수와 변수를 가질 수 있다. (closing. closure라는 명칭이 여기서 왔다)
 스위프트 문서에서는 이를 capture(포획, 획득)이라고 부르고 있다. *야곰의 책에서는 이를 획득이라고 번역했으나 capture, closing이라는 개념에
 "이미 메모리에서 사라졌어야 하는 상위 스코프의 상수나 변수를 클로져가 가지고 있을 수 있다"는 의미가 내포되어 있으므로 capture의 원 뜻을 살려
 포획이라고 이해하는 것이 더 적절해보인다.
 
 클로저에는 다음의 세 가지 종류가 있다.
 1. 이름을 가지고 있고, 어떠한 값도 캡쳐하지 않는 클로져
 2. 이름을 가지고 있고, 자신을 포함하고 있는 상위 함수로부터 값을 캡쳐하는 클로져
 3. 이름이 없고, 상위 컨텍스트에서 값을 캡쳐하는 클로져
 
 스위프트에서는 함수를 클로져의 일종으로 본다. 예컨대 위의 분류에서 1에 해당하는 것이 전역함수이며, 2에 해당하는 것이 중첩함수가 된다.
 3에 해당하는 것은 클로져 표현식으로 정의한 클로져가 될 것이다.
 */

// MARK: - 클로져 표현식
// 예로, Arrays:sorted에 클로져를 넘겨 정렬시킬 때,
// 일반 함수를 사용한다면,

let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversedNames = names.sorted(by: backward)
print(reversedNames)
 
// 클로져 표현식을 사용한다면,
/**
 // 1. 원래 함수
 ```
 func backward(_ s1: String, _ s2: String) -> Bool {
     return s1 > s2
 }
 ```
 
 // 2. 원래 함수에서 func 키워드와 함수 이름을 삭제
 ```
 (_ s1: String, _ s2: String) -> Bool {
     return s1 > s2
 }
 ```
 
 // 3. 여기서 함수 시그니처 부분을 { } 안으로 옮기고 in 키워드 붙이기
 ```
 { (_ s1: String, _ s2: String) -> Bool in
     return s1 > s2
 }
 ```
 
 // 4. 그대로 인자로 넘기기
 ```
 arr.sorted(by: { (_ s1: String, _ s2: String) -> Bool in
     return s1 > s2
 })
 ```
 */
var reversedNames2 = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})
print(reversedNames2)

// 한 줄로 줄이면,
var reversedNames3 = names.sorted(by: { (s1: String, s2: String) in return s1 > s2 })
print(reversedNames3)

// 타입을 생략하면,
var reversedNames4 = names.sorted(by: { s1, s2 in return s1 > s2 })
print(reversedNames4)
// Arrays::sorted(by:)의 by 패러미터 정의를 이용해 타입을 추론해준다.

// 암시적으로 리턴하면,
var reversedNames5 = names.sorted(by: { s1, s2 in s1 > s2 })
print(reversedNames5)

// 인자명을 단축하면, (shorthand argument names)
var reversedNames6 = names.sorted(by: { $0 > $1 })
print(reversedNames6)
// 표현식 한 개로 되어있는 인라인 클로져의 경우 인자명을 단축할 수 있다.

// Operator Methods를 이용해 더 단축하기
var reversedNames7 = names.sorted(by: >)
print(reversedNames7)
// 연산 메서드인 ">"를 by로 받는 클로져의 두 인자의 타입인 String에서 구현하고 있으므로 >를 지정해 단축할 수 있다.

// 후행 클로져로 넘기면,
// *마지막 인자로 클로져를 넘겨야 하는 경우, 클로져의 길이가 길어 가독성을 방해한다면, 괄호를 닫은 후 코드블록을 다시 열어 클로져를 넘길 수 있다. (후행 클로져)
var reversedNames8 = names.sorted() {
    $0 > $1
}
print(reversedNames8)
// 이때, 유일한 인자가 클로져라면, 괄호도 생략할 수 있다.
var reversedNames9 = names.sorted {
    $0 > $1
}
print(reversedNames9)


// MARK: - 후행 클로져 응용
// MARK: map 메서드
let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]

let numbersConverted: [String] = numbers.map { (number: Int) -> String in
    var output: String = ""
    var number = number
    repeat {
        output = digitNames[number % 10]! + output // 6, 1 / 8, 5 / 0, 1, 5
        number /= 10
    } while number > 0
    return output
}
print(numbersConverted)

// MARK: 다운로드 핸들링
struct Server {
    let scheme: String
    let baseUrl: String
    var fullBaseUrl: String {
        return scheme + "://" + (baseUrl[baseUrl.endIndex] == "/" ? baseUrl : baseUrl + "/")
    }
}

struct Picture {
}

func download(_ filepath: String, from source: Server) -> Picture? {
    // TODO: 다운로드 구현
    return nil
}

func loadPicture(from server: Server, completion: (Picture) -> Void, onFailure: () -> Void) {
    if let picture = download("photo.jpg", from: server) {
        completion(picture)
    } else {
        onFailure()
    }
}

loadPicture(from: Server(scheme: "https", baseUrl: "site.com")) {(picture: Picture) in
    dump(picture)
} onFailure: {
    print("failed")
}

// MARK: - Capturing Values
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

var incrementer1 = makeIncrementer(forIncrement: 1)
print("Created new counter...")
print(incrementer1()) // 1
print(incrementer1()) // 2
print(incrementer1()) // 3

var incrementer2 = makeIncrementer(forIncrement: 3)
print("Created new counter...")
print(incrementer2()) // 3
print(incrementer2()) // 6
print(incrementer2()) // 9

var incrementer3 = makeIncrementer(forIncrement: 5)
print("Created new counter...")
print(incrementer3()) // 5
print(incrementer3()) // 10
print(incrementer3()) // 15

func makeCounter(for amount: Int = 1) -> (() -> Int, () -> Int) {
    var total = 0
    
    func incrementer() -> Int {
        total += amount
        return total
    }
    
    func decrementer() -> Int {
        total -= amount
        return total
    }
    
    return (incrementer, decrementer)
}

let (incrementer, decrementer) = makeCounter(for: 10)
print("Created new counter...")
print(incrementer())
print(incrementer())
print(incrementer())
print(decrementer())
print(decrementer())
print(incrementer())

// NOTE에 따르면,
// 최적화를 위해 클로져 내에서 캡쳐된 값이 변경되지 않는 경우 복사본을 보관한다
// 그 외 캡쳐된 값이 더 이상 참조되지 않아 메모리에서 할당 해제한다든지 작업은 스위프트가 알아서 수행한다

// MARK: - 클로져는 참조 타입이다
let anotherIncrementer = incrementer
print("result of excuting incrementer(): \(incrementer())")
print("result of excuting incrementer(): \(incrementer())")
print("result of excuting anotherIncrementer(): \(anotherIncrementer())")
print("result of excuting anotherIncrementer(): \(anotherIncrementer())")
print("result of excuting incrementer(): \(incrementer())")
print("result of excuting anotherIncrementer(): \(anotherIncrementer())")
// 두 상수 incrementer, anotherIncrementer는 모두 같은 클로져를 가리키고 있다.
// 상수지만 참조 변수일 뿐이기 때문에, 클로져 내부의 total 값은 변경된다.

// @escaping
// @escaping은 함수 시그니쳐에서 특정 클로져 인자에 붙어, 해당 클로저 인자가 이스케이핑 클로져임을 표시한다.
// 이스케이핑 클로져란, 해당 클로져가 함수가 리턴되고 나서도 실행되는 클로저이다.

// 굳이 왜 필요할까? 아마도 컴파일러 최적화를 위해: https://stackoverflow.com/questions/67304880/swift-why-is-escaping-needed
var completionHandlers: [() -> Void] = []

@MainActor
func doSomething(_ onComplete: @escaping () -> Void) { // @MainActor로 명시하지 않으면, `Main actor-isolated var 'completionHandlers' can not be mutated from a nonisolated context` 오류 발생
    // TODO: do something
    completionHandlers.append(onComplete)
}

doSomething {
    print("hi 1")
}

doSomething {
    print("hi 2")
}

completionHandlers.enumerated().forEach { (index, handler) in
    print("#\(index + 1) handler will be invoked...")
    handler()
}

// @autoclosure
// @autoclosure는 함수 시그니쳐에서 특정 클로져 인자에 붙어, 해당 클로저 인자가 자동으로 클로저로 래핑되도록 한다.
// 이를 적용하면, 함수 실행 시 단순 값을 넘기면, 함수 안에는 해당 값을 리턴하는 클로져로 전달해준다.

// 이때 이 클로져는 함수 내에서 실행되기 전까지 평가되지 않는다.
func autoClosureExample(useNumber: Bool, nextValue: @autoclosure () -> Int) {
    if useNumber {
        print(nextValue())
    } else {
        print("skip")
    }
}

func createNumberProvider() -> (() -> Int) {
    var number = 0
    return {
        print("provider invoked...")
        
        number += 1
        return number
    }
}

autoClosureExample(useNumber: false, nextValue: 1) // 이렇게 클로져가 아닌 값을 전달할 수 있어 간편하다.

let numberProvider: () -> Int = createNumberProvider()
autoClosureExample(useNumber: false, nextValue: numberProvider()) // skip -- numberProvider()를 넘겼기 때문에 혼동할 수 있지만, 실제로는 평가되지 않았다.
autoClosureExample(useNumber: false, nextValue: numberProvider()) // skip -- 역시 평가되지 않는다.
autoClosureExample(useNumber: true, nextValue: numberProvider()) // 1

// 따라서 이런 구현이 가능하다.
// ref: https://stackoverflow.com/a/45661827
func getMyStringSuperHeavy() -> String {
    // 이 부분의 계산 시간이 아주 오래 걸린다고 하자
    return "hello, log"
}

enum LogLevel: Int, Comparable {
    static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    case debug = 0
    case info = 1
    case error = 2
}

let currentLogLevel: LogLevel = .info // 현재 로그 레벨은 Info

func outputLogAutoClosure(_ level: LogLevel, message: @autoclosure ()->String) {
    if level >= currentLogLevel {
        print(message())
    }
}

outputLogAutoClosure(.debug, message: "Debug message")
// output nothing, calling cost can be acceptable.

outputLogAutoClosure(.debug, message: getMyStringSuperHeavy())
// output nothing, calling cost can be acceptable as well.

outputLogAutoClosure(.error, message: "Error Message")
// 이 메시지는 잘 출력된다.
