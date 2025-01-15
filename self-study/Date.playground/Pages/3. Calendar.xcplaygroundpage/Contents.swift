//: [Previous](@previous)

import Foundation

/**
 Date가 시간 상의 절대적인 특정 지점을 추상화한 것이라면,
 Calendar는 다양한 지역과 시스템의 달력 상의 단위(연월일시 등)들과 Date의 관계를 정의해둔 것이다.
 
 문서 상에는 위와 같이 되어 있는데, 구체적으로
 - Date 객체로부터 연/월/일/시/분/초 등 달력 상 Unit들을 알고 싶을 때
 - Date 객체에 특정한 연/월/일/시/분/초 등 만큼 더하거나 뺴고 싶을 때
 사용하면 될 것 같다.
 */

// MARK: - 현재 캘린더
let calendar = Calendar.current // 현재 유저 캘린더를 가져온다.
print("identifier: \(calendar.identifier) / locale: \(String(describing: calendar.locale)) / timezone: \(calendar.timeZone)")

// MARK: - 달력 계산
var date = Date()
let components = calendar.dateComponents([.year, .month, .day], from: date)
let month = components.month ?? 0
let day = components.day ?? 0
print("오늘은 \(month)월 \(day)일")

let nextDayComponents = DateComponents(day: 1)
//nextDayComponents.day = 1
let nextDay = calendar.date(byAdding: nextDayComponents, to: date)!
print("다음 날: \(nextDay)")

let nextMonth = calendar.date(byAdding: .month, value: 1, to: date)! // 이런 식으로도 가능
print("다음 달: \(nextMonth)")

let nextYear = calendar.date(byAdding: .year, value: 1, to: date)!
print("다음 해: \(nextYear)")

var firstDayOfNextMonthComponents = calendar.dateComponents([.year, .month], from: date)
firstDayOfNextMonthComponents.day = 1
var lastDayOfThisMonth = calendar.date(byAdding: .day, value: -1, to: calendar.date(from: firstDayOfNextMonthComponents)!)
print("저번 달 마지막 날: \(String(describing: lastDayOfThisMonth))")

// MARK: - 특정한 날짜로 Date 생성
let certainDateComponents = DateComponents(calendar: Calendar.current, year: 2222, month: 2, day: 22, hour: 22, minute: 22) // calendar를 잘 넘겨야 date가 잘 반환된다
let certainDate = calendar.date(from: certainDateComponents)
print(String(describing: certainDate))

//: [Next](@next)
