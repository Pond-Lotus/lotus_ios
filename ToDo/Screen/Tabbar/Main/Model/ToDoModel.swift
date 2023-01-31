//
//  ToDoModel.swift
//  ToDo
//
//  Created by KDS on 2023/01/24.
//

import Foundation

// MARK: - ToDoResponse
struct ToDoResponse: Codable {
    let resultCode: Int
    let data: ToDoData
}

// MARK: - ToDoData
struct ToDoData: Codable {
    let title: String
    let year, month, day, id: Int // 응답 오는 순서 상관 없이 잘 들어간다!
    let writer: String
    let done: Bool
}

struct ToDoListResponse: Codable {
    let resultCode: Int
    let data: [ToDoListData]
}

struct ToDoListData: Codable {
    let id: Int
    let title: String
    let year, month, day: Int
    let done: Bool
    let writer: String
}

struct EditToDoResponse: Codable {
    let resultCode: Int
    let data: EditToDoData
}

struct EditToDoData: Codable {
    let title: String
    let year, month, day, color: Int
    let description, time: String
    let id: Int
    let done: Bool
}

struct DeleteToDoResponse: Codable {
    let resultCode: Int
}
