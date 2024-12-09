import Foundation

// MARK: - Enumerations
/**
 열거형이란 관련 있는 값들을 하나의 타입으로 묶어 놓은 것.
 C와 달리 각 값의 rawValue는 정수 뿐 아니라 다양한 타입이 될 수 있음.
 또한 스위프트에서 열거형은 first-class 타입으로, 클래스의 기본적인 기능들 - 계산 속성, 인스턴스 메서드 등 제공
 */

// MARK: 예시
enum CompassPoint {
    case north
    case south
    case east
    case west
}

enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}

var direction = CompassPoint.north
direction = .south // 타입 추론 됨

var direction2: CompassPoint = .south

// MARK: Switch 문에서 열거형 사용
switch direction {
case .north:
    print("Lots of planets have a north")
case .south:
    print("Watch out for penguins")
case .east:
    print("Where the sun rises")
case .west:
    print("Where the skies are blue")
}

let somePlanet = Planet.earth
switch somePlanet {
case .earth:
    print("Mostly harmless")
default: // switch문은 모든 경우를 포괄적으로 다뤄야하기 때문에, 모든 값을 나열하거나 default로 폴백 케이스를 처리해야 한다.
    print("Not a safe place for humans")
}

// MARK: 열거형 순회
/**
 열거형에 대해 CaseIterable 프로토콜을 준수하게 하면, allCases 프로퍼티를 통해 모든 값을 배열로 받을 수 있다.
 적어두기만 하면 컴파일러가 알아서 구현해준다.
 */
enum Beverage: CaseIterable {
    case coffee, tea, juice
}
let numberOfChoices = Beverage.allCases.count
print("\(numberOfChoices) beverages available")
// Prints "3 beverages available"

for item in Beverage.allCases {
    print(item)
}

// MARK: Associated Values
/**
 특정한 열거형 값에 대한 추가적인 값들을 같이 포함할 수 있다. 이를 Associated Values라고 한다.
 */
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

var productBarcode1 = Barcode.upc(8, 85909, 51226, 3)
var productBarcode2 = Barcode.qrCode("ABCDEFGHIJKLMNOP")

// switch에서 Associated Values 받기
switch productBarcode1 {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}

// MARK: Raw Values
/**
 열거형 각 값에 대한 기본값들을 할당해둘 수 있다.
 */

enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

// 암시적 로우 값 할당
// 정수나 문자열 타입이라면 암시적으로 로우 값을 할당할 수 있다.
enum Planet2: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}

enum CompassPoint2: String {
    case north, south, east, west
}

let earthsOrder = Planet2.earth.rawValue
// earthsOrder is 3

let sunsetDirection = CompassPoint2.west.rawValue
// sunsetDirection is "west"

// 반대로 로우 값을 가지고 열거형을 초기화할 수도 있다. 이 경우 반환 값은 옵셔널 타입이다.
let ascii = ASCIIControlCharacter(rawValue: "\t")
if let ascii = ascii {
    print("you mean \(ascii)")
}

// MARK: 재귀적 열거형
// indirect 키워드를 이용해 재귀적으로 값을 정의할 수도 있다.

enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}
/*
 // 아래처럼 쓸 수도 있다.
 indirect enum ArithmeticExpression {
     case number(Int)
     case addition(ArithmeticExpression, ArithmeticExpression)
     case multiplication(ArithmeticExpression, ArithmeticExpression)
 }
 */

let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}

print(evaluate(product))
print(evaluate(.multiplication(.addition(.number(1), .number(4)), .multiplication(.number(5), .number(2))))) // (1 + 4) * (5 * 2)
