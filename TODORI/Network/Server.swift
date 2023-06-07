//
//  Server.swift
//  TODORI
//
//  Created by 제임스 on 2023/05/01.
//

import Foundation

struct Server{
    static let serverURL:String = "http://34.22.73.14:8000"
    static let getEmailCode:String = "/account/emailcode/"
    static let postEmailCode:String = "/account/emailcode/"
    static let register:String = "/account/register/"
    static let login:String = "/account/login/"
    static let todo:String = "/todo/todo/"
    static let editProfile = "/account/edit1/"
    static let priority = "/todo/color/priority/"
    static let getColor = "/todo/color/"
    static let editPassword = "/account/edit2/"
    static let category = "/todo/name/priority/"
    static let who = "/account/who/"
}
