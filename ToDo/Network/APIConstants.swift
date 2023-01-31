//
//  APIConstants.swift
//  ToDo
//
//  Created by KDS on 2023/01/17.
//

import Foundation

struct APIConstants {
    
    static let baseURL = "https://plotustodo-ctzhc.run.goorm.io"
    
    static let emailCodeURL = baseURL + "/account/emailcode/" // query문에선 / 없어도 됨
    static let signUpURL = baseURL + "/account/register/"
    static let logInURL = baseURL + "/account/login/"
    
    static let toDoURL = baseURL + "/todo/todo/"
    
    static let editprofileURL = baseURL + "/account/edit"
}

enum API: Int {
    case add
    case edit
    case inquire
    case delete
}
