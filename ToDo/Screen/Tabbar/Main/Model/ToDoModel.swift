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
    let year, month, day: Int
    let writer: String
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

struct DeleteToDoResponse: Codable {
    let detail: String
}
