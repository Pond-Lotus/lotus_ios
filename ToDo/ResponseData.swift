//
//  ResponseData.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/09.
//

import Foundation

struct ResponseData : Codable{
    let resultCode:Int
}

struct RegisterResponseData : Codable{
    let account:Account
    let resultCode:Int
}

struct Account:Codable{
    let nickname:String
    let email:String
}
