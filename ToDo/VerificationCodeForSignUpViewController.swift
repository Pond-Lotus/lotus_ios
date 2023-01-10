//
//  VerificationCodeForSignUpViewController.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/09.
//

import UIKit

class VerificationCodeForSignUpViewController :UIViewController{
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var wrongCodeLabel: UILabel!
    var email:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("email:\(email)")
        textFieldSetting()
    }
    
    @IBAction func tapNextButton(_ sender: Any) {
       verifyCode()
    }
    
    @IBAction func tapPreButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
    func verifyCode(){
        let data:RequestData = .init(email: email ?? "", code: codeTextField.text ?? "")
        let jsonData = try? JSONEncoder().encode(data)
        guard var url = URL(string: "https://plotustodo-ctzhc.run.goorm.io/account/emailcode/") else {
            print("url error")
            return
        }

        var request:URLRequest = URLRequest(url: url)
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
                let result = try? JSONDecoder().decode(ResponseData.self, from: data)
                print("verify result code: \(result?.resultCode)")
                if result?.resultCode == 200{
                    DispatchQueue.main.async {
                        self.wrongCodeLabel.isHidden = true
                        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileSettingForSignUpViewController") as? ProfileSettingForSignUpViewController else {return}
                        nextViewController.modalPresentationStyle = .fullScreen
                        nextViewController.email = self.email
                        self.present(nextViewController, animated: false)
                    }
                }else{
                    print("verification code is incorrect")
                    self.wrongCodeLabel.isHidden = false
                }
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
