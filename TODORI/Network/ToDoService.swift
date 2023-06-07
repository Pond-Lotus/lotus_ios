//
//  ToDoService.swift
//  TODORI
//
//  Created by Dasol on 2023/05/25.
//

import UIKit
import Alamofire

class TodoService {
    
    static let shared = TodoService()
    
    private init() {}
    
    func inquireGroupName(completion: @escaping(NetworkResult<Any>) -> Void) {
        let url = APIConstant.ToDo.groupName
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        let headers: HTTPHeaders = ["Authorization" : "Token " + token]
        
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: ToDoResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공적으로 디코딩된 응답을 처리하는 코드
                    if response.resultCode == 200 {
                        // 로그인 성공
                        print("투두 조회 성공 in UserService")
                        completion(.success(response))
                    } else {
                        // 로그인 실패
                        print("투두 조회 실패 in UserService")
                        let error = NSError(domain: "TODORI", code: response.resultCode, userInfo: nil)
                        completion(.failure(error))
                    }
                case .failure(let error):
                    // 요청 실패 또는 디코딩 오류 처리 코드
                    print("에러: \(error)")
                    completion(.failure(error))
                }
            }
    }

    func editGroupName(first: String, second: String, third: String, fourth: String, fifth: String, sixth: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        let url = APIConstant.ToDo.groupName
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        let headers: HTTPHeaders = ["Authorization" : "Token " + token]
        let parameters: [String: Any] = [
            "priority": [
                "1": first,
                "2": second,
                "3": third,
                "4": fourth,
                "5": fifth,
                "6": sixth
            ]
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공적으로 디코딩된 응답을 처리하는 코드
                    if response.resultCode == 200 {
                        // 로그인 성공
                        print("투두 수정 성공 in UserService")
                        completion(.success(response))
                    } else {
                        // 로그인 실패
                        print("투두 수정 실패 in UserService")
                        let error = NSError(domain: "TODORI", code: response.resultCode, userInfo: nil)
                        completion(.failure(error))
                    }
                case .failure(let error):
                    // 요청 실패 또는 디코딩 오류 처리 코드
                    print("에러: \(error)")
                    completion(.failure(error))
                }
            }
    }
}
