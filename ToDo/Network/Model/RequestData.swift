//
//  RequestData.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/10.
//

import Foundation

struct RequestData:Codable{
    var email:String
    var code:String
}

struct RegisterRequestData:Codable{
    var email:String
    var nickname:String
    var password:String
}


