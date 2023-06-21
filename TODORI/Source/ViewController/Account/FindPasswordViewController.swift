//
//  FindPasswordViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/12.
//

import UIKit

class FindPasswordViewController: UIViewController {
    private let titleLabel: UIStackView = {
        let imageView = UIImageView(image: UIImage(named: "sms")?.resize(to: CGSize(width: 18, height: 18)))
        let label = UILabel()
        label.text = "안내드려요"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.spacing = 5
        return stackView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "가입한 이메일 주소를 입력해주세요.\n해당 이메일로 비밀번호 재설정을 위한 링크를 보내드립니다."
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)
        
        let underlineView = UIView()
        underlineView.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        label.addSubview(underlineView)
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(label.snp.bottom).offset(27)
            make.leading.equalTo(label.snp.leading)
            make.trailing.equalTo(label.snp.trailing)
        }
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 0.817, green: 0.817, blue: 0.817, alpha: 1).cgColor
        textField.layer.cornerRadius = 8
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "유효한 이메일이 아닙니다."
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1)
        label.isHidden = true
        return label
    }()
    
    private let findPasswordButton: UIButton = {
        let button = UIButton()
        button.applyColorAnimation()
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        navigationController?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        findPasswordButton.addTarget(self, action: #selector(findButtonTapped), for: .touchUpInside)
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NavigationBarManager.shared.removeSeparatorView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
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
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func findButtonTapped() {
        if let email = emailTextField.text {
            findPasswordButton.isEnabled = false
            findPassword(email: email)
        }
    }
}

extension FindPasswordViewController {
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
