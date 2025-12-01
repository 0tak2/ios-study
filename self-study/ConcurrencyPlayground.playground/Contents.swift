import Foundation

var greeting = "Hello, playground"

enum Test: Codable {
  case one
  case two(String)
  case three(Date)
}

actor TestActor {
  let test: Test
  
  init(test: Test) {
    self.test = test
  }
}

final class TestClass {
  var testDict: [String: String] = [:] {
    didSet {
      print("testDict updated: \(testDict)")
    }
  }
}

let tc = TestClass()
tc.testDict["key"] = "value"
tc.testDict["key2"] = "value2"
