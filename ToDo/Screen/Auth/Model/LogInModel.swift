//
//  LogInModel.swift
//  ToDo
//
//  Created by KDS on 2023/01/17.
//

import Foundation

struct LoginResponse: Codable {
    let resultCode: Int
    let token: String
//    let non_field_errors: String
//    let data: LoginData?
}

//struct LoginData: Codable {
//    let name: String
//    let email: String
//}
