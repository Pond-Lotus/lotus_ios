//
//  NewwokResult.swift
//  ToDo
//
//  Created by KDS on 2023/01/17.
//

enum NetworkResult<T> {
    case success(T) // 서버 통신 성공
    case requestErr(T) //요청 에러가 발생
    case pathErr // 경로 에러
    case serverErr //서버의 내부 에러
    case networkFail //네트워크 연결실패
    case decodeErr
}
