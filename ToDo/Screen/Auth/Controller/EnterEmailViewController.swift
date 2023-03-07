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
        
        self.emailTextField.borderStyle = .none
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: emailTextField.frame.height, width: emailTextField.frame.width, height: 0.8)
        bottomLayer.backgroundColor = UIColor.gray.cgColor
        emailTextField.layer.addSublayer(bottomLayer)
//        self.view.addSubview(self.emailTextField)
//        self.emailTextField.translatesAutoresizingMaskIntoConstraints = false
//        self.emailTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
//        self.emailTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
//        self.emailTextField.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -522).isActive = true
        
        self.nextButton.layer.masksToBounds = true
        self.nextButton.layer.cornerRadius = 18
        self.view.addSubview(self.nextButton)
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.widthAnchor.constraint(equalToConstant: 77).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
        self.nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -21).isActive = true
        self.nextButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        
        self.navigationItem.hidesBackButton = true
        
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
