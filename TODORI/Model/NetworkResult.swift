//
//  NetworkResult.swift
//  TODORI
//
//  Created by 제임스 on 2023/05/01.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
    case decodeErr
}
