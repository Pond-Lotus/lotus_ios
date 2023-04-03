//
//  ProfileService.swift
//  ToDo
//
//  Created by 제임스 on 2023/02/06.
//

import Foundation
import Alamofire

class UserInfoService{
    static let shared = UserInfoService()
    
    private init(){} //이게 무슨 의미??
    
    func editImageAndNickname(image:UIImage, nickname:String, completion: @escaping(NetworkResult<Any>)->Void){
        
        let url = Server.serverURL + Server.editProfile
        
        let userDefault = UserDefaults.standard
        guard let token = userDefault.string(forKey: "token") else {return}
        let header : HTTPHeaders = ["Content-Type" : "multipart/form-data",
                                    "Authorization": "Token \(token)"]
        
        let parameter:Parameters = [
            "nickname" : nickname
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameter{
                guard let valueForMultiForm = "\(value)".data(using: .utf8) else {return}
                multipartFormData.append(valueForMultiForm, withName: key)
            }
            if let imageForMultiForm = image.pngData(){
                multipartFormData.append(imageForMultiForm, withName: "image",fileName: "image.png", mimeType: "image/png")
            }
        }, to: url, method: .post, headers: header).responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeEditImageAndNicknameSatus(by: statusCode, value)
                
                completion(networkResult)
                
            case .failure:
                completion(.pathErr)
            }
        }
        
    }
    
    func editPassword(originPW:String, newPW:String, completion: @escaping(NetworkResult<Any>)->Void){
        
        let url = Server.serverURL + Server.editPassword
        
        let userDefault = UserDefaults.standard
        guard let token = userDefault.string(forKey: "token") else {return}
        
        let parameter:Parameters = [
            "originpw" : originPW,
            "newpw" : newPW
        ]
        
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        
        let request = AF.request(url,
                                 method: .post,
                                 parameters: parameter,
                                 encoding: JSONEncoding.default,
                                 headers: header)
        
        request.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeEditPasswordStatus(by: statusCode, value)
                
                completion(networkResult)
                
            case .failure:
                completion(.pathErr)
            }
        }
        
    }
    
    func checkToken(token:String, completion: @escaping(NetworkResult<Any>)->Void){
        
        let url = Server.serverURL + Server.who
        
        let userDefault = UserDefaults.standard
        guard let token = userDefault.string(forKey: "token") else {return}
        
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        
        let request = AF.request(url,
                                 method: .get,
                                 encoding: JSONEncoding.default,
                                 headers: header)
        
        request.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeCheckTokenStatus(by: statusCode, value)
                
                completion(networkResult)
                
            case .failure:
                completion(.pathErr)
            }
        }
        
    }
    private func judgeEditImageAndNicknameSatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode{
        case ..<300:
            return isEditImageAndNicknameValidData(data: data)
        case ..<400:
            return .pathErr
        case ..<600:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func judgeEditPasswordStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode{
        case ..<300:
            return isEditPasswordValidData(data: data)
        case ..<400:
            return .pathErr
        case ..<600:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func judgeCheckTokenStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode{
        case ..<300:
            return isCheckTokenValidData(data: data)
        case ..<400:
            return .pathErr
        case ..<600:
            return .serverErr
        default:
            return .networkFail
        }
    }

    private func isEditImageAndNicknameValidData(data:Data) -> NetworkResult<Any>{
        guard let decodedData = try? JSONDecoder().decode(EditImageAndNicknameResonseData.self, from: data) else {return .decodeErr}
        
        return .success(decodedData)
    }
    
    private func isEditPasswordValidData(data:Data) -> NetworkResult<Any>{
        guard let decodedData = try? JSONDecoder().decode(ResponseData.self, from: data) else {return .decodeErr}
        
        return .success(decodedData)
    }
    
    private func isCheckTokenValidData(data:Data) -> NetworkResult<Any>{
        guard let decodedData = try? JSONDecoder().decode(ResponseData.self, from: data) else {return .decodeErr}
        
        return .success(decodedData)
    }
}
