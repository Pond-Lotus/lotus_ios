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
        static let findPassword = baseURL + "/account/findpw/"
        static let editProfile = baseURL + "/account/edit1/"
        static let changePassword = baseURL + "/account/edit2/"
        
        static let withdrawal = baseURL + "/account/withdrawal/"
    }
    
    enum ToDo {
        static let groupName = baseURL + "/todo/name/priority/"
    }
}
