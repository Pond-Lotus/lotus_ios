//
//  APIConstants.swift
//  ToDo
//
//  Created by KDS on 2023/01/17.
//

import Foundation

struct APIConstants {
    
    static let baseURL = "https://plotustodo-ctzhc.run.goorm.io"
    
    static let emailCodeURL = baseURL + "/account/emailcode/" // query문에선 ㄱㅊ
    static let signUpURL = baseURL + "/account/register/"
    static let logInURL = baseURL + "/account/login/"
    
    static let toDoURL = baseURL + "/todo/todo/"
}
