//
//  AccountService.swift
//  TODORI
//
//  Created by Dasol on 2023/05/02.
//

import UIKit
import Alamofire

class UserService {
    
    static let shared = UserService()
    
    private init() {}
    
    func emailCheck(email: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        let url = APIConstant.Account.emailCode
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        let body: Parameters = [
            "email": email
        ]
        
        // 500일 때는?
        AF.request(url, method: .get, parameters: body, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        completion(.success(json))
                    } else {
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func codeCheck(email: String, code: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        let url = APIConstant.Account.emailCode
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json"
        ]
        let body: Parameters = [
            "email": email,
            "code": code
        ]
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        completion(.success(json))
                    } else {
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func register(nickname: String, email: String, password: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        let url = APIConstant.Account.register
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let parameters: Parameters = [
            "nickname": nickname,
            "email": email,
            "password": password
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any] {
                    completion(.success(json))
                } else {
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        let url = APIConstant.Account.login
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let parameters: Parameters = [
            "email": email,
            "password": password
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        completion(.success(json))
                    } else {
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let url = APIConstant.Account.login
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let loginResponse):
                    // 성공적으로 디코딩된 응답을 처리하는 코드
                    if loginResponse.resultCode == 200 {
                        // 로그인 성공
                        print("로그인 성공 in UserService")
                        completion(.success(loginResponse))
                    } else {
                        // 로그인 실패
                        print("로그인 실패 in UserService")
                        let error = NSError(domain: "TODORI", code: loginResponse.resultCode, userInfo: nil)
                        completion(.failure(error))
                    }
                case .failure(let error):
                    // 요청 실패 또는 디코딩 오류 처리 코드
                    print("에러: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    func checkToken(completion: @escaping (Result<CheckTokenResponse, Error>) -> Void) {
        let url = APIConstant.Account.checkToken
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        let headers: HTTPHeaders = ["Authorization" : "Token " + token]
        
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: CheckTokenResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공적으로 디코딩된 응답을 처리하는 코드
                    if response.resultCode == 200 {
                        print("토큰 검증 성공 in UserService")
                        completion(.success(response))
                    } else {
                        print("토큰 검증 실패 in UserService")
                        completion(.success(response))
                        //                        let error = NSError(domain: "TODORI", code: response.resultCode, userInfo: nil)
                        //                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("에러: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    func logout(completion: @escaping(NetworkResult<Any>) -> Void) {
        let url = APIConstant.Account.logout
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        let headers: HTTPHeaders = [
            "Authorization" : "Token " + token
        ]
        
        AF.request(url, method: .post, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        completion(.success(json))
                    } else {
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func findPassword(email: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        let url = APIConstant.Account.findPassword
        //        let headers: HTTPHeaders = ["Authorization" : "Token " + token]
        let body: Parameters = [
            "email": email
        ]
        
        AF.request(url, method: .get, parameters: body)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        completion(.success(json))
                    } else {
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func editProfile(image: UIImage, nickname: String, imdel: Bool, completion: @escaping(NetworkResult<Any>) -> Void) {
        let url = APIConstant.Account.editProfile
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        let headers: HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "Authorization" : "Token " + token
        ]
        let parameters: Parameters = [
            "image": image,
            "nickname": nickname,
            "imdel": imdel
        ]
        // 이미지를 데이터로 변환
        //        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        //            return
        //        }
        
        AF.upload(multipartFormData: { MultipartFormData in
            for (key, value) in parameters {
                MultipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            if let img = image.pngData() {
                MultipartFormData.append(img, withName: "image", fileName: "\(String(describing: nickname)).jpg", mimeType: "image/jpg")
            }
        }, to: url, method: .post, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("썽공")
                completion(.success(value))
            case .failure(let error):
                print("실빼")
                completion(.failure(error))
            }
        }
    }
    
    func changePassword(originPassword: String, newPassword: String ,completion: @escaping(NetworkResult<Any>) -> Void) {
        let url = APIConstant.Account.changePassword
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        let headers: HTTPHeaders = ["Authorization" : "Token " + token]
        let parameters: Parameters = [
            "originpw": originPassword,
            "newpw": newPassword,
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        completion(.success(json))
                    } else {
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func deleteAccount(completion: @escaping(NetworkResult<Any>) -> Void) {
        let url = APIConstant.Account.withdrawal
        guard let token = TokenManager.shared.getToken() else {
            print("No token.")
            return
        }
        let headers: HTTPHeaders = ["Authorization" : "Token " + token]
        
        AF.request(url, method: .delete, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        completion(.success(json))
                    } else {
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
