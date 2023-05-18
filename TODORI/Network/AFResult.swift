//
//  AFResult.swift
//  TODORI
//
//  Created by 제임스 on 2023/05/14.
//

import Foundation

enum AFResult<T> {
    case success(T)
    case failure(T)
}
