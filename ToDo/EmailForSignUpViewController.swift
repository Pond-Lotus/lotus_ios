//
//  EmailForSignUpViewController.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/06.
//

import UIKit

class EmailForSignUpViewController : UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var isValidLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    var isValid:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapNextButton(_ sender: Any) {
        nextButton.isEnabled = false
        emailCheck()
    }
    
    func emailCheck(){
        guard var url = URL(string: "https://plotustodo-ctzhc.run.goorm.io/account/emailcode/?email=\(emailTextField.text ?? "")") else {
            print("url error")
            return
        }

        var request:URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
                
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
            if let data = data{
                guard let result = try? JSONDecoder().decode(ResponseData.self, from: data) else{return}
                print("result code:\(result.resultCode)")
                if result.resultCode == 200 {
                    DispatchQueue.main.async {
                        self.nextButton.isEnabled = true
                        self.isValidLabel.isHidden = true
                        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VerificationCodeForSignUpViewController") as? VerificationCodeForSignUpViewController else {return}
                        viewController.modalPresentationStyle = .fullScreen
                        viewController.email = self.emailTextField.text
                        self.present(viewController, animated: false)
                    }
                }else{
                    DispatchQueue.main.async {
                        self.nextButton.isEnabled = true
                        self.isValidLabel.isHidden = false
                    }
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
