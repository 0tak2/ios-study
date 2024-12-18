//
//  Data+Today.swift
//  Today
//
//  Created by 임영택 on 12/18/24.
//

import Foundation

extension Date {
    var dayAndTimeText: String {
        let timeText = formatted(date: .omitted, time: .shortened)
        
        if Locale.current.calendar.isDateInToday(self) { // Date가 오늘인 경우
            let timeFormat = NSLocalizedString("오늘 %@", comment: "오늘인 경우 포맷스트링")
            return String(format: timeFormat, timeText)
        } else {
            // let dateText = formatted(.dateTime.month(.abbreviated).day())
            let dateText = formatted(.dateTime.month(.abbreviated).day().locale(Locale(identifier: "ko_KR")))
            let dateAndtimeFormat = NSLocalizedString("%@ %@", comment: "일시 포맷스트링")
            return String(format: dateAndtimeFormat, dateText, timeText)
        }
    }
    
    var dayText: String {
        if Locale.current.calendar.isDateInToday(self) { // Date가 오늘인 경우
            return NSLocalizedString("오늘", comment: "기한이 오늘인 경우 설명")
        } else {
            // return formatted(.dateTime.month().day().weekday(.wide))
            return formatted(.dateTime.month().day().weekday(.wide).locale(Locale(identifier: "ko_KR")))
        }
    }
}
