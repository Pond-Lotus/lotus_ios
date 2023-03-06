//
//  RegisterService.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/14.
//

import Foundation
import Alamofire

//뷰컨에서 싱글턴 패턴으로 공용 인스턴스에 접근해서 통신하는 메서드 소출. 이때 escaping closure 값을 받아서 분기처리 후 데이터 가공

class RegisterService{
    
    //싱글턴 패턴 - static 키워드를 통해서 shared라는 프로퍼티에 싱글턴 인스턴스 저장하여 생성
    //이를 통해 여러 VC 에서도 shared로 접근하면 같은 인스턴스에 접근할 수 있는 형태 음 네 그렇답니다.
    static let shared = RegisterService()
    
    private init(){}
    
    //escaping closure을 통해서 결과값을 뷰컨트롤러에 전달
    //해당 함수가 종료되는 것과 상관없이 completion은 탈출 클로저이기 때문에 전달 된다면 외부에서 사용 가능
    //함수의 인자로 탈출 클로저를 선언한 것임
    func checkValidEamil(email:String, completion: @escaping (NetworkResult<Any>) -> Void){
        
        let url = Server.serverURL + Server.getEmailCode
        
        //json 형태로 받아오기 위한 헤더
        let header : HTTPHeaders = ["Content-Type" : "application/json"]
        
        let parameter:Parameters = [
            "email":email
        ]
        
        //url에 쿼리 아이템으로 추가하는 방법. URLEncoding.queryString
        let request = AF.request(url,
                                 method: .get,
                                 parameters: parameter,
                                 encoding: URLEncoding.queryString,
                                 headers: header)
        
        //위의 request를 서버로 보내고 통신이 완료되면 클로저를 통해서 결과 도착
        request.responseData { dataResponse in
            //dataResponse가 도착하였고, 그 안에 통신 결과물이 있음.
            //dataResponse.result는 통신 성공/실패 여부
            switch dataResponse.result {
            case .success:
                //statusCode ex? 200/400/500
                guard let statusCode = dataResponse.response?.statusCode else {return}
                //dataResponse.value는 Response의 결과 데이터
                guard let value = dataResponse.value else {return}
                
                //judgeStatus 함수에 statusCode와 response(결과 데이터)를 실어서 보낸다.
                let networkResult = self.judgeStatus(by: statusCode, value)
                
                completion(networkResult)//함수가 실행 끝나고 나서 judgeSatus 반환값을 VC로 보내는 건가...
                
                //통신 실패하면 completion에 pathErr 실어서 뷰컨에 날린다.
            case .failure:
                completion(.pathErr)
            }
        }
    }
    
    func checkVerificationCode(email:String, code:String, completion: @escaping(NetworkResult<Any>)->Void){
        
        let url = Server.serverURL+Server.postEmailCode
        
        let header : HTTPHeaders = ["Content-Type" : "application/json"]
        
        let parameter:Parameters = [
            "email":email,
            "code": code
        ]
        
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
                let networkResult = self.judgeStatus(by: statusCode, value)
                
                completion(networkResult)
                
            case .failure:
                completion(.pathErr)
            }
        }}
    
    func register(nickname:String, email:String, password:String, completion: @escaping(NetworkResult<Any>)->Void){
        let url = Server.serverURL+Server.register
        
        let header : HTTPHeaders = ["Content-Type" : "application/json"]
        
        let parameter:Parameters = [
            "nickname":nickname,
            "email":email,
            "password": password
        ]
        print("email: \(email), nickname: \(nickname), pw: \(password)")
        
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
                print("statusCode: \(statusCode)")
                let networkResult = self.judgeRegisterStatus(by: statusCode, value)
                completion(networkResult)
                
            case .failure:
                completion(.pathErr)
            }
        }
    }
    
    func login(email:String, password:String, completion: @escaping(NetworkResult<Any>)->Void){
        
        let url = Server.serverURL + Server.login
        
        let header : HTTPHeaders = ["Content-Type" : "application/json"]
        
        let parameter:Parameters = [
            "email":email,
            "password": password
        ]
        
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
                print("statusCode: \(statusCode)")
                let networkResult = self.judgeLoginStatus(by: statusCode, value)
                completion(networkResult)
                
            case .failure:
                completion(.pathErr)
            }
        }
        
    }
    
    //아까 받은 statusCode 바탕으로 결과값 어떻게 처리할 건지 정의
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode{
        case ..<300: return isValidData(data: data) //성공. 데이터 가공해서 전달 해야하니까 isValidData 함수로 데이터 넘김 결과적으로 return 하는 값은 .success(data)
        case ..<500: return .pathErr //요청 오류
        case ..<600 : return .serverErr //서버 에러
        default: return .networkFail //네트워크 에러 -> 분기처리
        }
    }
    
    private func judgeRegisterStatus(by statusCode:Int, _ data:Data) -> NetworkResult<Any>{
        switch statusCode{
        case ..<300 : return isRegisterValidData(data: data)
        case ..<500: return .pathErr
        case ..<600 : return .serverErr
        default: return .networkFail
        }
    }
    
    private func judgeLoginStatus(by statusCode:Int, _ data:Data) -> NetworkResult<Any>{
        switch statusCode{
        case ..<300 : return isLoginRegisterValidData(data: data)
        case ..<500: return .pathErr
        case ..<600 : return .serverErr
        default: return .networkFail
        }
    }
    
    //200대로 떨어졌을 때 데이터를 가공하기 위한 함수 랍니다
    private func isValidData(data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(ResponseData.self, from: data) else {return .decodeErr}
        
        //성공적으로 decode 마치면 success에 data부분을 담아서 completion을 호출한다...
        return .success(decodedData)
    }
    
    private func isRegisterValidData(data:Data) -> NetworkResult<Any> {
//        let decoder = JSONDecoder()
//
//        guard let resultCodeData = try? decoder.decode(ResponseData.self, from: data) else {return .pathErr}
//        var originData:RegisterResponseData? = .init(account: .init(nickname: "", email: ""), resultCode: resultCodeData.resultCode)
//
//        if resultCodeData.resultCode == 200{
//            guard let decodedData = try? decoder.decode(RegisterResponseData.self, from: data) else {return .pathErr}
//            originData = decodedData
//        }

//        print("resultCode: \(resultCodeData.resultCode)")
        
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(RegisterResponseData.self, from: data) else {return .decodeErr}
        
        //성공적으로 decode 마치면 success에 data부분을 담아서 completion을 호출한다...
        return .success(decodedData)
        
    }
    
    private func isLoginRegisterValidData(data:Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(LoginResponseData.self, from: data) else {return .decodeErr}
        
        //성공적으로 decode 마치면 success에 data부분을 담아서 completion을 호출한다...
        return .success(decodedData)
    }
    
}
