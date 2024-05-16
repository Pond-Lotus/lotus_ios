//
//  FindPasswordViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/12.
//

import UIKit

class FindPasswordViewController: UIViewController {
    private let titleLabel: UIStackView = StackViewManager.shared.getAccountTitleLabel(text: "안내드려요", color: UITraitCollection.current.userInterfaceStyle == .light ? .black : .white, filename: "sms",  resize: 18, spacing: 5)
    private let messageLabel: UILabel = LabelManager.shared.getMessageLabel(text: "가입한 이메일 주소를 입력해주세요.\n해당 이메일로 비밀번호 재설정을 위한 링크를 보내드립니다.", weight: .light, color: UITraitCollection.current.userInterfaceStyle == .light ? UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1) : UIColor(red: 0.906, green: 0.906, blue: 0.906, alpha: 1))
    private let emailLabel: UILabel = LabelManager.shared.getEditTitleLabel(text: "이메일")
    private let emailTextField: UITextField = TextFieldManager.shared.getFindPasswordTextField()
    private let errorLabel: UILabel = LabelManager.shared.getErrorLabel(text: "유효한 이메일이 아닙니다.")
    private let findPasswordButton: UIButton = ButtonManager.shared.getFinishButton(title: "비밀번호 찾기", false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.backgroundColor
        
        setupDelegate()
        setupUI()
        findPasswordButton.addTarget(self, action: #selector(findButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NavigationBarManager.shared.removeSeparatorView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    private func setupDelegate() {
        navigationController?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.emailTextField.delegate = self

    }
        
    private func setupUI() {
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction:  #selector(backButtonTapped), title: "비밀번호 찾기", showSeparator: true)
        
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(errorLabel)
        view.addSubview(findPasswordButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.15)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
            make.trailing.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.06)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(54)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(7)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(7)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }
        
        findPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(52)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func findButtonTapped() {
        if let email = emailTextField.text {
            findPasswordButton.isEnabled = false
            findPassword(email: email)
        }
    }
    
    func findPassword(email: String) {
        UserService.shared.findPassword(email: email) { [self] result in
            switch result {
            case .success(let response):
                self.findPasswordButton.isEnabled = true
                if response.resultCode == 200 {
                    print("이백")
                    self.errorLabel.isHidden = true
                    
                    let dimmingView = UIView(frame: UIScreen.main.bounds)
                    dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                    dimmingView.alpha = 0
                    self.view.addSubview(dimmingView)
                    let popupView = OneButtonPopupView(title: "메일 발송 완료", message: "재설정한 비밀번호로\n로그인 해주세요.", buttonText: "로그인", buttonColor: UIColor.mainColor, dimmingView: dimmingView)
                    popupView.delegate = self
                    popupView.alpha = 0
                    self.view.addSubview(popupView)
                    popupView.snp.makeConstraints { make in
                        make.center.equalToSuperview()
                        make.width.equalTo(264)
                        make.height.equalTo(167)
                    }
                    UIView.animate(withDuration: 0.2) {
                        popupView.alpha = 1
                        dimmingView.alpha = 1
                    }
                } else if response.resultCode == 500 {
                    print("오백")
                    self.errorLabel.isHidden = false
                }
            case .failure(_):
                print("failure")
                self.findPasswordButton.isEnabled = true
                self.errorLabel.isHidden = false
            }
        }
    }
}

extension FindPasswordViewController: OneButtonPopupViewDelegate {
    func buttonTappedDelegate() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension FindPasswordViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)

        if isValidEmail(newText) {
            self.findPasswordButton.backgroundColor = UIColor.buttonColor
            self.findPasswordButton.isEnabled = true
            self.findPasswordButton.setTitleColor(.black, for: .normal)
        } else {
            self.findPasswordButton.backgroundColor = UITraitCollection.current.userInterfaceStyle == .light ? UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1) : UIColor(red: 0.447, green: 0.447, blue: 0.447, alpha: 1)
            self.findPasswordButton.isEnabled = false
            self.findPasswordButton.setTitleColor(UITraitCollection.current.userInterfaceStyle == .light ? UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1) : UIColor(red: 0.259, green: 0.259, blue: 0.259, alpha: 1), for: .normal)
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension FindPasswordViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}

extension FindPasswordViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
