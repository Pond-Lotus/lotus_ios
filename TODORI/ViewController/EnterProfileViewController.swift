//
//  EnterProfileViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/02.
//

import UIKit

class EnterProfileViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var stackView: UIStackView = {
        var stackView = UIStackView()
        return stackView
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "3/3"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "프로필을\n설정해 주세요"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)
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
        return label
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)
        return label
    }()
    
    private let nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 1
        
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
        textField.addSubview(underlineView)
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1.5)
            make.top.equalTo(textField.snp.bottom).offset(7)
            make.leading.trailing.equalTo(textField)
        }
        return textField
    }()
    
    private let nickNameGenerationErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임 생성 규칙에 맞지 않습니다."
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1)
        label.isHidden = true
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 2
        
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
        textField.addSubview(underlineView)
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1.5)
            make.top.equalTo(textField.snp.bottom).offset(7)
            make.leading.trailing.equalTo(textField)
        }
        return textField
    }()
    
    private let passwordGenerationErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 생성 규칙에 맞지 않습니다."
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1)
        label.isHidden = true
        return label
    }()
    
    private let checkPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)
        return label
    }()
    
    private let checkPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 3
        
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
        textField.addSubview(underlineView)
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1.5)
            make.top.equalTo(textField.snp.bottom).offset(7)
            make.leading.trailing.equalTo(textField)
        }
        return textField
    }()
    
    private let passwordInconsistencyErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호가 일치하지 않습니다."
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1)
        label.isHidden = true
        return label
    }()
    
    private let nextButton: UIButton = {
        return ButtonManager.shared.getNextButton()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        scrollView.delegate = self
        nickNameTextField.delegate = self
        passwordTextField.delegate = self
        checkPasswordTextField.delegate = self
        navigationController?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        setupTapGesture()
        setupUI()
                
        registerKeyboardNotifications()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    private func setupUI() {
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction: #selector(backButtonTapped), title: "", showSeparator: false)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = .white
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let topSafeAreaHeight = windowScene.windows.first?.safeAreaInsets.top,
               let navigationBarHeight = navigationController?.navigationBar.frame.height {
                let totalHeight = topSafeAreaHeight + navigationBarHeight
                make.height.equalTo(UIScreen.main.bounds.height - totalHeight)
            }
        }
        
        stackView = UIStackView(arrangedSubviews: [nickNameLabel, nickNameTextField, nickNameGenerationErrorLabel, passwordLabel, passwordTextField, passwordGenerationErrorLabel, checkPasswordLabel, checkPasswordTextField, passwordInconsistencyErrorLabel])
        stackView.axis = .vertical
        stackView.setCustomSpacing(10, after: nickNameLabel)
        stackView.setCustomSpacing(30, after: nickNameTextField)
        stackView.setCustomSpacing(20, after: nickNameGenerationErrorLabel)
        stackView.setCustomSpacing(10, after: passwordLabel)
        stackView.setCustomSpacing(30, after: passwordTextField)
        stackView.setCustomSpacing(20, after: passwordGenerationErrorLabel)
        stackView.setCustomSpacing(10, after: checkPasswordLabel)
        
        contentView.addSubview(numberLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailBoxLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(nextButton)
        
        numberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }
        
        emailBoxLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
            make.trailing.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.06)
            make.height.equalTo(41)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(emailBoxLabel.snp.bottom).offset(18)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
            make.trailing.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.06)
        }
        
        nextButton.snp.makeConstraints { make in
            let width = scrollView.frame.width - contentView.frame.width
            make.trailing.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.04 + width)
            make.bottom.equalToSuperview().offset(-UIScreen.main.bounds.height * 0.02)
        }
    }
    
    @objc func scrollViewTapped() {
        scrollView.endEditing(true)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonTapped() {
        if let nickname = nickNameTextField.text, let password = passwordTextField.text {
            if isValidNickName(nickname) && isValidPassword(password) && passwordTextField.text == checkPasswordTextField.text {
                if let email = UserSession.shared.signUpEmail {
                    register(nickname: nickname, email: email, password: password)
                }
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
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[$@$#!%*?&/])[A-Za-z[0-9]$@$#!%*?&/]{8,15}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    // MARK: - Keyboard Handling
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}

extension EnterProfileViewController {
    func register(nickname: String, email: String, password: String) {
        UserService.shared.register(nickname:nickname, email: email, password: password) { response in
            switch response {
            case .success(let data):
                self.nextButton.isEnabled = true
                if data.resultCode == 200 {
                    print("이백")
                    self.navigationController?.pushViewController(FinishSignUpViewController(), animated: true)
                } else if data.resultCode == 500 {
                    print("오백")
                }
            case .failure:
                print("failure")
                self.nextButton.isEnabled = true
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
        case checkPasswordTextField:
            textField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 1 {
            if let updatedText = textField.text {
                if isValidNickName(updatedText) {
                    stackView.setCustomSpacing(30, after: nickNameTextField)
                    nickNameGenerationErrorLabel.isHidden = true
                } else {
                    stackView.setCustomSpacing(15, after: nickNameTextField)
                    nickNameGenerationErrorLabel.isHidden = false
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        switch textField.tag {
        case 2:
            if isValidPassword(newText) {
                stackView.setCustomSpacing(30, after: passwordTextField)
                passwordGenerationErrorLabel.isHidden = true
            } else {
                stackView.setCustomSpacing(15, after: passwordTextField)
                passwordGenerationErrorLabel.isHidden = false
            }
        case 3:
            if newText == passwordTextField.text {
                stackView.setCustomSpacing(30, after: checkPasswordTextField)
                passwordInconsistencyErrorLabel.isHidden = true
            } else {
                stackView.setCustomSpacing(15, after: checkPasswordTextField)
                passwordInconsistencyErrorLabel.isHidden = false
            }
        default:
            break
        }
        return true
    }
}

extension EnterProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let navigationBar = navigationController?.navigationBar

        let maxOffsetY = UIScreen.main.bounds.height * 0.15
        let alpha = 1 - min(1, max(0, offsetY / maxOffsetY))
        navigationBar?.alpha = alpha
    }
}

extension EnterProfileViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}

extension EnterProfileViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
