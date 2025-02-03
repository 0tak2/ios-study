import UIKit

var greeting = "Hello, playground"

// --

print("Hello, world!")

// -- 변수와 상수

var myVariable = 42.0
myVariable = 50.0
myVariable

let myConstant = 42
// myConstant = 22 // error

print(type(of: myVariable))

let experimentVariable: Double
// print(experimentVariable) // error

// -- 보간법

let apples: Int = 3
let oranges: Int = 5
let appleSummary = "I have \(apples) apples."
let orangeSummary = "I have \(oranges) apples."

// -- 멀티라인

let quotation = """
    왼쪽에 공백문자가 있더라도, 실제
    라인은 들여써지지 않습니다.
        이 라인은 한 번 들여썼으니 예외입니다.
    쌍따옴표 (")도 여기에서는 이스케이프되지 않아도 잘 표현할 수 있습니다.

    여전히 \(apples + oranges)개의 과일이 있다는 것을 백슬래시를 통해 나타낼 수 있지요.
    """

// -- 배열과 딕셔너리

var fruits: [String] = ["딸기", "라임", "귤"]
print(fruits)
fruits[1] = "포도"
print(fruits)
fruits.append("블루베리")
print(fruits)

var occupations: [String: String] = [ // not '{' but '['
    "Malcom": "Captain",
    "Kaylee": "Mechanic",
]
print(occupations)
occupations["Jayne"] = "Public Relations"
print(occupations)

fruits = []
print(fruits)
occupations = [:]
print(occupations)

// -- 컨트롤 플로우

let individualScores: [Int] = [75, 43, 103, 87, 12]
var teamScore: Int = 0
for score in individualScores {
    if score > 50 {
        teamScore += 3
    } else {
        teamScore += 1
    }
}
print(teamScore) // 11

let scoreDecoration = if teamScore > 10 {
    "🎉"
} else {
    ""
}

print("Scores: \(teamScore)", scoreDecoration)

// -- 옵셔널

var optionalString: String? = "Hello"
print(optionalString == nil) // false

var optionalName: String? = "홍길동"
var greetingMsg = "Hello!"
if let name = optionalName {
    greetingMsg = "Hello, \(name)"
}
print(greetingMsg)

//

func generateGreetngMsg(name: String? = nil) -> String {
    if let name = name {
        return "Hello, \(name)!"
    } else {
        return "Hello!"
    }
}

print(generateGreetngMsg())
print(generateGreetngMsg(name: "영택"))

//

struct Member {
    var fullname: String
    var nickname: String?
}

func generateGreetngMsgToMember(member: Member) -> String {
    return "Welcome, \(member.nickname ?? member.fullname)"
}

var member1: Member = Member(fullname: "홍길동")
var member2: Member = Member(fullname: "홍길동", nickname: "길똥이")

print(generateGreetngMsgToMember(member: member1))
print(generateGreetngMsgToMember(member: member2))

// -- 스위치

let vegetable = "청양 고추"
switch vegetable {
case "셀러리":
    print("Add some raisins and make ants on a log.")
case "오이", "물냉이":
    print("That would make a good tea sandwich.")
case let x where x.hasSuffix("고추"):
    print("Is it a spicy \(x)?")
default:
    print("Everything tastes good in soup.")
}

// -- 반복 (for in)

let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]

var largest = 0;
// for (_, numbers) in interestingNumbers {
for (kind
     , numbers) in interestingNumbers { // (key, value)
    print("exploring numbers in \(kind)...")
    for number in numbers {
        if (number > largest) {
            largest = number
        }
    }
}
print(largest) // 25

// -- 반복 (while)

var n = 2
while n < 100 { // 128 is over than 100
    n *= 2
}
print(n) // 128

var m = 2
repeat {
    m *= 2
} while m < 100
print(m) // 128

n = 2
while n < 0 { // 2 is over than 100
    n *= 2
}
print(n) // 0

m = 2
repeat {
    m *= 2
} while m < 0
print(m) // 4

// -- 반복 (for in range)
var total = 0
for i in 0..<4 {
    total += i
}
print(total) // 6

total = 0
for i in 0...4 {
    total += i
}
print(total) // 10

// -- 함수와 클로져

func greetMsg(person: String, day: String) -> String {
    return "\(person)님 안녕하세요, 즐거운 \(day)입니다."
}
greetMsg(person: "영택", day: "금요일")

