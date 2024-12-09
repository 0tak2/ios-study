import Swift

// MARK: - Basic Operators
// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/basicoperators

// MARK: - Range Operators
let students: [String] = ["홍길동", "이순신", "맹꽁이", "황진이", "박혁거세", "정도전", "김홍도", "정선", "강세황", "동기창"]

for i in 0...4 { // 닫힌 범위
    print("Student #\(i+1)의 이름: \(students[i])")
}

for i in 5..<7 { // 반개방 범위
    print("Student #\(i+1)의 이름: \(students[i])")
}

print("그리고...")
for name in students[7...] { // 단방향 범위
    print(name)
}

// Subscript
// Swift에서는 콜렉션 타입의 멤버를 참조하기 위해 사용하는 인덱스나 키 따위를 첨자(Subscript)라고 표현한다. see: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/subscripts
// 다음과 같이 배열의 subscript로는 범위를 사용할 수 있다. see: https://developer.apple.com/documentation/swift/array/subscript(_:)-53fvb
print(students[2...4])

// MARK: - Nil-Coalescing Operator
// Nil 결합 연산자 또는 Nil 병합 연산자
func getOptionalNumber() -> Int? {
    if let emptyOrNot = [true, false].randomElement(), !emptyOrNot {
        return Int.random(in: Int.min...Int.max)
    }
    return nil
}

let optinalNumber: Int? = getOptionalNumber()
let realNumber: Int = optinalNumber ?? 0
print(optinalNumber ?? "nil")
print(realNumber)

// 다음 두 표현은 동일하게 동작한다
// a ?? b
// a != nil ? a! : b
