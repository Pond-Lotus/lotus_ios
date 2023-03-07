//
//  ViewController.swift
//  ToDo
//
//  Created by KDS on 2023/01/16.
//

import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoTitleImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var autoLogInButton: UIButton!
    @IBOutlet weak var findUserInformationButton: UIButton!
    
    var token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(logoImageView)
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false // AutoLayout 적용
        logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 145).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.view.addSubview(logoTitleImageView)
        self.logoTitleImageView.translatesAutoresizingMaskIntoConstraints = false // AutoLayout 적용
        logoTitleImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 255).isActive = true
        logoTitleImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        
        emailTextField.clearButtonMode = .whileEditing
        passwordTextField.clearButtonMode = .whileEditing

        emailTextField.layer.masksToBounds = true // 충족해야 radius 적용
        passwordTextField.layer.masksToBounds = true
        emailTextField.layer.cornerRadius = 18
        passwordTextField.layer.cornerRadius = 18
        
        emailTextField.font = .systemFont(ofSize:16)
        passwordTextField.font = .systemFont(ofSize:16)
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: " 이메일 입력", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: " 비밀번호 입력", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)])
        
        emailTextField.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
        passwordTextField.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
        
        self.view.addSubview(emailTextField)
        self.emailTextField.translatesAutoresizingMaskIntoConstraints = false // AutoLayout 적용
        emailTextField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        emailTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 349).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 41).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -41).isActive = true
        
        self.view.addSubview(passwordTextField)
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false // AutoLayout 적용
        passwordTextField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 408).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 41).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -41).isActive = true

        self.view.addSubview(autoLogInButton)
        self.autoLogInButton.translatesAutoresizingMaskIntoConstraints = false
        autoLogInButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 472).isActive = true
        autoLogInButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 41).isActive = true
        
        logInButton.layer.cornerRadius = 18
        logInButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        logInButton.titleLabel?.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
        logInButton.titleLabel?.textColor = .black
        self.view.addSubview(logInButton)
        self.logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logInButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -269).isActive = true
        logInButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 41).isActive = true
        logInButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -41).isActive = true
        
        signUpButton.setTitleColor(UIColor(red: 0.302, green: 0.302, blue: 0.302, alpha: 1), for: .normal)
        signUpButton.setTitleColor(UIColor(red: 0.302, green: 0.302, blue: 0.302, alpha: 0.5), for: .highlighted)
        self.view.addSubview(signUpButton)
        self.signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        signUpButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -239).isActive = true
        
        
        let emailPasswordFindButton: UIButton = .init(frame: .init())
        emailPasswordFindButton.setTitle("이메일 / 비밀번호 찾기", for: .normal)
        emailPasswordFindButton.setTitleColor(UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1), for: .normal)
        emailPasswordFindButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        self.view.addSubview(emailPasswordFindButton)
        emailPasswordFindButton.translatesAutoresizingMaskIntoConstraints = false
        emailPasswordFindButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        emailPasswordFindButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 42).isActive = true
        emailPasswordFindButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -239).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            loginCheck(email: email, password: password)
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        // navigation controller
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let viewController = storyboard.instantiateViewController(identifier: "EnterEmailViewController") // Storyboard ID
//        viewController.modalPresentationStyle = .fullScreen
//        navigationController?.show(viewController, sender: nil)
        
        guard let goToNextController = self.storyboard?.instantiateViewController(withIdentifier: "EnterEmailViewController") as? EnterEmailViewController else { return }
        self.navigationController?.pushViewController(goToNextController, animated: true)
    }
    
    func saveToken() {
        let data = self.token
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "myToken")
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
                    self.token = data.token
                    self.saveToken()
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let viewController = storyboard.instantiateViewController(identifier: "ListViewController") // Storyboard ID
                    viewController.modalPresentationStyle = .fullScreen
                    self.navigationController?.show(viewController, sender: nil)
                } else if data.resultCode == 500 {
                    self.alertLoginFail(message: "로그인 실패")
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
    
    func alertLoginFail(message:String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        present(alertVC,animated:true,completion: nil)
    }
}
