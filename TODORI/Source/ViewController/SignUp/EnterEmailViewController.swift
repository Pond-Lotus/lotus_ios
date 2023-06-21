//
//  EnterEmailViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/01.
//

import UIKit

class EnterEmailViewController: UIViewController {
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "1/3"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "이메일을\n입력해 주세요"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        return label
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .light),
            .foregroundColor: UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
        ]
        let attributedPlaceholder = NSAttributedString(string: "example@todori.com", attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder

        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        let underlineView = UIView()
        underlineView.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        textField.addSubview(underlineView)
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1.5)
            make.top.equalTo(textField.snp.bottom).offset(7)
            make.leading.equalTo(textField.snp.leading)
            make.trailing.equalTo(textField.snp.trailing)
        }
        return textField
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "이미 존재하는 이메일입니다."
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1)
        label.isHidden = true
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = ButtonManager.shared.getNextButton()
        button.isEnabled = false
        button.alpha = 0.75
        return button
    }()
    
    private let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .large)
        return indicatorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        emailTextField.delegate = self
        navigationController?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    private func setupUI() {
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction: #selector(backButtonTapped), title: "", showSeparator: false)

        view.addSubview(numberLabel)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(errorLabel)
        view.addSubview(nextButton)
        view.addSubview(indicatorView)

        numberLabel.snp.makeConstraints { make in
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let topSafeAreaHeight = windowScene.windows.first?.safeAreaInsets.top,
               let navigationBarHeight = navigationController?.navigationBar.frame.height {
                let totalHeight = topSafeAreaHeight + navigationBarHeight
                make.top.equalToSuperview().offset(totalHeight + 40)
            }
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
            make.trailing.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.06)
        }

        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }

        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.04)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonTapped() {
        if let email = emailTextField.text {
            nextButton.isEnabled = false
            indicatorView.startAnimating()
            emailCheck(email: email)
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

extension EnterEmailViewController {
    func emailCheck(email: String) {
        UserService.shared.emailCheck(email: email) { result in
            switch result {
            case .success(let data):
                self.indicatorView.stopAnimating()
                self.nextButton.isEnabled = true
                if data.resultCode == 200 {
                    print("이백")
                    self.errorLabel.isHidden = true
                    
                    if let email = self.emailTextField.text {
                        UserSession.shared.signUpEmail = email
                    }
                    
                    self.navigationController?.pushViewController(EnterCodeViewController(), animated: true)
                }
                else if data.resultCode == 500 {
                    print("오백")
                    self.errorLabel.isHidden = false
                }
            case .failure:
                print("failure")
                self.errorLabel.isHidden = false
            }
        }
    }
}

extension EnterEmailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if isValidEmail(newText) {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "email-check")?.resize(to: CGSize(width: 28, height: 28))
            imageView.contentMode = .scaleAspectFit
            textField.rightView = imageView
            textField.rightViewMode = .always
            
            nextButton.isEnabled = true
            nextButton.alpha = 1
        } else {
            textField.rightView = nil
            textField.rightViewMode = .never
            
            nextButton.isEnabled = false
            nextButton.alpha = 0.7
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EnterEmailViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}

extension EnterEmailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
