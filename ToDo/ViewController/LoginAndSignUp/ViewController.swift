//
//  ViewController.swift
//  ToDo
//
//  Created by KDS on 2023/01/04.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var pwView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var autoLoginButton: UIButton!
    @IBOutlet weak var deleteEmailButton: UIButton!
    @IBOutlet weak var pwSetVisibleButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    var isSecureMode = false
    var isAutoLoginMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentViewSetting()
        autoLoginTokenCheck()
    }
    @IBAction func tapLoginButton(_ sender: Any) {
        login(email: emailTextField.text ?? "", password: pwTextField.text ?? "")
    }
    
    @IBAction func tapRegisterButton(_ sender: Any) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "EmailForSignUpViewController") as? EmailForSignUpViewController else {return}
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false)
    }
    
    private func autoLoginTokenCheck(){
        let userDefault = UserDefaults.standard
        guard let token = userDefault.string(forKey: "token") else {return}
        if (userDefault.string(forKey: "email") != nil) && (userDefault.string(forKey: "password") != nil){
            UserInfoService.shared.checkToken(token:token) { (response) in
                switch(response){
                case .success(let resultData):
                    if let data = resultData as? ResponseData{
                        print(data.resultCode)
                        if data.resultCode ==  500 {
                            guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TodoViewController") as? TodoViewController else {return}
                            viewController.modalPresentationStyle = .fullScreen
                            self.present(viewController, animated: false)
                        }else if data.resultCode == 200 {
                            userDefault.removeObject(forKey: "password")
                            let alert  = UIAlertController(title: "자동 로그인 만료", message: "자동 로그인이 해제되어 다시 로그인 합니다", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .default))
                            self.present(alert, animated: true)
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
            case .decodeErr:
                print("decodeErr")
            }
        }
    }
}

private func componentViewSetting(){
    emailView.layer.cornerRadius = emailView.fs_height/4
    pwView.layer.cornerRadius = pwView.fs_height/4
    loginButton.clipsToBounds = true
    loginButton.layer.cornerRadius = loginButton.fs_height/4
    
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
                    if data.image != nil {
                        userDefault.set(data.image, forKey: "profileImage")
                    }
                    userDefault.set(data.nickname, forKey: "nickname")
                    userDefault.set(data.email, forKey: "email")
                    
                    if self.isAutoLoginMode{
                        userDefault.set(self.pwTextField.text, forKey: "password")
                    }else {
                        userDefault.removeObject(forKey: "password")
                    }
                    
                    guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TodoViewController") as? TodoViewController else {return}
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
        case .decodeErr:
            print("decodeErr")
        }
    }
    
}

@IBAction func tapDeleteEmailButton(_ sender: Any) {
    emailTextField.text = ""
}

@IBAction func tapSetVisibleButton(_ sender: Any) {
    if isSecureMode {
        pwSetVisibleButton.setImage(UIImage(named: "eyeVisible"), for: .normal)
        pwTextField.isSecureTextEntry = true
    } else {
        pwSetVisibleButton.setImage(UIImage(named: "eyeInvisible"), for: .normal)
        pwTextField.isSecureTextEntry = false
    }
    isSecureMode = !isSecureMode
}

@IBAction func tapAutoLoginButton(_ sender: Any) {
    if isAutoLoginMode{
        autoLoginButton.setImage(UIImage(named: "check_circle"), for: .normal)
    } else {
        autoLoginButton.setImage(UIImage(named: "check_circle_filled"), for: .normal)
    }
    isAutoLoginMode = !isAutoLoginMode
}
}


