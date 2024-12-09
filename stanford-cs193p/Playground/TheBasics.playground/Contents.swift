import Swift
import Foundation

// MARK: The Basics
// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/thebasics

// MARK: - Tuples

typealias HttpResponse = (code: UInt, message: String) // a tuple representing http response

// MARK: TEST 1
func inspectResponse(_ response: HttpResponse) {
    let (code, message) = response // decompse
    
    print("received a response from server: code=\(code) message=\(message)")
}
inspectResponse((400, "Bad Request"))
inspectResponse((500, "Internel Server Error"))

// MARK: TEST 2
func handleResponse(_ response: HttpResponse) {
    let cat: UInt = response.code / 100 // 또는 인덱스로 가리킬 수도 있다. response.1
    
    switch cat {
    case 1, 2:
        handleSuccess(response) // break는 기본적으로 생략한다. break되지 않게 하고 싶을 경우 `fallthrough` 키워드 사용
    case 3:
        handleRedirect(response)
    case 4, 5:
        handleError(response)
    default:
        print("Unusual reponse... code=\(response.code) message=\(response.message)")
    }
}

func handleSuccess(_ response: HttpResponse) {
    let (code, message) = response
    print("request succeed... code=\(code) message=\(message)")
    // TODO: 성공 처리
}

func handleRedirect(_ response: HttpResponse) {
    let (code, message) = response
    print("3XX response... code=\(code) message=\(message)")
    
    // TODO: 리디렉션 처리
    
    if code == 304 { // not modified
        print("will use local cache...")
    }
    
    // retry()
}

func handleError(_ response: HttpResponse) {
    let (code, message) = response
    print("request failed... code=\(code) message=\(message)")
    
    // TODO: 실패 처리
    
    if code >= 400 && code < 500 {
        print("sent request may be invalid...")
        return
    }
    
    if code >= 500 && code < 600 {
        print("server error...")
        return
    }
    
    print("unusual error")
}

handleResponse((code: 200, message: "Okay"))
handleResponse((code: 404, message: "Not Found"))
handleResponse((code: 304, message: "Not Modified"))
handleResponse((code: 307, message: "Temporary Redirect"))
handleResponse((code: 500, message: "Internal Server Error"))
handleResponse((code: 0, message: "unexpected error"))

// MARK: - Optionals

let numberAsString: String = "12341243"
let convetedNumber: Optional<Int> = Int(numberAsString)
print(convetedNumber) // Optional(12341243)

// let addTest = convetedNumber + 1024 // Value of optional type 'Int?' must be unwrapped to a value of type 'Int'
let addTest: Int
if let convertedAndValidated = convetedNumber {
    addTest = convertedAndValidated + 1024
} else {
    addTest = -1
}
print(addTest)

// nil
var nullableString: String?
print(nullableString) // nil. var로 선언한 옵셔널 타입의 변수는 초기값을 할당하지 않으면 nil로 초기화된다
var notNilString: String // 초기화되기 전까지는 사용할 수 없다
// print(notNilString) // Variable 'notNilString' used before being initialized

/**
 스위프트에서 nil은 오직 옵셔널 타입에만 할당할 수 있다. 따라서 스위프트에서는 빈 값에 대한 핸들링을 안전하고 명시적으로 할 수 있다.
 예컨대 옵셔널 값을 다뤄야 할 때, 한 번만 unwrap하면 그 스코프 안에서는 다시 nil 체크를 할 필요가 없다. 자바의 NPE나 C++의 Segmentation Fault 등에서 자유로워질 수 있다.
 
 옵셔널 값을 다루는 방법은 다음의 네 가지 방법이 있다.
 1. 값이 nil이면 작업을 실행하지 않고 넘어간다
 2. 값이 nil이면 nil을 리턴하거나 ?. 연산자를 이용해 nil을 다음으로 전파한다. (옵셔널 체이닝)
 3. 값이 nil이면 ?? 연산자를 이용해 폴백값을 할당하고, 작업을 수행한다.
 4. 값이 nil이면 ! 연산자를 이용해 더 이상 프로그램을 실행하지 않고 종료한다.
 */

// - 옵셔널 바인딩
// 옵셔널 타입의 값이 nil이 아니면 임시 상수나 변수에 할당해서 참조
// example: if let -, guard let -, while let -
/**
```
 if let <#constantName#> = <#someOptional#> {
    <#statements#>
 }
 ```
 */

func getScoreProvider() -> () -> UInt? {
    print("will create a new scoreProvider...")
    
    var index: Int = 0
    let rawData: [String] = ["100", "93", "85", "82", "81", "76", "73", "no data", "no data"]
    return {
        if index >= rawData.count {
            return nil
        }
        
        let raw: String = rawData[index]
        index += 1
        return UInt(raw)
    }
}

let scoreProvider1: () -> UInt? = getScoreProvider()
var passedCount: Int = 0
for _ in 0..<10 {
    if let score = scoreProvider1(), score >= 80 { // 옵셔널 바인딩과 Boolean 조건문을 같이 쓸 수도 있음
        print("Passed: \(score)")
        passedCount += 1
    } else {
        print("Invalid Score or Low Score...")
    }
}

// - Providing a Fallback Value
let scoreProvider2: () -> UInt? = getScoreProvider()
var scoreSum: UInt = 0
for _ in 0..<10 {
    scoreSum += scoreProvider2() ?? 0
}
print("Sum: \(scoreSum)")

// - Force Unwrapping
let scoreProvider3: () -> UInt? = getScoreProvider()
//for _ in 0..<10 {
//    let score: UInt = scoreProvider3()!
//    print(score)
//    /*
//     100
//     93
//     85
//     82
//     81
//     76
//     73
//     __lldb_expr_87/TheBasics.playground:162: Fatal error: Unexpectedly found nil while unwrapping an Optional value
//     */
//}

/**
 ! 연산자를 사용하면 다음을 축약한 것과 동일한 기능을 한다.
 ```
 guard let score = scoreProvider3() else {
     fatalError("Unexpectedly found nil while unwrapping an Optional value")
 }
 ```
 */


// - Implicitly Unwrapped Optionals
// nil이 아닌 경우가 너무나도 확실한 경우, unwrapping이 암시적으로 이뤄지도록 다음과 같이 할 수 있다.

let assumedString: String! = "An implicitly unwrapped optional string."
let implicitString: String = assumedString // Unwrapped automatical

// String? 타입은 값이 필요한 시점에 위와 같이 옵셔널 바인딩, 강제 Unwrapping 등의 방법으로 직접 Unwrapping을 수행한다.
// 이와는 달리 String! 타입은 자동으로 Unwrapping 되므로, 값을 참조할 떄마다 매번 명시적으로 Unwrapping을 할 필요가 없다.

// 다만 컴파일러는 먼저 Optional 타입으로 할당 가능한지 보고, 가능하면 Optional 타입으로 할당한다
let optionalString: String? = assumedString
let notOptionalString: String = assumedString

// nil인 경우
let testOptional: String! = nil // String? 타입처럼 정의하고 nil을 할당하는 데에 문제가 없다.
let testStringOptional: String? = testOptional // nil이 할당되었을 때, unwrapping할 일이 없다면, 에러 없음
// let testString: String = testOptional // unwrapping 과정 중 에러 발생: error: Execution was interrupted, reason: EXC_BREAKPOINT

