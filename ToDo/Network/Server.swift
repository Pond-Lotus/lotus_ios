//
//  ServerURL.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/14.
//

import Foundation

struct Server{
    static let serverURL:String = "https://plotustodo-ctzhc.run.goorm.io"
    static let getEmailCode:String = "/account/emailcode/"
    static let postEmailCode:String = "/account/emailcode/"
    static let register:String = "/account/register/"
    static let login:String = "/account/login/"
    static let todo:String = "/todo/todo/"
    static let profileEdit1 = "/account/edit1/"
    static let priority = "/todo/color/priority/"
    static let getColor = "/todo/color/"
}
