// MARK: - Protocols

// MARK: 프로퍼티 요구사항
protocol SomeProtocol {
    // 무조건 var 사용
    var mustBeSettable: Int { get set } // get, set 모두 가능해야함
    var doesNotNeedToBeSettable: Int { get } // 최소 get은 가능해야함
    static var someTypeProperty: Int { get }
}

struct TestStruct: SomeProtocol {
    var mustBeSettable: Int // var
    
    var doesNotNeedToBeSettable: Int // let, var
    
    static let someTypeProperty: Int = 0 // let, var
}

class TestClass: SomeProtocol {
    var mustBeSettable: Int // var
    
    var doesNotNeedToBeSettable: Int // let, var
    
    static let someTypeProperty: Int = 0 // let, var
    
    init(mustBeSettable: Int, doesNotNeedToBeSettable: Int) {
        self.mustBeSettable = mustBeSettable
        self.doesNotNeedToBeSettable = doesNotNeedToBeSettable
    }
}

// MARK: 메서드 요구사항
protocol RandomNumberGenerator {
    func random() -> Double
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c)
            .truncatingRemainder(dividingBy:m))
        return lastRandom / m
    }
}
let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
// Prints "Here's a random number: 0.3746499199817101"
print("And another one: \(generator.random())")
// Prints "And another one: 0.729023776863283"

protocol Togglable {
    mutating func toggle() // 구현할 떄, class라면 mutating 키워드를 붙이지 않음.
}

enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}
var lightSwitch = OnOffSwitch.off
lightSwitch.toggle()
// lightSwitch is now equal to .on

// MARK: 이니셜라이저 요구사항
protocol SomeProtocol2 {
    init(someParameter: Int)
}

class SomeClass: SomeProtocol2 {
    // 프로토콜에 이니셜라이저 요구사항이 있는 경우, 클래스로 구현할 때 required 키워드를 붙여야 한다.
    // 상속할 때와 마찬가지...
    required init(someParameter: Int) {
        // initializer implementation goes here
    }
    // 구조체의 경우 상관 없다
}

// 만약 다음과 같이 어떤 클래스에 프로토콜을 구현하면서도 상위 타입을 상속받는데,
// 프로토콜에 이니셜라이저 요구사항이 있으면서도 상위 타입에 동일 이니셜라이저가 정의되어 있을 떄,
// 이니셜라이저를 오버라이딩하려면 required override 키워드를 모두 쓴다... 아놔...
protocol SomeProtocol3 {
    init()
}

class SomeSuperClass {
    init() {
        // initializer implementation goes here
    }
}

class SomeSubClass: SomeSuperClass, SomeProtocol3 {
    // "required" from SomeProtocol conformance; "override" from SomeSuperClass
    required override init() {
        // initializer implementation goes here
    }
}

// MARK: 타입으로서의 프로토콜
// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols#Protocols-as-Types

// MARK: 위임패턴에서의 프로토콜
// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols#Delegation

class DiceGame {
    let sides: Int
    let generator = LinearCongruentialGenerator()
    weak var delegate: Delegate? // 순환참조 방지: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting#Resolving-Strong-Reference-Cycles-Between-Class-Instances


    init(sides: Int) {
        self.sides = sides
    }


    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }


    func play(rounds: Int) {
        delegate?.gameDidStart(self)
        for round in 1...rounds {
            let player1 = roll()
            let player2 = roll()
            if player1 == player2 {
                delegate?.game(self, didEndRound: round, winner: nil)
            } else if player1 > player2 {
                delegate?.game(self, didEndRound: round, winner: 1)
            } else {
                delegate?.game(self, didEndRound: round, winner: 2)
            }
        }
        delegate?.gameDidEnd(self)
    }


    protocol Delegate: AnyObject { // weak과 함께 참조되기 위해 클래스로 제한: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols#Class-Only-Protocols
        func gameDidStart(_ game: DiceGame)
        func game(_ game: DiceGame, didEndRound round: Int, winner: Int?)
        func gameDidEnd(_ game: DiceGame)
    }
}

class DiceGameTracker: DiceGame.Delegate {
    var playerScore1 = 0
    var playerScore2 = 0
    func gameDidStart(_ game: DiceGame) {
        print("Started a new game")
        playerScore1 = 0
        playerScore2 = 0
    }
    func game(_ game: DiceGame, didEndRound round: Int, winner: Int?) {
        switch winner {
            case 1:
                playerScore1 += 1
                print("Player 1 won round \(round)")
            case 2: playerScore2 += 1
                print("Player 2 won round \(round)")
            default:
                print("The round was a draw")
        }
    }
    func gameDidEnd(_ game: DiceGame) {
        if playerScore1 == playerScore2 {
            print("The game ended in a draw.")
        } else if playerScore1 > playerScore2 {
            print("Player 1 won!")
        } else {
            print("Player 2 won!")
        }
    }
}

let tracker = DiceGameTracker()
let game = DiceGame(sides: 6)
game.delegate = tracker
game.play(rounds: 3)
// Started a new game
// Player 2 won round 1
// Player 2 won round 2
// Player 1 won round 3
// Player 2 won!


// MARK: Extensions를 통해 이미 존재하는 타입이 특정 프로토콜을 따르도록 하기
protocol TextRepresentable {
    var textualDescription: String { get }
}

extension Int: TextRepresentable {
    var textualDescription: String {
        "the integer \(self)"
    }
}

extension Double: TextRepresentable {
    var textualDescription: String {
        "the double \(self)"
    }
}

print(3.textualDescription)
print(3.14.textualDescription)


// MARK: 조건부로 프로토콜을 따르도록 하기
extension Array: TextRepresentable where Element: TextRepresentable {
    var textualDescription: String {
        self.map {
            $0.textualDescription
        }.joined(separator: ", ")
    }
}
let arr: [Int] = [1, 2, 3, 4, 5, 6, 7, 8]
print(arr.textualDescription)


// MARK: 사후적으로 특정 프로토콜을 채용
struct Hamster {
    var name: String
    var textualDescription: String { // 이미 프로토콜을 만족시키고 있으나, 명시하고 있지는 않다
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable {} // extension 키워드를 이용해 명시해준다


// MARK: 프로토콜 확장
extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}


// MARK: 프로토콜 상속
protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}


// MARK: 기본 구현체 제공
extension PrettyTextRepresentable  {
    var prettyTextualDescription: String {
        return textualDescription
    }
}
