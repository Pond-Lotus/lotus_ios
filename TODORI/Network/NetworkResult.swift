//
//  NetworkResult.swift
//  TODORI
//
//  Created by 제임스 on 2023/05/01.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case failure(Error)
}

enum AFResult<T> {
    case success(T)
    case failure(T)
}
