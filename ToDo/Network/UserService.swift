//
//  UserService.swift
//  ToDo
//
//  Created by KDS on 2023/01/17.
//

import Foundation
import Alamofire

class UserService {
    
    static let shared = UserService()
    
    private init() {}
    
    func login(email: String, password: String, completion: @escaping(NetworkResult<Any>) -> Void)
    {
        let url = APIConstants.logInURL
        let header : HTTPHeaders = ["Content-Type" : "application/json"]
        let body : Parameters = [
            "email" : email,
            "password" : password
        ]
        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {return}
                guard let value = response.value else {return}
                
                let networkResult = self.judgeStatus2(by: statusCode, value)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    func emailCheck(email: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        let url = APIConstants.emailCodeURL
        let body: Parameters = [
            "email": email
            ]
        // 쿼리에서 header는? 생략 가능?
        let dataRequest = AF.request(url, method: .get, parameters: body, encoding: URLEncoding.queryString)
        
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {return}
                guard let value = response.value else {return}
                
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    func codeCheck(email: String, code: String, completion: @escaping(NetworkResult<Any>) -> Void) {
        let url = APIConstants.emailCodeURL
        let header : HTTPHeaders = ["Content-Type" : "application/json"]
        let body : Parameters = [
            "email" : email,
            "code" : code
        ]
        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {return}
                guard let value = response.value else {return}

                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    func signup(email: String, nickname: String, password: String, completion: @escaping(NetworkResult<Any>) -> Void)
    {
        let url = APIConstants.signUpURL
        let header : HTTPHeaders = ["Content-Type" : "application/json"]
        let body : Parameters = [
            "email" : email,
            "nickname" : nickname,
            "password" : password
        ]
        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {return}
                guard let value = response.value else {return}
                
                let networkResult = self.judgeSignupStatus(by: statusCode, value)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    func editProfile(nickname: String, image: UIImage?, completion: @escaping(NetworkResult<Any>) -> Void)
    {
        let url = APIConstants.editprofileURL + "1/"
        
        let header : HTTPHeaders = ["Content-Type" : "multipart/form-data"]
        let body : Parameters = [
            "nickname": nickname
        ]
        
        let dataRequest = AF.upload(multipartFormData: { MultipartFormData in
            //body 추가
            for (key, value) in body {
                MultipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            //img 추가
            if let img = image?.pngData() {
                MultipartFormData.append(img, withName: "img", fileName: "\(img).jpg", mimeType: "image/png")
            }
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: header)

        
        dataRequest.responseData{
            response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {return}
                guard let value = response.value else {return}
                
                let networkResult = self.judgeSignupStatus(by: statusCode, value)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        print("statusCode : \(statusCode)");
        switch statusCode {
        case ..<300 : return isVaildData(data: data)
        case 400..<500 : return .pathErr
        case 500..<600 : return .serverErr
        default : return .networkFail
        }
    }
    
    private func judgeStatus2(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        print("statusCode : \(statusCode)");
        switch statusCode {
        case ..<300 : return isVaildData2(data: data)
        case 400..<500 : return .pathErr
        case 500..<600 : return .serverErr
        default : return .networkFail
        }
    }
    
    private func judgeSignupStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        print("statusCode : \(statusCode)");
        switch statusCode {
        case ..<300 :
            print(statusCode,"입니다")
            return isSignupVaildData(data: data)
        case 400..<500 :
            print(statusCode,"입니다")
            return .pathErr
        case 500..<600 :
            print(statusCode,"입니다")
            return .serverErr
        default :
            print(statusCode,"입니다")
            return .networkFail
        }
    }
    
    private func isVaildData(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(SignupResponse.self, from: data)
        else { return .pathErr }
        
        return .success(decodedData as Any)
    }
    
    private func isVaildData2(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(LoginResponse.self, from: data)
        else { return .pathErr }
        
        return .success(decodedData as Any)
    }
    private func isSignupVaildData(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        print("성공은 해서 signupvaliddata에 들어옴")
        guard let decodedData = try? decoder.decode(SignupResponse.self, from: data)
        else { return .pathErr }
        
        return .success(decodedData as Any)
    }
}

