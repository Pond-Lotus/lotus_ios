//
//  ViewController.swift
//  ToDo
//
//  Created by KDS on 2023/01/16.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.clearButtonMode = .whileEditing
//        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 다시 돌아왔을 때 입력칸 지워야함
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    
    @IBAction func logInTapped(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            loginCheck(email: email, password: password)
        }
    }
    

    @IBAction func signUpTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(identifier: "EnterEmailViewController") // Storyboard ID
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.show(viewController, sender: nil)
    }
}

extension LogInViewController {
    
    func loginCheck(email: String, password: String) {
        UserService.shared.login(email: email, password: password) {
            response in
            print(response)
            switch response {
            case .success(let data):
                guard let data = data as? LoginResponse else { return }

                if data.resultCode == 200 {
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let viewController = storyboard.instantiateViewController(identifier: "ListViewController") // Storyboard ID
                    viewController.modalPresentationStyle = .fullScreen
                    self.navigationController?.show(viewController, sender: nil)
                } else if data.resultCode == 500 {
                    self.alertLoginFail(message: "로그인 실패")
                } else
                {
                    self.alertLoginFail(message: "fuck you")
                }
            case .requestErr(let err):
                print(err)
                self.alertLoginFail(message: "이메일체크 실패")
            case .pathErr:
                print("pathErr")
                self.alertLoginFail(message: "이메일체크 실패")
            case .serverErr:
                print("serverErr")
                self.alertLoginFail(message: "이메일체크 실패")
            case .networkFail:
                print("networkFail")
                self.alertLoginFail(message: "이메일체크 실패")
            }
        }
    }
    
    func alertLoginFail(message:String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        present(alertVC,animated:true,completion: nil)
    }
}
