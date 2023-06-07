//
//  FindPasswordViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/12.
//

import UIKit

class FindPasswordViewController: UIViewController {

    private var separatorView: UIView?
    
    private let titleLabel: UIStackView = {
        let imageView = UIImageView(image: UIImage(named: "sms")?.resize(to: CGSize(width: 18, height: 18)))
        let label = UILabel()
        label.text = "안내드려요"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.alignment = .center
        stackView.spacing = 5

        return stackView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "입한 이메일 주소를 입력해주세요.\n해당 이메일로 비밀번호 재설정을 위한 링크를 보내드립니다."
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)
        
        let underlineView = UIView()
        underlineView.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        label.addSubview(underlineView)

        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(label.snp.bottom).offset(27)
            make.leading.equalTo(label.snp.leading)
            make.trailing.equalTo(label.snp.trailing)
        }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        
//        let attributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
//            .foregroundColor: UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
//        ]
//        let attributedPlaceholder = NSAttributedString(string: "이메일 입력", attributes: attributes)
//        textField.attributedPlaceholder = attributedPlaceholder
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.borderStyle = .none
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 0.817, green: 0.817, blue: 0.817, alpha: 1).cgColor
        
        textField.layer.cornerRadius = 8
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "유효한 이메일이 아닙니다."
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let findPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        findPasswordButton.addTarget(self, action: #selector(findButtonTapped), for: .touchUpInside)
    
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        separatorView?.removeFromSuperview()
        separatorView = nil
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            self.view.endEditing(true)
    }

    private func setupUI() {
        separatorView = UIView(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: 1))
        separatorView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        navigationController?.navigationBar.addSubview(separatorView!)
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)
        
        let font = UIFont.systemFont(ofSize: 16, weight: .bold)
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.black]
        let title = "비밀번호 찾기"
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationItem.title = title
        
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
            findPassword(email: email)
        }
    }
    
//    func isValidEmail(_ email: String) -> Bool {
//        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
//        return emailPredicate.evaluate(with: email)
//    }
}

extension FindPasswordViewController {
    
    func findPassword(email: String) {
        UserService.shared.findPassword(email: email) {
            response in
            switch response {
            case .success(let data):
                if let json = data as? [String: Any],
                   let resultCode = json["resultCode"] as? Int {
                    if resultCode == 200 {
                        print("이백")
                        self.errorLabel.isHidden = true
                        
                        let dimmingView = UIView(frame: UIScreen.main.bounds)
                        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                        dimmingView.alpha = 0
                        self.view.addSubview(dimmingView)
                                                
                        let popupView = CustomPopupView(title: "메일 발송 완료", message: "재설정한 비밀번호로\n로그인 해주세요.", buttonText: "로그인", dimmingView: dimmingView)
                        popupView.alpha = 0
                        self.view.addSubview(popupView)
                        
                        UIView.animate(withDuration: 0.3) {
                            popupView.alpha = 1
                            dimmingView.alpha = 1
                        }

                        popupView.snp.makeConstraints { make in
                            make.center.equalToSuperview()
                            make.width.equalTo(264)
                            make.height.equalTo(167)
                        }
                    } else if resultCode == 500 {
                        print("오백")
                        self.errorLabel.isHidden = false
                    }
                }
            case .failure(_):
                print("FUCKING fail")
            }
        }
    }
}
