//
//  EnterProfileViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/02.
//

import UIKit

class EnterProfileViewController: UIViewController {
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "3/3"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "프로필을\n설정해 주세요"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailBoxLabel: UILabel = {
        let label = UILabel()
        if let email = UserSession.shared.signUpEmail {
            label.text = "   " + email
        }
        label.textAlignment = .left
        label.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nickNameTextField: UITextField = {
        let textField = UITextField()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .regular),
            .foregroundColor: UIColor(red: 0.837, green: 0.837, blue: 0.837, alpha: 1)
        ]
        let attributedPlaceholder = NSAttributedString(string: "2~6자 이하로 입력해 주세요", attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        let underlineView = UIView()
        underlineView.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        textField.addSubview(underlineView)
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1.5)
            make.top.equalTo(textField.snp.bottom).offset(7)
            make.leading.trailing.equalTo(textField)
        }
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let nickNameGenerationErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임 생성 규칙에 맞지 않습니다."
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .regular),
            .foregroundColor: UIColor(red: 0.837, green: 0.837, blue: 0.837, alpha: 1)
        ]
        let attributedPlaceholder = NSAttributedString(string: "8~15자 이내의 영문자, 숫자, 특수문자를 포함해 주세요", attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        let underlineView = UIView()
        underlineView.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        textField.addSubview(underlineView)
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1.5)
            make.top.equalTo(textField.snp.bottom).offset(7)
            make.leading.trailing.equalTo(textField)
        }
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordGenerationErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 생성 규칙에 맞지 않습니다."
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let checkPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkPasswordTextField: UITextField = {
        let textField = UITextField()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .regular),
            .foregroundColor: UIColor(red: 0.837, green: 0.837, blue: 0.837, alpha: 1)
        ]
        let attributedPlaceholder = NSAttributedString(string: "8~15자 이내의 영문자, 숫자, 특수문자를 포함해 주세요", attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder

        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        let underlineView = UIView()
        underlineView.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        textField.addSubview(underlineView)
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1.5)
            make.top.equalTo(textField.snp.bottom).offset(7)
            make.leading.trailing.equalTo(textField)
        }
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordInconsistencyErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호가 일치하지 않습니다."
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "next-button")?.resize(to: CGSize(width: 43, height: 43))
        button.setImage(image, for: .normal)
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        nickNameTextField.delegate = self
        passwordTextField.delegate = self
        checkPasswordTextField.delegate = self
        
        setupUI()
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            self.view.endEditing(true)
    }
    
    private func setupUI() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)

        let stackView = UIStackView(arrangedSubviews: [nickNameLabel, nickNameTextField, nickNameGenerationErrorLabel, passwordLabel, passwordTextField, passwordGenerationErrorLabel, checkPasswordLabel, checkPasswordTextField, passwordInconsistencyErrorLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        
        if let index = stackView.arrangedSubviews.firstIndex(of: nickNameGenerationErrorLabel) {
            stackView.setCustomSpacing(18, after: stackView.arrangedSubviews[index - 1])
        }
        
        if let index = stackView.arrangedSubviews.firstIndex(of: passwordLabel) {
            stackView.setCustomSpacing(20, after: stackView.arrangedSubviews[index - 1])
        }

        if let index = stackView.arrangedSubviews.firstIndex(of: passwordLabel) {
            stackView.setCustomSpacing(20, after: stackView.arrangedSubviews[index - 2])
        }
        
        if let index = stackView.arrangedSubviews.firstIndex(of: passwordGenerationErrorLabel) {
            stackView.setCustomSpacing(18, after: stackView.arrangedSubviews[index - 1])
        }
        
        if let index = stackView.arrangedSubviews.firstIndex(of: checkPasswordLabel) {
            stackView.setCustomSpacing(20, after: stackView.arrangedSubviews[index - 1])
        }
        
        if let index = stackView.arrangedSubviews.firstIndex(of: checkPasswordLabel) {
            stackView.setCustomSpacing(20, after: stackView.arrangedSubviews[index - 2])
        }
        
        if let index = stackView.arrangedSubviews.firstIndex(of: checkPasswordLabel) {
            stackView.setCustomSpacing(20, after: stackView.arrangedSubviews[index - 2])
        }
        
        if let index = stackView.arrangedSubviews.firstIndex(of: passwordInconsistencyErrorLabel) {
            stackView.setCustomSpacing(18, after: stackView.arrangedSubviews[index - 1])
        }

        view.addSubview(numberLabel)
        view.addSubview(titleLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailBoxLabel)
        view.addSubview(stackView)
        view.addSubview(nextButton)
        
        numberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.15)
            make.leading.equalToSuperview().offset(25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(25)
        }

        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(25)
        }

        emailBoxLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(41)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(emailBoxLabel.snp.bottom).offset(18)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24)
            make.trailing.equalToSuperview().offset(-21)
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonTapped() {
        if let nickname = nickNameTextField.text, let password = passwordTextField.text {
            if isValidNickName(nickname) {
                nickNameGenerationErrorLabel.isHidden = true
                UserSession.shared.nickname = nickname
            } else {
                nickNameGenerationErrorLabel.isHidden = false
            }
            
            if isValidPassword(password) {
                passwordGenerationErrorLabel.isHidden = true
            } else {
                passwordGenerationErrorLabel.isHidden = false
            }
            
            if passwordTextField.text == checkPasswordTextField.text {
                passwordInconsistencyErrorLabel.isHidden = true
            } else {
                passwordInconsistencyErrorLabel.isHidden = false
            }
            
            if isValidNickName(nickname) && isValidPassword(password) && passwordTextField.text == checkPasswordTextField.text {
                if let email = UserSession.shared.signUpEmail {
                    register(nickname: nickname, email: email, password: password)
                    print("다음 OK")
                }
            } else {
                print("다음 NO")
            }

        }
    }
    
    func isValidNickName(_ nickname: String) -> Bool {
        if let nickname = nickNameTextField.text, (2...6).contains(nickname.count) {
            return true
        } else {
            return false
        }
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[$@$#!%*?&])[A-Za-z[0-9]$@$#!%*?&]{8,15}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        
        return passwordPredicate.evaluate(with: password)
    }
}

extension EnterProfileViewController {
    
    func register(nickname: String, email: String, password: String) {
        UserService.shared.register(nickname:nickname, email: email, password: password) {
            response in
            switch response {
            case .success(let data):
                if let json = data as? [String: Any],
                   let resultCode = json["resultCode"] as? Int {

                    if resultCode == 200 {
                        print("이백")
                        
                        self.navigationController?.modalPresentationStyle = .fullScreen
                        self.navigationController?.pushViewController(FinishSignUpViewController(), animated: true)
                        
//                        let viewControllerToPresent = FinishSignUpViewController() // 이동할 뷰 컨트롤러 인스턴스 생성
//                        viewControllerToPresent.modalPresentationStyle = .fullScreen // 화면 전체를 차지하도록 설정
//                        viewControllerToPresent.modalTransitionStyle = .coverVertical // coverHorizontal 스타일 적용
//                        self.present(viewControllerToPresent, animated: true, completion: nil) // 뷰 컨트롤러 이동
                    } else if resultCode == 500 {
                        print("오백")
                    }
                }
            case .failure:
                print("FUCKING fail")
            }
        }
    }
}

extension EnterProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nickNameTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            checkPasswordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
