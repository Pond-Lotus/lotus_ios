//
//  LogInModel.swift
//  ToDo
//
//  Created by KDS on 2023/01/17.
//

import Foundation

struct SignupResponse: Codable {
    let resultCode: Int
}

struct LoginResponse: Codable {
    let resultCode: Int
    let token: String
}

struct EditProfileResponse: Codable {
    let resultCode: Int
    let data: EditProfileData
}

struct EditProfileData: Codable {
    let nickname: String
    let image: String
}
