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

struct RegisterResponseData :Codable{
    let account : Account
    let resultCode : Int
}
struct Account:Codable{
    let nickname:String
    let email:String
}

struct LoginResponseData:Codable{
    let resultCode:Int
    let token:String
}

struct TodoSearchResponseData:Codable{
    let resultCode:Int
    let data:[SearchData]
}
struct SearchData:Codable{
    let id:Int
    let title:String
    let year:Int
    let month:Int
    let day:Int
    let done:Bool
    let writer:String
}
