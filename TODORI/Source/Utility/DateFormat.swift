//
//  DateFormat.swift
//  TODORI
//
//  Created by Dasol on 2023/05/31.
//

import UIKit

class DateFormat{
    static let shared = DateFormat()
    
    var dateFormatter = DateFormatter()

    func getdateLabelString(date:Date) -> String{
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "yyyy.MM"
        return dateFormatter.string(from: date)
    }
    
    func getWeekdayInKorean(date:Date) -> String{
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "E요일"
        return dateFormatter.string(from: date)
    }
    
    func getDay(date:Date) -> String{
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: date)
    }
    
    func getYearMonthDay(date:Date) -> [String] {
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "yyyy MM dd"
        let arr = dateFormatter.string(from: date).components(separatedBy: " ")
        return arr
    }
    
    func getYearMonthDayAndWeekday(date:Date) -> String {
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "MM월 dd E요일"
        let date = dateFormatter.string(from: date)
        return date
    }
    
    func isWeekend(date:Date) -> Bool{
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "E"
        let weekday = dateFormatter.string(from: date)
        if weekday == "Sat" || weekday == "Sun"{
            return true
        }else{
            return false
        }
    }
    
    func getHour(date:Date) -> String{
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "HH"
        let date = dateFormatter.string(from: date)
        return date
    }
    
    func getMinute(date:Date) -> String{
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "mm"
        let date = dateFormatter.string(from: date)
        return date    }
}
