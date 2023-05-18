//
//  DateFormat.swift
//  TODORI
//
//  Created by 제임스 on 2023/04/24.
//

import Foundation
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
        dateFormatter.dateFormat = "MM"
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
    
}