func menuInfoMsg(_ person: String,_ menuList: [String]) -> String {
    var concatanatedMenus = "";
    for menu in menuList {
        concatanatedMenus += menu + ", "
    }
    
    // remove last comma ", "
    let menuStrStartIndex = concatanatedMenus.startIndex
    let menuStrEndIndex = concatanatedMenus.index(concatanatedMenus.endIndex, offsetBy: -2)
    concatanatedMenus = String(concatanatedMenus[menuStrStartIndex..<menuStrEndIndex]) // cast Substring to String
    return "\(person)님, 준비된 메뉴는 다음과 같습니다: " + concatanatedMenus
}

greetMsg(person: "영택", day: "금요일")
menuInfoMsg("영택", ["전주비빔밥", "만두국", "제육볶음"])

//

func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
    var min = scores[0];
    var max = scores[0];
    var sum = 0;
    
    for score in scores {
        if (score < min) {
            min = score
        } else if (score > max) {
            max = score
        }
        
        sum += score;
    }
    
    return (min, max, sum)
}
let statics = calculateStatistics(scores: [5, 3, 100, 3, 9])
print("sum=\(statics.2) min=\(statics.min) max=\(statics.max)") // 인덱스 및 이름으로 지칭할 수 있음

//

func incrementerFactory(_ amount: Int) -> ((Int) -> Int) {
    func incrementer(target: Int) -> Int {
        return target + amount
    }
    
    return incrementer
}
var increment10 = incrementerFactory(10)
var increment100 = incrementerFactory(100)
increment10(2) // 12
increment100(2) // 102

//

func filterMatched(list: [Int], condition: ((Int) -> Bool)) -> [Int] {
    var filtered: [Int] = []
    
    for number in list {
        if condition(number) {
            filtered.append(number)
        }
    }
    
    return filtered
}

func checkPrime(number: Int) -> Bool {
    if number % 2 == 0 {
        return true;
    }
    
    return false;
}

filterMatched(list: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], condition: checkPrime)

/*
 클로저는 보통 아래와 같이 표현한다.
 ```
 {(매개 변수들) -> 변환 타입 in
    실행 코드
 }
 ```
 */
filterMatched(list: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], condition: { (number: Int) -> Bool in
    return number >= 5
})

//

let numbers = [20, 19, 7, 12]
numbers.map({ (number: Int) -> Int in
        return number + 3
})

//

let sortedNumbers1 = numbers.sorted(by: { (a: Int, b: Int) -> Bool in
        return a < b
})

let sortedNumbers2 = numbers.sorted() { (a: Int, b: Int) -> Bool in // 후행 클로저: 마지막 인자인 클로져는 뒤로 뺄 수 있다.
    return a < b
}

let sortedNumbers3 = numbers.sorted { (a: Int, b: Int) -> Bool in // 인자가 클로저 하나인 경우 괄호도 생략할 수 있다.
    return a < b
}

let sortedNumbers4 = numbers.sorted { $0 < $1 } // 단축 인자 이름: 클로저 인자는 이름이 아닌 순서로 표현할 수 있다.

// -- 오브젝트와 클래스

class Shape {
    var numberOfSides = 0
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}

var shape = Shape()
shape.numberOfSides = 7
print(shape.simpleDescription())

//

class NamedShape {
    var numberOfSides: Int = 0;
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func simpleDescription() -> String {
        return "The shape \"\(name)\" has \(numberOfSides) sides."
    }
}
var namedShape = NamedShape(name: "Square")
namedShape.numberOfSides = 4
print(namedShape.simpleDescription())

//

class SimpleShape: CustomStringConvertible {
    let name: String
    let numberOfAngles: Int
    let numberOfSides: Int
    
    var description: String
    
    init(name: String, angles: Int) {
        self.name = name;
        self.numberOfAngles = angles;
        self.numberOfSides = angles;
        self.description = """
        [SimpleShape]
        - name: \(self.name)
        - angles: \(self.numberOfSides)
        - sides: \(self.numberOfSides)
        """
    }
    
    
    func simpleDescription() -> String {
        return "The shape \"\(name)\" has \(numberOfSides) sides."
    }
}

var simpleShape = SimpleShape(name: "Triangle", angles: 3)
print(simpleShape)
print(simpleShape.simpleDescription())

//

class Square: SimpleShape {
    var sideLength: Double
    
    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name, angles: 4)
    }
    
    func area() -> Double {
        return sideLength * sideLength
    }
    
    override func simpleDescription() -> String {
        return "A square with sides of length \(sideLength)."
    }
}
let squareTest = Square(sideLength: 5.2, name: "Test Square")
squareTest.area()
squareTest.simpleDescription()
print(squareTest)

//

