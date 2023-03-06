//
//  TodoService.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/24.
//

import Foundation
import Alamofire

class TodoService{
    static let shared = TodoService()
    
    private init(){}
    
    func searchTodo(year:String, month:String, day:String, completion:@escaping(NetworkResult<Any>)->Void){
        let url = Server.serverURL + Server.todo
        let userDefault = UserDefaults.standard
        guard let token = userDefault.string(forKey: "token") else {return}
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        
        let parameter:Parameters = [
            "year":year,
            "month": month,
            "day":day
        ]
        
        
        let request = AF.request(url,
                                 method: .get,
                                 parameters: parameter,
                                 encoding: URLEncoding.queryString,
                                 headers: header)
        
        request.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeSearchStatus(by: statusCode, value)
                
                completion(networkResult)
                
            case .failure:
                completion(.pathErr)
            }
        }
        
    }
    
    func writeTodo(year:String, month:String, day:String,title:String,color:Int, completion:@escaping(NetworkResult<Any>)->Void){
        let url = Server.serverURL + Server.todo
        
        let userDefault = UserDefaults.standard
        guard let token = userDefault.string(forKey: "token") else {return}
        
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        
        let parameter:Parameters = [
            "year":year,
            "month": month,
            "day":day,
            "title":title,
            "color":color
        ]
        print("token: \(token), year: \(year), month: \(month), day: \(day), title: \(title)")
        
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
                let networkResult = self.judgeWriteStatus(by: statusCode, value)
                
                completion(networkResult)
                
            case .failure:
                completion(.pathErr)
            }
        }
    }
    
    func deleteTodo(id:Int, completion:@escaping(NetworkResult<Any>)->Void){
        let url = Server.serverURL + Server.todo + "\(id)/" //이런식으로 해도되나 ㅜㅜ
        
        let userDefault = UserDefaults.standard
        guard let token = userDefault.string(forKey: "token") else {return}
        
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        
        let request = AF.request(url,
                                 method: .delete,
                                 headers: header)
        
        request.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeDeleteStatus(by: statusCode, value)
                
                completion(networkResult)
                
            case .failure:
                completion(.pathErr)
            }
        }
    }
    
    func editDone(id:Int, done:Bool, completion:@escaping(NetworkResult<Any>)->Void){
        let url = Server.serverURL + Server.todo + "\(id)/" //이런식으로 해도되나 ㅜㅜ
        
        let userDefault = UserDefaults.standard
        guard let token = userDefault.string(forKey: "token") else {return}
        
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        
        let parameter:Parameters = [
            "done":done
        ]
        
        let request = AF.request(url,
                                 method: .put,
                                 parameters: parameter,
                                 encoding: JSONEncoding.default,
                                 headers: header)
        
        request.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeEditDoneStatus(by: statusCode, value)
                
                completion(networkResult)
                
            case .failure:
                completion(.pathErr)
            }
        }
    }
    
    func modifyTodo(id:Int, color:Int, description:String, completion:@escaping(NetworkResult<Any>)->Void){
        let url = Server.serverURL + Server.todo + "\(id)/" //이런식으로 해도되나 ㅜㅜ
        
        let userDefault = UserDefaults.standard
        guard let token = userDefault.string(forKey: "token") else {return}
        
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        
        let parameter:Parameters = [
            "color":color,
            "description":description,
            //time추가
        ]
        
        let request = AF.request(url,
                                 method: .put,
                                 parameters: parameter,
                                 encoding: JSONEncoding.default,
                                 headers: header)
        
        request.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeEditDoneStatus(by: statusCode, value)
                
                completion(networkResult)
                
            case .failure:
                completion(.pathErr)
            }
        }
    }
    
    func getPriority(completion:@escaping(NetworkResult<Any>)->Void){
        let url = Server.serverURL + Server.priority
        
        let userDefault = UserDefaults.standard
        guard let token = userDefault.string(forKey: "token") else {return}
        
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        
        let request = AF.request(url,
                                 method: .get,
                                 headers: header)
        
        request.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgePrioiryStatus(by: statusCode, value)
                
                completion(networkResult)
                
            case .failure:
                completion(.pathErr)
            }
        }
    }
    
    func setPriority(priority:String,completion:@escaping(NetworkResult<Any>)->Void){
        let url = Server.serverURL + Server.priority
        
        let userDefault = UserDefaults.standard
        guard let token = userDefault.string(forKey: "token") else {return}
        
        let parameter:Parameters = [
            "priority" : priority
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
                let networkResult = self.judgePrioiryStatus(by: statusCode, value)
                
                completion(networkResult)
                
            case .failure:
                completion(.pathErr)
            }
        }
    }
    
    func getColorNumArray(year:String, month:String, completion:@escaping(NetworkResult<Any>)->Void){
        let url = Server.serverURL + Server.getColor
        
        let userDefault = UserDefaults.standard
        guard let token = userDefault.string(forKey: "token") else {return}
        
        let parameter:Parameters = [
            "year" : year,
            "month" : month
        ]
        
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        
        let request = AF.request(url,
                                 method: .get,
                                 parameters: parameter,
                                 encoding: URLEncoding.queryString,
                                 headers: header)
        
        request.responseData { dataResponse in
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeGetColorArrayStatus(by: statusCode, value)
                
                completion(networkResult)
                
            case .failure:
                completion(.pathErr)
            }
        }
    }
    
    private func judgeGetColorArrayStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode{
        case ..<300: return isGetColorArrayValidData(data: data)
        case ..<500: return .pathErr
        case ..<600 : return .serverErr
        default: return .networkFail
        }
    }
    
    private func judgePrioiryStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode{
        case ..<300: return isPriorityValidData(data: data)
        case ..<500: return .pathErr
        case ..<600 : return .serverErr
        default: return .networkFail
        }
    }
    private func judgeSearchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode{
        case ..<300: return isSearchValidData(data: data)
        case ..<500: return .pathErr
        case ..<600 : return .serverErr
        default: return .networkFail
        }
    }
    
    
    private func judgeWriteStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode{
        case ..<300: return isWriteValidData(data: data)
        case ..<500: return .pathErr
        case ..<600 : return .serverErr
        default: return .networkFail
        }
    }
    
    private func judgeEditDoneStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode{
        case ..<300: return isEditDoneValidData(data: data)
        case ..<500: return .pathErr
        case ..<600 : return .serverErr
        default: return .networkFail
        }
    }
    
    private func judgeDeleteStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode{
        case ..<300: return isDeleteValidData(data: data)
        case ..<500: return .pathErr
        case ..<600 : return .serverErr
        default: return .networkFail
        }
    }
    
    private func judgeModifyStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode{
        case ..<300: return isEditDoneValidData(data: data)
        case ..<500: return .pathErr
        case ..<600 : return .serverErr
        default: return .networkFail
        }
    }
    
    
    private func isSearchValidData(data:Data) -> NetworkResult<Any> {
        guard let decodedData = try? JSONDecoder().decode(TodoSearchResponseData.self, from: data) else {return .decodeErr}
        
        return .success(decodedData)
    }
    
    private func isWriteValidData(data:Data) -> NetworkResult<Any>{
        guard let decodedData = try? JSONDecoder().decode(TodoWriteResponseData.self, from: data) else {return .decodeErr}
        
        return .success(decodedData)
    }
    
    private func isDeleteValidData(data:Data) -> NetworkResult<Any>{
        guard let decodedData = try? JSONDecoder().decode(ResponseData.self, from: data) else {return .decodeErr}
        
        return .success(decodedData)
    }
    private func isEditDoneValidData(data:Data) -> NetworkResult<Any>{
        guard let decodedData = try? JSONDecoder().decode(TodoEditResponseData.self, from: data) else {return .decodeErr}
        
        return .success(decodedData)
    }
    
    private func isPriorityValidData(data:Data) -> NetworkResult<Any>{
        guard let decodedData = try? JSONDecoder().decode(PriorityResponseData.self, from: data) else {return .decodeErr}
        
        return .success(decodedData)
    }
    private func isGetColorArrayValidData(data:Data) -> NetworkResult<Any>{
        guard let decodedData = try? JSONDecoder().decode(PriorityResponseData.self, from: data) else {return .decodeErr}
        
        return .success(decodedData)
    }
    
}
