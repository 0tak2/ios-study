import SwiftUI
import PlaygroundSupport

// MARK: - 여러 줄
let multilineString: String = """
    이것은 여러 줄의 스트링입니다.
    제 앞의 4글자는 무시됩니다.
        다만 이렇게 중간에 추가로 들여쓰면 들여쓰기가 표시됩니다.
    봐주셔서 감사합니다.
    """
print(multilineString)

// MARK: - 이스케이핑 및 유니코드
let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
// "Imagination is more important than knowledge" - Einstein
let dollarSign = "\u{24}"        // $,  Unicode scalar U+0024
let blackHeart = "\u{2665}"      // ♥,  Unicode scalar U+2665
let sparklingHeart = "\u{1F496}" // 💖, Unicode scalar U+1F496
// 유니코드를 입력하려면 \u{HEX}로 입력한다.

// MARK: - 빈 스트링
let empty1: String = ""
let empty2: String = String()
print("empty1.isEmpty: \(empty1.isEmpty)")
print("empty2.isEmpty: \(empty2.isEmpty)")
print("empty1 == empty2: \(empty1 == empty2)")

// MARK: - 스트링의 가변성
var mutable: String = "이 문자열은 변경할 수 있습니다. "
mutable += "정말로요...!"
mutable.append("!!!")

let imutable: String = "이 문자열은 변경할 수 없습니다. "
// imutable += "변경하려고 하면 컴파일 에러가 발생해요."
// imutable.append("당연히 이렇게도 안됩니다.") // append는 mutating 함수이기 때문에 let 상수에는 사용 불가

// MARK: - 스트링도 값 타입이다

// MARK: - 문자 다루기
// for - in 구문을 사용할 수 있다.
for character in "Dog!🐶" {
    print(character)
}

// 직접 Character 변수, 상수를 선언할 떄에는 타입을 명시한다. 리터럴로는 스트링과 동일하게, ""안에 표시한다.
let exclamationMark: Character = "!"

// 문자 배열로 스트링을 만들 수 있다.
let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
let catString = String(catCharacters)
print(catString)

// append를 이용하면 스트링에 문자를 바로 연결할 수 있다.
var greeting: String = "안녕하세요"
greeting.append(exclamationMark)
print(greeting)
greeting.append("!!!!!!")
print(greeting)

// MARK: - 문자 수 세기
// count 프로퍼티를 이용할 수
struct SimpleContentView: View {
    @State var contents: String = "여기에 아무 내용이나 입력해보세요..."
    
    var body: some View {
        VStack {
            Text("length: \(contents.count)")
                .font(.footnote)
            
            TextEditor(
                text: $contents
            )
            .frame(width: 300, height: 250)
            .border(.primary)
            .fontWeight(.bold)
            .padding()
        }
        .padding()
    }
}
SimpleContentView()
// PlaygroundPage.current.setLiveView(SimpleContentView())

// MARK: - 스트링의 인덱스
// Swift에서는 문자마다 메모리 할당량이 다르기 때문에 (유니코드, 아스키, ...)
// 다른 언어처럼 정수 인덱스를 지원하지 않는다.
var str: String = "안녕하세요, 테스트입니다. Hello, Swift!"
// str[0] // 'subscript(_:)' is unavailable: cannot subscript String with an Int, use a String.Index instead.

// 대신 첨자로 String.Index 값을 쓸 수 있다.
str[str.startIndex]
dump(str.startIndex) // _rawBits: 15
// String#startIndex // 시작 인덱스
// String#endIndex // 종료 인덱스

// 이전, 이후 인덱스를 구하려면
let lastSecondIndex: String.Index = str.index(before: str.endIndex)
print(str[lastSecondIndex]) // !
let secondIndex: String.Index = str.index(after: str.startIndex)
print(str[secondIndex]) // 녕
// 원하는 문자를 지정하려면
let thirdCharacter: Character = str[str.index(str.startIndex, offsetBy: 2)]
print(thirdCharacter)
// 인덱스 배열
for idx in str.indices {
    // dump(idx)
    print(str[idx], terminator: " | ")
}
print()

// 뒤집어보기
//var reversedStr: String = ""
//for el in str.reversed() {
//    reversedStr += String(el)
//}
let reversedStr = String(str.reversed())
print(reversedStr)

// 삽입, 삭제
str.insert("!", at: str.endIndex) // 안녕하세요, 테스트입니다. Hello, Swift!!
print(str)
str.remove(at: str.index(str.startIndex, offsetBy: 5)) // 안녕하세요 테스트입니다. Hello, Swift!!
print(str)
str.insert(";", at: str.index(str.startIndex, offsetBy: 5)) // 안녕하세요; 테스트입니다. Hello, Swift!!
print(str)
let helloSwiftRange: Range<String.Index> = str.index(str.startIndex, offsetBy: 15)..<str.endIndex
str.removeSubrange(helloSwiftRange) // 안녕하세요; 테스트입니다.
print(str)

// Substring
let str2: String = "실버불렛은, 없다."
let phrase: Substring = str2[..<(str2.firstIndex(of: ",") ?? str2.endIndex)]
print(phrase)
//  The difference between strings and substrings is that, as a performance optimization, a substring can reuse part of the memory that’s used to store the original string, or part of the memory that’s used to store another substring.

// 동등성
let quotation = "We're a lot alike, you and I."
let sameQuotation = "We're a lot alike, you and I."
if quotation == sameQuotation {
    print("These two strings are considered equal")
}
// "These two strings are considered equal"

// 전방일치, 후방일치
let passedCourses: [String] = [
    "전필 미술사입문",
    "전필 예술학입문",
    "전필 미학입문",
    "전필 미술사방법론",
    "전선 동양고대미술사",
    "전선 공예디자인사",
    "교선 한국역사의이해",
    "교필 디지털디자인",
]

var majorRequireCount: Int = 0
var majorOptionalCount: Int = 0
var majorFoundationCount: Int = 0
var liberalArtsRequireCount: Int = 0
var liberalArtsOptionalCount: Int = 0
var sum: Int = 0

for course in passedCourses {
    sum += 1
    if course.hasPrefix("전필") {
        majorRequireCount += 1
    }
    
    if course.hasPrefix("전선") {
        majorOptionalCount += 1
    }
    
    if course.hasPrefix("교필") {
        liberalArtsRequireCount += 1
    }
    
    if course.hasPrefix("교선") {
        liberalArtsOptionalCount += 1
    }
    
    if course.hasSuffix("입문") {
        majorFoundationCount += 1
    }
}

print("""
  [이수과목 통계]
  
    * 전공필수: \(majorRequireCount)
      * 전공기초: \(majorFoundationCount)
    * 전공선택: \(majorOptionalCount)
  
    * 교양필수: \(liberalArtsRequireCount)
    * 교양선택: \(liberalArtsOptionalCount)
  
  계: \(sum)
  """)
