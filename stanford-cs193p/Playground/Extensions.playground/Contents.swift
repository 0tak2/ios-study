// MARK: - Extensions
/**
 Extensions은 이미 존재하는 구조체, 클래스, 열거형, 프토로콜을 확장하는데 사용할 수 있다.
 
 가능한 것
 1. 계산 인스턴스 프로퍼티, 계산 타입 프로퍼티 추가
 2. 인스턴스 메서드나 타입 메서드 추가
 3. 이니셜라이저 추가
 4. 서브스크립트 추가
 5. 새로운 중첩 타입을 추가로 정의하고, 사용
 6. 기존 타입을 특정 프로토콜을 준수하도록 만들기 참고: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols#Adding-Protocol-Conformance-with-an-Extension
 */

// MARK: 계산 속성 추가
extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
let oneInch = 25.4.mm
print("One inch is \(oneInch) meters")
// Prints "One inch is 0.0254 meters"
let threeFeet = 3.ft
print("Three feet is \(threeFeet) meters")
// Prints "Three feet is 0.914399970739201 meter
let TwelveCentimeters = 12.cm
print("Twelve Centimeters is \(TwelveCentimeters) meters")
// Twelve Centimeters is 0.12 meters


// MARK: 이니셜라이저 추가
// 기존
struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}

// 익스텐션으로 확장
extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

// 활용
let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
    size: Size(width: 3.0, height: 3.0))
// centerRect's origin is (2.5, 2.5) and its size is (3.0, 3.0)

// MARK: 메서드 추가
extension Int {
    func repeatTask(task: (Int) -> Void) {
        for i in 0..<self {
            task(i)
        }
    }
}

10.repeatTask { index in
    print("Hello, World \(index + 1)")
}

// Mutating Instance Methods
extension Int {
    mutating func square() {
        self = self * self
    }
}

var five = 5
five.square()
print(five)

// MARK: Subscripts
extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}
print(123456789[4])

// MARK: 중첩 타입 추가
extension Int {
    enum Kind {
        case negative, zero, positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}
print("-23 is \((-23).kind)")
print("12 is \((12).kind)")