class EquilateralTriangle : SimpleShape { // 정삼감형
    var sideLength: Double
    
    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name, angles: 3)
    }
    
    var perimeter: Double { // 둘레
        // getter, setter를 이용해 계산 속성으로 만들었다
        get {
            return 3.0 * sideLength
        }
        set {
            sideLength = newValue / 3.0
        }
    }
    
    override func simpleDescription() -> String {
        return "An equilateral triangle with sides of length \(sideLength)."
    }
}
let triangleTest = EquilateralTriangle(sideLength: 3.1, name: "정삼각형")
print(triangleTest.perimeter)
triangleTest.perimeter = 9.9
print(triangleTest.sideLength)

// 그 외에도 willSet, didSet 등을 지정해 속성에 값을 set할 때 전처리와 후처리를 할 수 있다

// -- 열거형

enum Rank: Int {
    case ace = 1 // 0이 아닌 1로 명시. 명시 안하면 0부터 시작
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king
    
    func simpleDescription() -> String {
        switch self {
        case .ace:
            return "ace"
        case .jack:
            return "jack"
        case .queen:
            return "queen"
        case .king:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}
let ace = Rank.ace
let aceRawValue = ace.rawValue

let jack = Rank.jack
print(jack.simpleDescription())
print(jack.rawValue)

if let rankByOrder = Rank(rawValue: 13) {
    let description = rankByOrder.simpleDescription()
}

//

enum ServerResponse {
    case result(String, String)
    case failure(String)
}

let successResp = ServerResponse.result("6:00 am", "8:09 pm")
let failureResp = ServerResponse.failure("Out of cheese.")

switch successResp {
case let .result(sunrise, sunset):
    print("Sunrise is at \(sunrise) and sunset is at \(sunset).")
case let .failure(message):
    print("Failure...  \(message)")
}

// 소결
// One of the most important differences between structures and classes is that structures are always copied when they’re passed around in your code, but classes are passed by reference.

// -- 프로토콜

protocol ExampleProtocol {
    var simpleDescription: String { get }
    mutating func adjust()
}

class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "A very simple class."
    var anotherProperty: Int = 69105
    
    func adjust() {
        simpleDescription += " Now 100% adjusted."
    }
}

var a = SimpleClass()
a.adjust()
let aDescription = a.simpleDescription

struct SimpleStructure: ExampleProtocol {
    var simpleDescription: String = "A simple structure"
    
    mutating func adjust() { // 구조체의 메서드 내에서 속성을 수정해야할 때에는 mutating으로 선언되어야 한다
        simpleDescription += " (adjusted)"
    }
}
var b = SimpleStructure()
b.adjust()
let bDescription = b.simpleDescription

/*
 구조체는 값 타입으로, 구조체 내의 메서드를 실행하면 메서드는 해당 구조체의 복사본을 self로 참조하게 된다.
 따라서 만약 mutating 키워드 없이 구조체의 속성을 변경해도 컴파일 에러가 발생하지 않는다고 가정해도,
 원본 구조체의 속성은 변경되지 않을 것이다.
 
 반면 mutating으로 정의된 메서드에서 self의 속성을 변경하면 원본 구조체의 속성이 변경된다.
 */

// - 에러 핸들링

enum PrinterError: Error {
    case outOfPaper
    case noToner
    case onFire
}

func sendToPrinter(job: Int, toPrinter printerName: String) throws -> String {
    if printerName == "NoTonerPrinter" {
        throw PrinterError.noToner
    }
    
    // todo: send job to the printer
    
    return "Job sent"
}

do {
    let PrinterResponse = try sendToPrinter(job: 1040, toPrinter: "Samsung")
    print(PrinterResponse)
} catch {
    print(error)
}

do {
    let PrinterResponse = try sendToPrinter(job: 1040, toPrinter: "NoTonerPrinter")
    print(PrinterResponse)
} catch PrinterError.noToner {
    print("No Toner Error...")
} catch {
    print(error)
}

//

let printerSuccess = try? sendToPrinter(job: 1884, toPrinter: "Brother")
let printerFailure = try? sendToPrinter(job: 1885, toPrinter: "NoTonerPrinter") // nil

// defer

var fridgeIsOpen = false
let fridgeContent = ["milk", "eggs", "leftovers"]


func fridgeContains(_ food: String) -> Bool {
    fridgeIsOpen = true
    defer {
        fridgeIsOpen = false
    }


    let result = fridgeContent.contains(food)
    return result
}
if fridgeContains("banana") {
    print("Found a banana")
}
print(fridgeIsOpen) // false

// -- 제네릭

func makeArray<Item>(repeating item: Item, numberOfTimes: Int) -> [Item] {
    var result: [Item] = []
    for _ in 0..<numberOfTimes {
        result.append(item)
    }
    return result
}
makeArray(repeating: "knock", numberOfTimes: 4)
