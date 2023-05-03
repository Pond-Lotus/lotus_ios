//
//  APIConstant.swift
//  TODORI
//
//  Created by Dasol on 2023/05/01.
//

import Foundation

enum APIConstant {
    static let baseURL = "https://plotustodo-ctzhc.run.goorm.io"
    
    enum Account {
        static let emailCode = baseURL + "/account/emailcode/"
        static let login = baseURL + "/account/login/"
        static let logout = baseURL + "/account/logout/"
        static let register = baseURL + "/account/register/"
    }
    
}
