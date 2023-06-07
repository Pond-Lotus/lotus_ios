//
//  APIConstant.swift
//  TODORI
//
//  Created by Dasol on 2023/05/01.
//

import Foundation

enum APIConstant {
    
    static let baseURL = "http://34.22.73.14:8000"
    
    enum Account {
        static let emailCode = baseURL + "/account/emailcode/"
        static let login = baseURL + "/account/login/"
        static let logout = baseURL + "/account/logout/"
        static let register = baseURL + "/account/register/"
        static let findPassword = baseURL + "/account/findpw/"
        static let editProfile = baseURL + "/account/edit1/"
        static let changePassword = baseURL + "/account/edit2/"
        static let withdrawal = baseURL + "/account/withdrawal/"
        static let checkToken = baseURL + "/account/cktoken/"
    }
    
    enum ToDo {
        static let groupName = baseURL + "/todo/name/priority/"
    }
}
