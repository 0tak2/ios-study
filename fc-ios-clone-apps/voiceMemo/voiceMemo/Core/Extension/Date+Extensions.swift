//
//  Date+Extensions.swift
//  voiceMemo
//

import Foundation

extension Date {
  var formattedTime: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "a hh:mm"
    return formatter.string(from: self)
  }
  
  var formattedDate: String {
    let now = Date()
    let calendar = Calendar.current
    
    let startTimeOfCurrentDate = calendar.startOfDay(for: now)
    let startTimeOfSelf = calendar.startOfDay(for: self)
    let numOfDaysDifference = calendar.dateComponents([.day], from: startTimeOfCurrentDate, to: startTimeOfSelf).day
    
    if let numOfDaysDifference = numOfDaysDifference {
      if numOfDaysDifference == 0 {
        return "오늘"
      }
      
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "ko_KR")
      formatter.dateFormat = "M월 d일 E요일"
      return formatter.string(from: self)
    }
    
    return "" // Never reached
  }
}
