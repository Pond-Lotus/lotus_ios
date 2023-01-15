//
//  NetworkResult.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/15.
//

import Foundation

//네트워크 결과를 나누기 위해 enum 형으로 선언
//서버 통신 결과 처리를 위한 파일
//<T> -> 모든 타입 가능
//스위치 문에서 용이하게 사용하기 위한 정의
enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}
