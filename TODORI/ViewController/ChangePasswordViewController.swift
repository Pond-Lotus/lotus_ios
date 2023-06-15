//
//  ChangePasswordViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/15.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    var stackView = UIStackView()
    
    private let presentPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 비밀번호"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let presentPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.borderStyle = .none
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 0.817, green: 0.817, blue: 0.817, alpha: 1).cgColor
        textField.layer.cornerRadius = 8
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        return textField
    }()
    
    private let presentPasswordErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 비밀번호와 일치하지 않습니다."
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1)
        label.isHidden = true
        return label
    }()
    
    private let newPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "새 비밀번호"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let newPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 1
        textField.isSecureTextEntry = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.borderStyle = .none
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 0.817, green: 0.817, blue: 0.817, alpha: 1).cgColor
        textField.layer.cornerRadius = 8
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        return textField
    }()
    
    private let newPasswordErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 생성 규칙에 맞지 않습니다."
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1)
        label.isHidden = true
        return label
    }()
    
    private let checkNewPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "새 비밀번호 확인"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let checkNewPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 2
        textField.isSecureTextEntry = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.borderStyle = .none
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 0.817, green: 0.817, blue: 0.817, alpha: 1).cgColor
        textField.layer.cornerRadius = 8
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        return textField
    }()
    
    private let checkNewPasswordErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "새 비밀번호가 일치하지 않습니다."
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1)
        label.isHidden = true
        return label
    }()
    
    private let finishButton: UIButton = {
        let button = UIButton()
        button.setTitle("변경 완료", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        navigationController?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        presentPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        checkNewPasswordTextField.delegate = self
        
        finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    private func setupUI() {
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction:  #selector(backButtonTapped), title: "비밀번호 변경", showSeparator: false)
        
        stackView = UIStackView(arrangedSubviews: [presentPasswordLabel, presentPasswordTextField, presentPasswordErrorLabel, newPasswordLabel, newPasswordTextField, newPasswordErrorLabel, checkNewPasswordLabel, checkNewPasswordTextField, checkNewPasswordErrorLabel])
        stackView.axis = .vertical
        stackView.setCustomSpacing(10, after: presentPasswordLabel)
        stackView.setCustomSpacing(20, after: presentPasswordTextField)
        stackView.setCustomSpacing(10, after: newPasswordLabel)
        stackView.setCustomSpacing(20, after: newPasswordTextField)
        stackView.setCustomSpacing(10, after: checkNewPasswordLabel)
        stackView.setCustomSpacing(20, after: checkNewPasswordTextField)
        
        view.addSubview(stackView)
        view.addSubview(finishButton)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(47)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        finishButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(52)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func finishButtonTapped() {
        if let password = presentPasswordTextField.text, let newPassword = newPasswordTextField.text {
            if isValidPassword(newPassword) && newPassword == checkNewPasswordTextField.text {
                finishButton.isEnabled = false
                changePassword(originPassword: password, newPassword: newPassword)
            }
        }
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[$@$#!%*?&/])[A-Za-z[0-9]$@$#!%*?&/]{8,15}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        switch textField.tag {
        case 1:
            if isValidPassword(newText) {
                stackView.setCustomSpacing(20, after: newPasswordTextField)
                newPasswordErrorLabel.isHidden = true
            } else {
                stackView.setCustomSpacing(8, after: newPasswordTextField)
                stackView.setCustomSpacing(16, after: newPasswordErrorLabel)
                newPasswordErrorLabel.isHidden = false
                finishButton.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
            }
        case 2:
            if newText == newPasswordTextField.text {
                checkNewPasswordErrorLabel.isHidden = true
                if isValidPassword(newText) {
                    finishButton.backgroundColor = UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1)
                    finishButton.isEnabled = true
                } else {
                    finishButton.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
                }
            } else {
                stackView.setCustomSpacing(8, after: checkNewPasswordTextField)
                checkNewPasswordErrorLabel.isHidden = false
                finishButton.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
            }
        default:
            break
        }
        return true
    }
}

extension ChangePasswordViewController {
    func changePassword(originPassword: String, newPassword: String) {
        UserService.shared.changePassword(originPassword: originPassword, newPassword: newPassword) { result in
            switch result {
            case .success(let response):
                self.finishButton.isEnabled = true
                if response.resultCode == 200 {
                    print("이백")
                    self.stackView.setCustomSpacing(20, after: self.presentPasswordTextField)
                    self.presentPasswordErrorLabel.isHidden = true
                    
                    let dimmingView = UIView(frame: UIScreen.main.bounds)
                    dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                    dimmingView.alpha = 0
                    self.view.addSubview(dimmingView)
                    
                    let popupView = CustomPopupView(title: "비밀번호 변경", message: "비밀번호 변경이 완료되었습니다.", buttonText: "확인", buttonColor: UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1), dimmingView: dimmingView)
                    popupView.delegate = self
                    popupView.alpha = 0
                    self.view.addSubview(popupView)
                    popupView.snp.makeConstraints { make in
                        make.center.equalToSuperview()
                        make.width.equalTo(264)
                        make.height.equalTo(167)
                    }
                    UIView.animate(withDuration: 0.3) {
                        popupView.alpha = 1
                        dimmingView.alpha = 1
                    }
                } else if response.resultCode == 500 {
                    print("오백")
                    self.presentPasswordErrorLabel.isHidden = false
                    self.stackView.setCustomSpacing(8, after: self.presentPasswordTextField)
                    self.stackView.setCustomSpacing(16, after: self.presentPasswordErrorLabel)
                }
            case .failure:
                print("failure")
            }
        }
    }
}

extension ChangePasswordViewController: CustomPopupViewDelegate {
    func buttonTappedDelegate() {
        NavigationBarManager.shared.removeSeparatorView()
        SceneDelegate.reset()
    }
}

extension ChangePasswordViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}

extension ChangePasswordViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
