//
//  ToDoService.swift
//  ToDo
//
//  Created by KDS on 2023/01/24.
//

import Foundation
import Alamofire

class ToDoService {
    
    static let shared = ToDoService()
    
    private init() {}
    
    func writeToDo(year: String, month: String, day: String, title: String, completion: @escaping(NetworkResult<Any>) -> Void)
    {
        let url = APIConstants.toDoURL
        let header: HTTPHeaders = ["Authorization" : "Token " + UserDefaults.standard.string(forKey: "myToken")!]
        let body: Parameters = [
            "year" : year,
            "month" : month,
            "day" : day,
            "title" : title
        ]
        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let value = response.value else {return}
                let networkResult = self.judgeStatus(by: statusCode, value, .add)
                
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    func inquireToDo(year: String, month: String, day: String, completion: @escaping(NetworkResult<Any>) -> Void)
    {
        let url = APIConstants.toDoURL
        let header: HTTPHeaders = ["Authorization" : "Token " + UserDefaults.standard.string(forKey: "myToken")!]
        let body: Parameters = [
            "year" : year,
            "month" : month,
            "day" : day
        ]
        let dataRequest = AF.request(url, method: .get, parameters: body, encoding: URLEncoding.queryString, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {return}
                guard let value = response.value else {return}
                let networkResult = self.judgeStatus(by: statusCode, value, .inquire)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    func editToDo(id: Int, year: String, month: String, day: String, title: String, done: Bool, completion: @escaping(NetworkResult<Any>) -> Void)
    {
        let url = APIConstants.toDoURL + "\(id)/" // 꼭 /을 붙여야함
        let header: HTTPHeaders = ["Authorization" : "Token " + UserDefaults.standard.string(forKey: "myToken")!]
        let body: Parameters = [
            "year" : Int(year)!, // 와 타입 때문에 pathError..
            "month" : Int(month)!,
            "day" : Int(day)!,
            "title" : title,
            "done" : done
        ]
        let dataRequest = AF.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {return}
                guard let value = response.value else { return }
                let networkResult = self.judgeStatus(by: statusCode, value, .edit)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    func deleteToDo(id: Int, completion: @escaping(NetworkResult<Any>) -> Void)
    {
        let url = APIConstants.toDoURL + "\(id)/"
        let header: HTTPHeaders = ["Authorization" : "Token " + UserDefaults.standard.string(forKey: "myToken")!]
        let dataRequest = AF.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {return}
                guard let value = response.value else {return}
                
                let networkResult = self.judgeStatus(by: statusCode, value, .delete)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data, _ form: API) -> NetworkResult<Any> {
        switch statusCode {
        case ..<300 : return isVaildData(data: data, form: form)
        case 400..<500 : return .pathErr
        case 500..<600 : return .serverErr
        default : return .networkFail
        }
    }
    
    private func isVaildData(data: Data, form: API) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        switch form {
        case .add:
            guard let decodedData = try? decoder.decode(ToDoResponse.self, from: data) else { return .pathErr }
            return .success(decodedData as Any)
        case .edit:
            guard let decodedData = try? decoder.decode(EditToDoResponse.self, from: data) else { return .pathErr }
            return .success(decodedData as Any)
        case .inquire:
            guard let decodedData = try? decoder.decode(ToDoListResponse.self, from: data) else { return .pathErr }
            return .success(decodedData as Any)
        case .delete:
            guard let decodedData = try? decoder.decode(DeleteToDoResponse.self, from: data) else { return .pathErr }
            return .success(decodedData as Any)
        }
    }
}

