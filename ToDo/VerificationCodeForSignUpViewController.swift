//
//  VerificationCodeForSignUpViewController.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/09.
//

import UIKit

class VerificationCodeForSignUpViewController :UIViewController{
    @IBOutlet weak var codeTextField: UITextField!
    var email:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldSetting()
    }
    
    @IBAction func tapNextButton(_ sender: Any) {
        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileSettingForSignUpViewController") as? ProfileSettingForSignUpViewController else {return}
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.email = email
        self.present(nextViewController, animated: false)
        verifyCode()
    }
    
    @IBAction func tapPreButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
    func verifyCode(){
        guard let inputCodeText = codeTextField.text else {return}
        guard let inputCode:Int = Int(inputCodeText) else {return}
        let data:RequestData = .init(email: email ?? "", code: inputCode)
        let jsonData = try? JSONEncoder().encode(data)
        let printdata = try? JSONDecoder().decode(RequestData.self, from: jsonData!)
        print("printdata: \(printdata!)")
        guard var url = URLComponents(string: "https://plotustodo-ctzhc.run.goorm.io/account/emailcode/") else {
            print("url error")
            return
        }

        var request:URLRequest = URLRequest(url: (url.url!))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
                
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("error in verification code")
                print(error!)
                return
            }
            if var data = data{
                let result = try? JSONDecoder().decode(RequestCode.self, from: data)
                print("verify result code: \(result?.requestCode)")
            }
            else {
                print("Error: Did not receive data")
                return
            }

            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
        }.resume()
    }
    func textFieldSetting(){
        codeTextField.defaultTextAttributes.updateValue(45.0, forKey: NSAttributedString.Key.kern)
        codeTextField.borderStyle = .line
    }
}
