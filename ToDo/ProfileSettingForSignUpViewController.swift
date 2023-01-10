//
//  ProfileSettingForSignUpViewController.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/09.
//

import UIKit

class ProfileSettingForSignUpViewController:UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwCheckTextField: UITextField!
    
    var email:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = email
    }
    
    @IBAction func tapFinishButton(_ sender: Any) {
        if pwTextField.text == pwCheckTextField.text{
            print("password check OK")
            doRegister()
        }else{
            print("passwords are not same")
        }
    }
    
    @IBAction func tapPreButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    func doRegister(){
        let data:RegisterRequestData = .init(email: email ?? "", nickname: nicknameTextField.text ?? "", password: pwTextField.text ?? "")
        let jsonData = try? JSONEncoder().encode(data)
        
        guard var url = URL(string: "https://plotustodo-ctzhc.run.goorm.io/account/register/") else {
            print("url error")
            return
        }
        
        var request:URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling POST")
                print(error!)
                return
            }
            if let data = data{
                guard let result = try? JSONDecoder().decode(ResponseData.self, from: data) else{
                    print("decode error")
                    return}
                print("result code: \(result.resultCode)")
                if result.resultCode == 200{
                    DispatchQueue.main.async {
                        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "FinishRegisterViewController") as? FinishRegisterVeiwController else {return}
//                        nextViewController.nickname = result.account.nickname
                        nextViewController.modalPresentationStyle = .fullScreen
                        self.present(nextViewController, animated: false)
                    }
                }else{
                    print("register error")
                }
            }else {
                print("Error: Did not receive data")
                return
            }

            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
        }.resume()
    }
}
