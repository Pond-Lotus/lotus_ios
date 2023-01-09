//
//  ProfileSettingForSignUpViewController.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/09.
//

import UIKit

class ProfileSettingForSignUpViewController:UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwCheckTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    var email:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = email ?? ""
    }
    
    @IBAction func tapFinishButton(_ sender: Any) {
        let dicData = ["nickname" : "감자찜" ,
                       "email":"hi011004@naver.com",
                       "password":"password1234"] as Dictionary<String,String>
        let jsonData = try! JSONSerialization.data(withJSONObject: dicData, options: [])
        
        guard var url = URLComponents(string: "https://plotustodo-ctzhc.run.goorm.io/account/register/") else {
            print("url error")
            return
        }
        //        let emailParam = URLQueryItem(name: "email", value: emailTextField.text ?? "")
        //        url.queryItems?.append(emailParam)
        
        var request:URLRequest = URLRequest(url: (url.url!))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        //        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
            if let data = data{
                guard let result = try? JSONDecoder().decode(ResponseData.self, from: data) else{return}
                print("result code:\(result.resultCode)")
            }else {
                print("Error: Did not receive data")
                return
            }
//            print("data: \(String(data: data, encoding: .utf8) ?? "error")")
//            print("response: \(response)")
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            //              guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
            //                  print("Error: JSON Data Parsing failed")
            //                  return
            //              }
            
            //              completionHandler(true, output.result)
            
        }.resume()
    }
    
    @IBAction func tapPreButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
}
