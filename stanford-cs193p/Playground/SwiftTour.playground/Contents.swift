import Swift
import Foundation

var greeting = "Hello, playground"

// MARK: - Protocols and Extensions
/**
 Protocol을 정의하려면 `protocol` 키워드를 사용한다.
 이미 존재하는 타입에 기능을 추가하려면 `extension` 키워드를 사용한다. 기존 타입에 새로운 메서드나 Computed Property를 추가할 수 있다.
 */

// MARK: Protocols

protocol DescriptableEntry {
    var id: UUID { get } // 적어도 get이 가능해야 한다 (let 또는 var)
    var description: String { get set } // get과 set이 모두 가능해야 한다 (let 불가능)
    mutating func adjust(to: String) -> Void
    func getDesc() -> String
}

class SimpleClass: DescriptableEntry {
    let id: UUID
    var description: String
    
    init(id: UUID, description: String) {
        self.id = id
        self.description = description
    }
    
    
    func adjust(to newDescription: String) {
        self.description = newDescription
    }
    
    func getDesc() -> String {
        return self.description
    }
}

struct SimpleProduct: DescriptableEntry {
    let id: UUID
    var description: String
    var title: String
    var price: UInt
    
    mutating func adjust(to newDescription: String) {
        self.description = newDescription
    }
    
    func getDesc() -> String {
        return self.description
    }
}

var instance = SimpleClass(id: UUID(), description: "테스트")
dump(instance)
print(instance.getDesc())

var product = SimpleProduct(id: UUID(), description: "멋진 가방", title: "가방", price: 50000)
dump(product)
print(product.getDesc())

struct SimpleBuilding: DescriptableEntry {
    let id: UUID
    var description: String
    var title: String
    var location: String
    
    mutating func adjust(to newDescription: String) {
        self.description = newDescription
    }
    
    func getDesc() -> String {
        return self.description
    }
}

var building = SimpleBuilding(id: UUID(), description: "높은 빌딩", title: "하이루빌딩", location: "서울시 마포구")

let descriptableEntries: [DescriptableEntry] = [product, building]
for i in descriptableEntries {
    print(i.getDesc())
}

// MARK: Extensions

protocol DescriptableReadOnlyEntry {
    associatedtype T
    var description: String { get }
    mutating func adjust(to: T) -> Void
    func getDesc() -> String
}

extension Int: DescriptableReadOnlyEntry {
    typealias T = Int
    
    public var description: String {
        "The number \(self)"
    }
    
    mutating func adjust(to: Int) {
        self = to
    }
    
    func getDesc() -> String {
        return self.description
    }
}

var sampleInteger = 256
print(sampleInteger)
sampleInteger.adjust(to: 128)
print(sampleInteger)
print(sampleInteger.getDesc())

// MARK: Experiment
extension Double {
    var absoluteValue: Double {
        abs(self)
    }
}

let sampleDouble = -64.0
print("Original Value=\(sampleDouble) Absolute Value=\(sampleDouble.absoluteValue)")

