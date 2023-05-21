//
//  TodoAPIConstant.swift
//  TODORI
//
//  Created by 제임스 on 2023/04/19.
//

import Foundation
import Alamofire

class TodoAPIConstant {
    static let shared = TodoAPIConstant()
    
    func searchTodo(year:String, month:String, day:String, completion:@escaping(AFResult<Any>)->Void){
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
        AF.request(url, method: .get,parameters: parameter, headers: header)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String:Any] {
                        do{
                            let data = try JSONSerialization.data(withJSONObject: json, options: [])
                            let decodedData = try JSONDecoder().decode(TodoSearchResponseData.self, from: data)
                            completion(.success(decodedData))
                        }catch{
                            completion(.failure("decode error"))
                        }
                        
                    } else {
                        completion(.failure("data error"))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        
        
    }
    
    func deleteTodo(id:Int, completion:@escaping(AFResult<Any>)->Void){
        let url = Server.serverURL + Server.todo + "\(id)/"
        
        let userDefault = UserDefaults.standard
        guard let token = userDefault.string(forKey: "token") else {return}
        
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        

        
        AF.request(url, method: .delete,headers: header)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String:Any] {
                        do{
                            let data = try JSONSerialization.data(withJSONObject: json, options: [])
                            let decodedData = try JSONDecoder().decode(ResponseData.self, from: data)
                            completion(.success(decodedData))
                        }catch{
                            completion(.failure("decode error"))
                        }
                        
                    } else {
                        completion(.failure("data error"))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func writeTodo(year:String, month:String, day:String, title:String, color:Int, completion:@escaping(AFResult<Any>)->Void){
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
        
        AF.request(url,
                   method: .post,
                   parameters: parameter,
                   encoding: JSONEncoding.default,
                   headers: header)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String:Any] {
                        do{
                            let data = try JSONSerialization.data(withJSONObject: json, options: [])
                            let decodedData = try JSONDecoder().decode(TodoWriteResponseData.self, from: data)
                            completion(.success(decodedData))
                        }catch{
                            completion(.failure("decode error"))
                        }
                        
                    } else {
                        completion(.failure("data error"))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func editTodo(title:String, description:String,id:Int, completion:@escaping(AFResult<Any>)->Void){
        let url = Server.serverURL + Server.todo + "\(id)/"
        
        let userDefault = UserDefaults.standard
        guard let token = userDefault.string(forKey: "token") else {return}
        
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        
        let parameter:Parameters = [
            "title":title,
            "description":description
        ]
        AF.request(url,
                   method: .put,
                   parameters: parameter,
                   encoding: JSONEncoding.default,
                   headers: header)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String:Any] {
                        do{
                            let data = try JSONSerialization.data(withJSONObject: json, options: [])
                            let decodedData = try JSONDecoder().decode(TodoEditResponseData.self, from: data)
                            completion(.success(decodedData))
                        }catch{
                            completion(.failure("decode error"))
                        }
                        
                    } else {
                        completion(.failure("data error"))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        
    }
    
    func getPriorityName(completion:@escaping(AFResult<Any>)->Void){
        let url = Server.serverURL + Server.category
        
        let userDefault = UserDefaults.standard
        guard let token = userDefault.string(forKey: "token") else {return}
        
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: header)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String:Any] {
                        do{
                            let data = try JSONSerialization.data(withJSONObject: json, options: [])
                            let decodedData = try JSONDecoder().decode(PriorityResponseData.self, from: data)
                            completion(.success(decodedData))
                        }catch{
                            completion(.failure("decode error"))
                        }
                        
                    } else {
                        completion(.failure("data error"))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func editDoneTodo(done:Bool, id:Int, completion:@escaping(AFResult<Any>)->Void){
        let url = Server.serverURL + Server.todo + "\(id)/"
        
        let userDefault = UserDefaults.standard
        guard let token = userDefault.string(forKey: "token") else {return}
        
        let header : HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authorization": "Token \(token)"]
        
        let parameter:Parameters = [
            "done":done
        ]
        AF.request(url,
                   method: .put,
                   parameters: parameter,
                   encoding: JSONEncoding.default,
                   headers: header)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String:Any] {
                        do{
                            let data = try JSONSerialization.data(withJSONObject: json, options: [])
                            let decodedData = try JSONDecoder().decode(TodoEditResponseData.self, from: data)
                            completion(.success(decodedData))
                        }catch{
                            completion(.failure("decode error"))
                        }
                        
                    } else {
                        completion(.failure("data error"))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        
    }

}
