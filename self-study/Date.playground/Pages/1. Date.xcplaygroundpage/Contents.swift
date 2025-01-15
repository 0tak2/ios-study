//: [Previous](@previous)

import Foundation

/**
 Date는 시간 상의 어떠한 특정 지점을 가리킨다. 특정 시스템이나 지역과는 상관 없는, 절대적 의미의 시각이다.
 */

// MARK: - 선언
print(Date())
print(Date.now)
print(Date(timeIntervalSince1970: 1736930232))

// MARK: - 비교
print(Date.now < Date.distantFuture) // true
print(Date.now == Date()) // true
print(Date.distantPast > Date.distantFuture) // false

let compareResult1: ComparisonResult = Date.now.compare(Date())
print(compareResult1.rawValue) // 0
let compareResult2: ComparisonResult = Date.now.compare(Date.distantFuture)
print(compareResult2.rawValue) // -1
let compareResult3: ComparisonResult = Date.now.compare(Date.distantPast)
print(compareResult3.rawValue) // 1
/*
 @frozen public enum ComparisonResult : Int, @unchecked Sendable {
     case orderedAscending = -1
     case orderedSame = 0
     case orderedDescending = 1
 }
 */

// MARK: - 계산
// MARK: Date와 Date
var addedDate = Date.now.addingTimeInterval(12345)
let distance1: TimeInterval = Date.now.distance(to: addedDate) // public typealias TimeInterval = Double
print(distance1) // 12344.999601006508; A TimeInterval value is always specified in seconds

// MARK: TimeInterval과 TimeInterval
let date1 = Date()
DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    let date2 = Date()
    let intervalDiff = date2.timeIntervalSince1970 - date1.timeIntervalSince1970
    print("intervalDiff \(intervalDiff)") // 5.249634742736816
}

// MARK: Date와 TimeInterval
addedDate.addTimeInterval(-12345) // mutate
let distance2: TimeInterval = Date.now.distance(to: addedDate)
print(distance2) // -0.0004349946975708008

addedDate += 20.0 // Date +/- TimeInterval
print("current \(Date.now) addedDate \(addedDate)")

// MARK: - 간단한 포매팅
let current = Date.now
print(current.formatted()) // 14/01/2025, 10:27 PM
print(current.formatted(date: .complete, time: .omitted)) // Tuesday, 14 January 2025
print(current.formatted(date: .omitted, time: .complete)) // 10:27:59 PM GMT+9
print(current.formatted(date: .numeric, time: .standard)) // 14/01/2025, 10:29:11 PM
// Date.FormatStyle을 넘겨 더 자세하게 세팅할 수도 있다 see: https://developer.apple.com/documentation/foundation/date/formatstyle
// 아래 DateFormatter 예제 코드 참고

// MARK: - 범위
let range: ClosedRange<Date> = current...current + 10
print(range)
print(range.contains(current + 5)) // true
print(range.contains(current + 20)) // false

//: [Next](@next)
