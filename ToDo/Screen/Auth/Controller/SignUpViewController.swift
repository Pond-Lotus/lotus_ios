//
//  SignInViewController.swift
//  ToDo
//
//  Created by KDS on 2023/01/16.
//

import UIKit


class SignUpViewController: UIViewController {
    
    var originEmail: String?
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.text = originEmail
    }
    
    @IBAction func nextButton(_ sender: Any) {
        let password = passwordTextField.text ?? ""
        let passwordCheck = passwordCheckTextField.text ?? ""
        
        if password == passwordCheck {
            self.errorMessageLabel.text = ""
            
            if let nickName = nickNameTextField.text, let password = passwordTextField.text {
                signUp(email: originEmail!, nickname: nickName, password: password)
            }
        } else {
            self.errorMessageLabel.text = "비밀번호가 일치하지 않습니다."
        }
    }
}

extension SignUpViewController {
    
    func signUp(email: String, nickname: String, password: String) {
        UserService.shared.signup(email: email, nickname: nickname, password: password) {
            response in
            switch response {
            case .success(let data):
                guard let data = data as? SignupResponse else { return }
                
                if data.resultCode == 200 {
                    guard let goToNextController = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else { return }
                    self.navigationController?.pushViewController(goToNextController, animated: true)
                } else if data.resultCode == 500 {
                    self.alertLoginFail(message: "resultCode : 500")
                }
                
            case .requestErr(let err):
                print(err)
                self.alertLoginFail(message: "코드체크 실패")
            case .pathErr:
                print("pathErr")
                self.alertLoginFail(message: "코드체크 실패")
            case .serverErr:
                print("serverErr")
                self.alertLoginFail(message: "코드체크 실패")
            case .networkFail:
                print("networkFail")
                self.alertLoginFail(message: "코드체크 실패")
            }
        }
    }
    
    func alertLoginFail(message:String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        present(alertVC,animated:true,completion: nil)
    }
    
    func alertLogin(message: String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "확인", style: .default){
//            action in
//            let sb = UIStoryboard.init(name: "MainViewController", bundle: nil)
//            guard let mainVC = sb.instantiateViewController(withIdentifier: "MainViewController") as? UITabBarController else {return}
//            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(mainVC, animated: false)
//        }
//        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}
