//
//  CalendarView.swift
//  SwiftUIPractice
//
//  Created by 임영택 on 5/26/25.
//

import SwiftUI

struct CalendarView: View {
    @State var currentYearMonth: Date
    @State var calendarOffset: CGFloat = 0
    
    private var yearInKorean: String {
        let component = Calendar.current.component(.year, from: currentYearMonth)
        return "\(component)년"
    }
    
    private var monthInKorean: String {
        let component = Calendar.current.component(.month, from: currentYearMonth)
        return "\(component)월"
    }
    
    var body: some View {
        VStack {
            Text("\(yearInKorean) \(monthInKorean)")
            HeaderView()
            DaysView(currentYearMonth: currentYearMonth)
        }
        .background(.clear)
        .offset(.init(width: calendarOffset, height: 0))
        .gesture(DragGesture()
            .onChanged { gesture in
                calendarOffset = gesture.translation.width
            }
            .onEnded({ gesture in
                calendarOffset = 0
                let translationWidth: CGFloat = gesture.translation.width
                
                if translationWidth < -150 {
                    print("next")
                    changeMonth(by: 1)
                }
                
                if translationWidth > 150 {
                    print("prev")
                    changeMonth(by: -1)
                }
            }))
    }
    
    private func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentYearMonth) {
            self.currentYearMonth = newMonth
        }
    }
}

struct HeaderView: View {
    var body: some View {
        HStack {
            Text("월")
                .frame(maxWidth: .infinity)
            Text("화")
                .frame(maxWidth: .infinity)
            Text("수")
                .frame(maxWidth: .infinity)
            Text("목")
                .frame(maxWidth: .infinity)
            Text("금")
                .frame(maxWidth: .infinity)
            Text("토")
                .frame(maxWidth: .infinity)
            Text("일")
                .frame(maxWidth: .infinity)
            
        }
    }
}

struct DaysView: View {
    var currentYearMonth: Date
    
    var body: some View {
        let daysInMonth: Int = numberOfDays(in: currentYearMonth)
        let firstWeekday: Int = firstWeekdayOfMonth(in: currentYearMonth) - 1
        
        return VStack {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                ForEach(0 ..< daysInMonth + firstWeekday, id: \.self) { index in
                    if index < firstWeekday {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.clear)
                    } else {
                        let date = getDate(for: index - firstWeekday)
                        let day = index - firstWeekday + 1
                        
                        Text("\(day)")
                            .onTapGesture {
                                print(date)
                            }
                    }
                }
            }
        }
    }
}

extension DaysView {
    private func getDate(for day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: startOfMonth())!
    }
    
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: currentYearMonth)
        return Calendar.current.date(from: components)!
    }
    
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        let firstWeekDayAsGregorian = Calendar.current.component(.weekday, from: firstDayOfMonth)
        let firstWeekDay = firstWeekDayAsGregorian - 1 > 0 ? firstWeekDayAsGregorian - 1 : 7
        
        return firstWeekDay // 1==월
    }
}

#Preview {
    CalendarView(currentYearMonth: Date())
}
