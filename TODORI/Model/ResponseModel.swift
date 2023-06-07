//
//  ResponseModel.swift
//  TODORI
//
//  Created by Dasol on 2023/05/24.
//

import Foundation

struct LoginResponse: Decodable {
    let resultCode: Int
    let token: String?
    let nickname: String?
    let email: String?
    let image: String?
}

struct CheckTokenResponse: Decodable {
    let resultCode: Int
}

struct ToDoResponse: Decodable {
    let resultCode: Int
    let data: [String: String]
}


