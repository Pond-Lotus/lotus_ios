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
    private func judgeSearchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode{
        case ..<300: return isSearchValidData(data: data)
        case ..<500: return .pathErr
        case ..<600 : return .serverErr
        default: return .networkFail
        }
    }
    
    private func isSearchValidData(data:Data) -> NetworkResult<Any>{
        guard let decodedData = try? JSONDecoder().decode(TodoSearchResponseData.self, from: data) else {return .pathErr}
        
        return .success(decodedData)
    }
}
