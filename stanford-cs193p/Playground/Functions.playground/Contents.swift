// MARK: - Functions

// MARK: Default Parameter Values
func add(_ target: Int, by addBy: Int = 1) -> Int {
    return target + addBy
}
print(add(1, by: 5))
print(add(1))

// MARK: Variadic Parameters
// 가변 길이 인자
func calcMean(_ numbers: Double...) -> Double {
    var sum: Double = 0.0
    for number in numbers {
        sum += number
    }
    return sum / Double(numbers.count)
}
print(calcMean(1, 2, 3, 4, 5, 6, 7, 8, 9, 10))
print(calcMean(2.3, 5.3, 6.3, 8.1, 9.4))

// MARK: In-Out Parameters
/**
 매커니즘 (copy-in copy-out 방식)
 https://docs.swift.org/swift-book/documentation/the-swift-programming-language/declarations#In-Out-Parameters
 
 1. 함수 호출 시, inout으로 넘겨진 인자가 복사되어 전달된다.
 2. 함수 내에서 해당 인자의 복사본이 수정된다.
 3. 함수가 리턴되면 복사본이 원본에 할당된다.
 
 실제로는 최적화를 거치면서, 수정 작업이 있기 전까지는 원본 데이터의 메모리 주소를
 함수 안에서도 참조한다.
 어찌되었든 문서에서는 copy-in copy-out으로 생각하고 짜면 된다고 한다.
 */
// 사족: 다 짜고 나서 드는 생각이지만, 아래 예제는 좋은 구현 사례는 아닌 것 같다...
struct Menu {
    var title: String
    var price: Int
    var desc: String
    var isSet: Bool = false
    var additionalSet: [Menu] = []
}

func makeDoubleSet(_ menu1: inout Menu, _ menu2: inout Menu, discount discountPercent: Double, title customTitle: String? = nil) -> Menu {
    let customTitle = customTitle ?? "\(menu1.title) + \(menu2.title) 더블 세트"
    let setMenu = Menu(
        title: customTitle,
        price: (Int)((Double)(menu1.price + menu2.price) * (1.0 - discountPercent / 100)),
        desc: "[\(discountPercent)% 할인] \(menu1.title) + \(menu2.title) 더블 세트",
        isSet: true,
        additionalSet: []
    )
    
    menu1.additionalSet.append(setMenu)
    menu2.additionalSet.append(setMenu)
    
    return setMenu
}

var burger = Menu(title: "빅버거", price: 6500, desc: "아주 큰 빅버거")
var chips = Menu(title: "빅포테이토", price: 3000, desc: "아주 큰 빅포테이토")
dump(burger)
dump(chips)

print("======== SET ========")
let set = makeDoubleSet(&burger, &chips, discount: 20)
dump(set)
dump(burger)
dump(chips)

