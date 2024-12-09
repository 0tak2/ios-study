import Foundation

// MARK: - Structures and Classes

// MARK: 비교
/**
 - 공통 기능
   1. 프로퍼티 정의
   2. 메서드 정의
   3. 서브스크립트 정의
   4. 이니셜라이저 정의
   5. 기능 확장
   6. 프로토콜 준수
 
 - 클래스의 추가 기능
   1. 상속
   2. 런타임에서의 타입캐스팅
   3. 디이니셜라이저 정의
   4. 하나의 인스턴스를 여러 참조 변수로 가리킬 수 있음
 
 - 구조체의 추가 기능
   1. 기본 이니셜라이저가 정의되어 있음
 */

// MARK: 구조체와 열거형은 값 타입이다
struct Resolution {
    var width = 0
    var height = 0
}

let hd = Resolution(width: 1920, height: 1080)
var cinema = hd // 구조체 전체 내용이 메모리의 새 공간에 복사된다. (실제로는 최적화를 거쳐 COW 될 것)
cinema.width = 2048

print("cinema is now \(cinema.width) pixels wide")
// Prints "cinema is now 2048 pixels wide"

print("hd is still \(hd.width) pixels wide")
// Prints "hd is still 1920 pixels wide"

// 열거형도 마찬가지로 값 타입
enum CompassPoint {
    case north, south, east, west
    mutating func turnNorth() { // 열겨헝도 mutating을 붙인다
        self = .north
    }
}
var currentDirection = CompassPoint.west
let rememberedDirection = currentDirection // 복사
currentDirection.turnNorth()

print("The current direction is \(currentDirection)")
print("The remembered direction is \(rememberedDirection)")
// Prints "The current direction is north"
// Prints "The remembered direction is west"

// MARK: 클래스는 참조 타입이다
class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}

let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty // 주소가 복사된다.
alsoTenEighty.frameRate = 30.0

print("The frameRate property of tenEighty is now \(tenEighty.frameRate)")
// Prints "The frameRate property of tenEighty is now 30.0"

// MARK: 클래스에 대한 Identity Operators
/**
 클래스 인스턴스의 참조 변수, 상수에 대해 ===, !== 연산자를 통해 동일성을 비교할 수 있다.
 동등성을 비교할 때 사용하는 연산자인 ==, !=와 달리 같은 인스턴스가 맞는지를 비교한다.
 */
if tenEighty === alsoTenEighty {
    print("tenEighty and alsoTenEighty refer to the same VideoMode instance.")
}

let tenEightyRealCopy = VideoMode()
tenEightyRealCopy.resolution = hd
tenEightyRealCopy.interlaced = true
tenEightyRealCopy.name = "1080i"
tenEightyRealCopy.frameRate = 30.0

if tenEighty !== tenEightyRealCopy {
    print("tenEighty and tenEightyRealCopy refer to different VideoMode instances.")
}

print(ObjectIdentifier(tenEighty))
print(ObjectIdentifier(tenEightyRealCopy))
