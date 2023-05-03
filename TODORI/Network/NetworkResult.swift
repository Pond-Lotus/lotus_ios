//
//  NetworkResult.swift
//  TODORI
//
//  Created by Dasol on 2023/05/02.
//

enum NetworkResult<T> {
    case success(T) // 서버 통신 성공
    case requestErr(T) //요청 에러가 발생
    case pathErr // 경로 에러
    case serverErr //서버의 내부 에러
    case networkFail
    case decodeErr
}
