import UIKit

var greeting = "Hello, playground"

// MARK: - Collection Types
/**
 Swift에서는 기본 컬렉션 타입으로 Arrays, Sets, Dictionaries를 지원한다. 각 타입의 저장 값(및 키)의 타입은 명확히 지정된다.
 */

// MARK: Mutability of Collections
/**
 배열, 집합, 딕셔너리를 var로 생성하면 수정 가능한 컬렉션이 된다.
 let으로 생성하면 수정이 불가능하다.
 */

var mutableArr: [String] = [
    "test data 1",
    "test data 2",
    "test data 3",
    "test data 4",
    "test data 5",
]
mutableArr.append("test data 6")

let immutableArr: [String] = [
   "constant 1",
   "constant 2",
   "constant 3",
   "constant 4",
   "constant 5",
]
// immutableArr.append("constant 6") // Cannot use mutating member on immutable value: 'immutableArr' is a 'let' constant

// MARK: - Arrays
// Type: Array<Element> or [Element]

// Empty Array
var somInts: [Int] = []

// Creating an Array with a Default Value
var threeDoubles: [Double] = Array(repeating: 0.0, count: 3)
print(threeDoubles)

// Adding two arrays
var anotherThreeDoubles: [Double] = Array(repeating: 2.5, count: 3)
var sixDoubles = threeDoubles + anotherThreeDoubles
print(sixDoubles)

// Array Literal
var shoppingList = ["Eggs", "Milk"]

// Accessing and Modifying an Array
print("The shopping list contains \(shoppingList.count) items.")
if shoppingList.isEmpty {
    print("The shopping list is empty.")
} else {
    print("The shopping list isn't empty.")
}
shoppingList[0] = "Pork"
print("First Item: \(shoppingList[0])")

shoppingList.append("Flour")
shoppingList += ["Baking Powder"]
// shoppingList now contains 4 items
shoppingList += ["Chocolate Spread", "Cheese", "Butter"]
// shoppingList now contains 7 items
shoppingList[4...6] = ["Bananas", "Apples"]
print(shoppingList)

// Iterating Over an Array
for item in shoppingList {
    print(item)
}

for (index, value) in shoppingList.enumerated() {
    print("Item \(index + 1): \(value)")
}


// MARK: - Sets
// 순서가 없고 유일한 원소들의 집합
// 각 원소는 Hashable 프로토콜을 따르는 타입이어야 한다.
// Type: Set<Element>

// Empty Set
var letters = Set<Character>()
print("letters is of type Set<Character> with \(letters.count) items.")

letters.insert("a")
print(letters)

letters = [] // empty set
print(letters)

// Array Literal
// 집합을 생성할 때에는 집합만을 위한 리터럴 표현 방법은 따로 없고, 배열 리터럴을 대신 사용한다. `(item1, item2, item3)`과 같은 표현은 튜플을 만든다.
var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"] // 타입은 추론되므로 생략 가능

// Accessing and Modifying a Set
print("I have \(favoriteGenres.count) favorite music genres.")
if favoriteGenres.isEmpty {
    print("As far as music goes, I'm not picky.")
} else {
    print("I have particular music preferences.")
}
favoriteGenres.insert("Jazz")
print(favoriteGenres) // 순서는 상관 없다

if let removedGenre = favoriteGenres.remove("Rock") { // 삭제한 뒤 삭제된 원소를 반환한다.
    print("\(removedGenre)? I'm over it.")
} else { // nil이 반환되는 경우 해당 원소가 없다는 의미이다.
    print("I never much cared for that.")
}

// Iterating Over a Set
for genre in favoriteGenres {
    print("\(genre)")
}

// Set에는 순서가 없으므로, 필요할 때에는 정렬된 배열을 반환받아 활용할 수 있다.
for genre in favoriteGenres.sorted() {
    print("\(genre)")
}

// 함수 연산
let oddDigits: Set = [1, 3, 5, 7, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]

oddDigits.union(evenDigits).sorted()
// [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
oddDigits.intersection(evenDigits).sorted()
// []
oddDigits.subtracting(singleDigitPrimeNumbers).sorted()
// [1, 9]
oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted()
// [1, 2, 9]

// 함수의 포함관계
let houseAnimals: Set = ["🐶", "🐱"]
let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
let cityAnimals: Set = ["🐦", "🐭"]

houseAnimals.isSubset(of: farmAnimals)
// true
farmAnimals.isSuperset(of: houseAnimals)
// true
farmAnimals.isDisjoint(with: cityAnimals)
// true


// MARK: - Dictionaries
// 키와 값의 쌍으로 순서 없이 저장되는 컬렉션
// 각 값은 유일한 키 하나씩에 연결되어 있고, 이 키로 식별된다.
// Type: Dictionary<Key, Value> or [Key: Value]
// Key는 집합의 원소처럼 Hashable 프로토콜을 따르는 타입이어야 한다.

// Empty Dictionary
var namesOfIntegers: [Int: String] = [:]
print(namesOfIntegers)

namesOfIntegers[16] = "sixteen"
print(namesOfIntegers)

namesOfIntegers = [:]
print(namesOfIntegers)

// Creating a Dictionary with a Dictionary Literal
var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"] // 타입은 추론되므로 생략 가능
print(airports)

// Accessing and Modifying a Dictionary
print("The airports dictionary contains \(airports.count) items.")

if airports.isEmpty {
    print("The airports dictionary is empty.")
} else {
    print("The airports dictionary isn't empty.")
}

airports["LHR"] = "London" // add new key and value
print(airports)

// 업데이트
if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
    print("The old value for DUB was \(oldValue).")
}

// 참조 - 옵셔널 바인딩
// dict[key]과 같이 값을 조회하는 경우 Optional 타입 반환
if let airportName = airports["DUB"] {
    print("The name of the airport is \(airportName).")
} else {
    print("That airport isn't in the airports dictionary.")
}

// 삭제
// - nil을 할당
airports["APL"] = "Apple International"
// "Apple International" isn't the real airport for APL, so delete it
airports["APL"] = nil
// APL has now been removed from the dictionary
// - 또는 메서드 사용
if let removedValue = airports.removeValue(forKey: "DUB") {
    print("The removed airport's name is \(removedValue).")
} else {
    print("The airports dictionary doesn't contain a value for DUB.")
}


// Iterating Over a Dictionary
// for - in 구문 사용시 기본적으로 (k, v) 튜플 반환
for (airportCode, airportName) in airports {
    print("\(airportCode): \(airportName)")
}

// key만 받거나 값만 받을 수도 있음
for airportCode in airports.keys {
    print("Airport code: \(airportCode)")
}

for airportName in airports.values {
    print("Airport name: \(airportName)")
}

// 즉, 다음과 같이 활용할 수도 있음
let airportCodes = [String](airports.keys)

let airportNames = [String](airports.values)

