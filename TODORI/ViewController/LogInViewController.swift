//
//  LogInViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/01.
//

import UIKit
// import SnapKit 없어도 적용이 되는 이유?

class LogInViewController: UIViewController {

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo-image")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let logoTextView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo-text")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        ]
        let attributedPlaceholder = NSAttributedString(string: "이메일 입력", attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
        textField.layer.cornerRadius = 18
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        ]
        let attributedPlaceholder = NSAttributedString(string: "비밀번호 입력", attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        let passwordVisionButton = UIButton(type: .custom)
        passwordVisionButton.setImage(UIImage(named: "password-invision")?.resize(to: CGSize(width: 24, height: 24)), for: .normal)
        passwordVisionButton.addTarget(self, action: #selector(passwordVisionButtonTapped), for: .touchUpInside)
        passwordVisionButton.setImage(UIImage(named: "password-vision")?.resize(to: CGSize(width: 24, height: 24)), for: .selected)
        textField.rightView = passwordVisionButton
        textField.rightViewMode = .always
        
        textField.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
        textField.layer.cornerRadius = 18
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let autoLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle(" 자동 로그인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        // 1
        let image = UIImage(named: "tick-circle")?.resize(to: CGSize(width: 17, height: 17))
        button.setImage(image, for: .normal)
        
        // 2
        button.setImage(UIImage(named: "tick-circle2")?.resize(to: CGSize(width: 17, height: 17)), for: .selected)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1)
        button.layer.cornerRadius = 18
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let findPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원 가입", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        
//        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        autoLoginButton.addTarget(self, action: #selector(autoLoginTapped), for: .touchUpInside)
        
    }
    
    
    private func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(logoTextView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(autoLoginButton)
        view.addSubview(loginButton)
        view.addSubview(findPasswordButton)
        view.addSubview(signupButton)
        
        logoImageView.snp.makeConstraints { make in
            // 사이즈 비율?
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).multipliedBy(2)
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.15)
            make.centerX.equalToSuperview()
            make.width.equalTo(117)
            make.height.equalTo(117)
        }
        
        logoTextView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
            make.width.equalTo(103)
            make.height.equalTo(40)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(logoTextView.snp.bottom).offset(67)
            make.centerX.equalToSuperview()
            make.width.equalTo(308)
            make.height.equalTo(54)
        }   
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(308)
            make.height.equalTo(54)
        }
        
        autoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.leading.equalTo(loginButton.snp.leading).offset(0)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(65)
            make.centerX.equalToSuperview()
            make.width.equalTo(308)
            make.height.equalTo(49)
        }
        
        findPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(13)
            make.leading.equalTo(loginButton.snp.leading).offset(0)
        }
        
        signupButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(13)
            make.trailing.equalTo(loginButton.snp.trailing).offset(0)
        }
    }
    
    @objc private func signupTapped() {
        let viewControllerToPresent = EnterEmailViewController() // 이동할 뷰 컨트롤러 인스턴스 생성
        viewControllerToPresent.modalPresentationStyle = .fullScreen // 화면 전체를 차지하도록 설정
//        viewControllerToPresent.modalTransitionStyle = .coverVertical // coverHorizontal 스타일 적용

        present(viewControllerToPresent, animated: true, completion: nil) // 뷰 컨트롤러 이동

    }
    
    @objc func autoLoginTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @objc func passwordVisionButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTextField.isSecureTextEntry = !sender.isSelected
    }
}

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
