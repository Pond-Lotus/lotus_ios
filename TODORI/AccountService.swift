//
//  AccountService.swift
//  TODORI
//
//  Created by Dasol on 2023/05/02.
//

import Foundation
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
        let dataRequest = AF.request(url, method: .get, parameters: body, encoding: URLEncoding.queryString)
        
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {return}
                guard let value = response.value else {return}
                
//                let networkResult = self.judgeStatus(by: statusCode, value, .emailcodecheck)
//                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
        
        AF.request(url, parameters: body, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        completion(.success(json))
                    } else {
                        print("???")
                    }
                case .failure(let error):
                    completion(.networkFail)
                }
            }
    }
    
//    func codeCheck(email: String, code: String, completion: @escaping(NetworkResult<Any>) -> Void) {
//        let url = APIConstants.emailCodeURL
//        let header : HTTPHeaders = ["Content-Type" : "application/json"]
//        let body : Parameters = [
//            "email" : email,
//            "code" : code
//        ]
//        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
//
//        dataRequest.responseData { response in
//            switch response.result {
//            case .success:
//                guard let statusCode = response.response?.statusCode else {return}
//                guard let value = response.value else {return}
//
//                let networkResult = self.judgeStatus(by: statusCode, value, .emailcodecheck)
//                completion(networkResult)
//            case .failure:
//                completion(.networkFail)
//            }
//        }
//    }
//
//    func signup(email: String, nickname: String, password: String, completion: @escaping(NetworkResult<Any>) -> Void)
//    {
//        let url = APIConstants.signUpURL
//        let header : HTTPHeaders = ["Content-Type" : "application/json"]
//        let body : Parameters = [
//            "email" : email,
//            "nickname" : nickname,
//            "password" : password
//        ]
//        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
//
//        dataRequest.responseData{
//            response in
//            switch response.result {
//            case .success:
//                guard let statusCode = response.response?.statusCode else {return}
//                guard let value = response.value else {return}
//
//                let networkResult = self.judgeStatus(by: statusCode, value, .signup)
//                completion(networkResult)
//            case .failure:
//                completion(.networkFail)
//            }
//        }
//    }
//
//    func editProfile(nickname: String?, image: UIImage?, completion: @escaping(NetworkResult<Any>) -> Void) {
//        let url = APIConstants.editprofileURL + "1/"
//        guard let token = UserDefaults.standard.string(forKey: "myToken") else { return } // by kane.
//        let header : HTTPHeaders = [
//            "Content-Type" : "multipart/form-data",
//            "Authorization" : "Token " + token
//        ]
//        let body : Parameters = [
//            "nickname": nickname ?? "(알 수 없음)"
//        ]
//
//        let dataRequest = AF.upload(multipartFormData: { MultipartFormData in
//            for (key, value) in body {
//                MultipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
//            }
//            if let img = image?.pngData() {
//                MultipartFormData.append(img, withName: "image", fileName: "\(String(describing: nickname)).jpg", mimeType: "image/jpg")
//            }
//        }, to: url, method: .post, headers: header)
////
////        dataRequest.responseData {
////            response in
////            switch response.result {
////            case .success:
////                guard let statusCode = response.response?.statusCode else {return}
////                guard let value = response.value else {return}
////
////                let networkResult = self.judgeStatus(by: statusCode, value, .editprofile)
////                completion(networkResult)
////            case .failure:
////                completion(.networkFail)
////            }
////        }
//        dataRequest.responseDecodable(of:EditProfileResponse.self) { response in
//            switch response.result {
//            case .success:
//                guard let data = response.data else {return}
//                let decoder = JSONDecoder()
//                guard let decodedData = try? decoder.decode(EditProfileResponse.self, from: data) else { return }
//                completion(.success(decodedData as Any))
//            case .failure:
//                completion(.networkFail)
//            }
//        }
//    }
//
//    private func judgeStatus(by statusCode: Int, _ data: Data, _ form: UserAPI) -> NetworkResult<Any> {
//        switch statusCode {
//        case ..<300 : return isVaildData(data: data, form: form)
//        case 400..<500 : return .pathErr
//        case 500..<600 : return .serverErr
//        default : return .networkFail
//        }
//    }
//
//    private func isVaildData(data: Data, form: UserAPI) -> NetworkResult<Any> {
//        let decoder = JSONDecoder()
//
//        switch form {
//        case .emailcodecheck:
//            guard let decodedData = try? decoder.decode(SignupResponse.self, from: data) else { return .pathErr }
//            return .success(decodedData as Any)
//        case .signup:
//            guard let decodedData = try? decoder.decode(SignupResponse.self, from: data) else { return .pathErr }
//            return .success(decodedData as Any)
//        case .login:
//            guard let decodedData = try? decoder.decode(LoginResponse.self, from: data) else { return .pathErr }
//            return .success(decodedData as Any)
//        case .editprofile:
//            guard let decodedData = try? decoder.decode(EditProfileResponse.self, from: data) else { return .pathErr }
//            return .success(decodedData as Any)
//        }
//    }
}


