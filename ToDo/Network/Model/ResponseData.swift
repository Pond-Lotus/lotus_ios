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
    let token:String?
    let nickname:String?
    let email:String?
    let image:String?
}

struct TodoWriteResponseData:Codable{
    let resultCode:Int
    let data:TodoResonseData
}

struct TodoSearchResponseData:Codable{
    let resultCode:Int
    let data:[TodoResonseData]
}

struct TodoResonseData:Codable{
    let title:String
    let year:Int
    let month:Int
    let day:Int
    let writer:String
    let done:Bool
    let color:Int
    let time:String
    let description:String
    let id:Int
}
struct TodoEditResponseData:Codable{
    let resultCode:Int
    let data : TodoEditResonseDataList
}

struct TodoEditResonseDataList:Codable{
    let title:String
    let year:Int
    let month:Int
    let day:Int
    let done:Bool
    let color:Int
    let time:String
    let description:String
    let id:Int
}

struct EditImageAndNicknameResonseData:Codable{
    let resultCode:Int
    let data : ImageAndNickname
}
struct ImageAndNickname:Codable{
    let nickname:String
    let image:String
}

struct PriorityResponseData:Codable{
    let resultCode:Int
    let data:String
}

struct SearchColorArrayResponseData:Codable{
    let resultCode:Int
    let data:[ColorNumberPair]
}

struct ColorNumberPair:Codable{
    let num:[Int]
}
    
