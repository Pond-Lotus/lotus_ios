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
    
    
}


