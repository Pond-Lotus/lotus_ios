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
        print(body)
        let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
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
    
    func searchToDo(year: String, month: String, day: String, completion: @escaping(NetworkResult<Any>) -> Void)
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
                
                let networkResult = self.judgeStatus2(by: statusCode, value)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    func editToDo(year: String, month: String, day: String, title: String, done: String, completion: @escaping(NetworkResult<Any>) -> Void)
    {
        let url = APIConstants.toDoURL + "72/"
        let header: HTTPHeaders = ["Authorization" : "Token " + UserDefaults.standard.string(forKey: "myToken")!]
        let body: Parameters = [
            "year" : year,
            "month" : month,
            "day" : day,
            "title" : title,
            "done" : done
        ]
        let dataRequest = AF.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
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
    
    func deleteToDo(year: String, month: String, day: String, title: String, done: String, completion: @escaping(NetworkResult<Any>) -> Void)
    {
        let url = APIConstants.toDoURL + "71/"
        let header: HTTPHeaders = ["Authorization" : "Token " + UserDefaults.standard.string(forKey: "myToken")!]
        let body: Parameters = [
            "year" : year,
            "month" : month,
            "day" : day,
            "title" : title,
            "done" : done
        ]
        let dataRequest = AF.request(url, method: .delete, parameters: body, encoding: JSONEncoding.default, headers: header)
        
        dataRequest.responseData{
            response in
            print("response : \(response)");
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {return}
                guard let value = response.value else {return}
                
                let networkResult = self.judgeStatus3(by: statusCode, value)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
            }
        }
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case ..<300 : return isVaildData(data: data)
        case 400..<500 : return .pathErr
        case 500..<600 : return .serverErr
        default : return .networkFail
        }
    }
    
    private func judgeStatus2(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case ..<300 : return isVaildData2(data: data)
        case 400..<500 : return .pathErr
        case 500..<600 : return .serverErr
        default : return .networkFail
        }
    }
    
    private func judgeStatus3(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case ..<300 : return isVaildData3(data: data)
        case 400..<500 : return .pathErr
        case 500..<600 : return .serverErr
        default : return .networkFail
        }
    }
    
    private func isVaildData(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(ToDoResponse.self, from: data)
        else { return .pathErr }
        
        return .success(decodedData as Any)
    }
    
    private func isVaildData2(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(ToDoListResponse.self, from: data)
        else { return .pathErr }
        
        return .success(decodedData as Any)
    }
    
    private func isVaildData3(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(DeleteToDoResponse.self, from: data)
        else { return .pathErr }
        
        return .success(decodedData as Any)
    }
}

