//
//  EnterEmailViewController.swift
//  ToDo
//
//  Created by KDS on 2023/01/17.
//

import UIKit

class EnterEmailViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if let email = emailTextField.text {
            emailCheck(email: email)
        }
    }
}

extension EnterEmailViewController {
    
    func emailCheck(email: String) {
        UserService.shared.emailCheck(email: email) {
            response in
            switch response {
            case .success(let data):
                guard let data = data as? SignupResponse else { return }
                print(data.resultCode)
                if data.resultCode == 200 {
                    guard let goToNextController = self.storyboard?.instantiateViewController(withIdentifier: "EnterCodeViewController") as? EnterCodeViewController else { return }
                    goToNextController.originEmail = self.emailTextField.text
                    self.navigationController?.pushViewController(goToNextController, animated: true)
                } else if data.resultCode == 500 {
                    self.alertLoginFail(message: "이메일 중복")
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
    
    func alertLoginFail(message: String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        present(alertVC,animated:true,completion: nil)
    }
    
    func alertLogin(message: String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default){
            action in
            let sb = UIStoryboard.init(name: "MainViewController", bundle: nil)
            guard let mainVC = sb.instantiateViewController(withIdentifier: "MainViewController") as? UITabBarController else {return}
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(mainVC, animated: false)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}
