//
//  ViewController.swift
//  ToDo
//
//  Created by KDS on 2023/01/04.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func tapLoginButton(_ sender: Any) {
        login(email: emailTextField.text ?? "", password: pwTextField.text ?? "")
    }
    
    @IBAction func tapRegisterButton(_ sender: Any) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "EmailForSignUpViewController") as? EmailForSignUpViewController else {return}
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false)
    }
    
    
    private func login(email:String,password:String){
        RegisterService.shared.login(email: email, password: password) { (response) in
            switch(response){
            case .success(let resultData):
                if let data = resultData as? LoginResponseData{
                    print(data.resultCode)
                    print(data.token)
                    if data.resultCode == 200 {
                        let userDefault = UserDefaults.standard
                        userDefault.set(data.token, forKey: "token")
                        
                        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TodoMainViewController") as? TodoMainViewController else {return}
                        viewController.modalPresentationStyle = .fullScreen
                        self.present(viewController, animated: false)
                    }
                }
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
        
    }
    
    
}

