//
//  LogInViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/01.
//

import UIKit
// import SnapKit 없어도 적용이 되는 이유?

class LogInViewController: UIViewController, UIGestureRecognizerDelegate {

    private var overlayViewController: MyPageViewController?
    var dimmingView: UIView?
    
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
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
        textField.layer.cornerRadius = 18
        
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none // 기본값은 .sentences로 문장의 첫 글자를 자동으로 대문자로 변환
        textField.autocorrectionType = .no // 기본값은 .default로 기본 자동 교정 동작을 사용
        
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
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        textField.leftView = paddingView
        textField.leftViewMode = .always
                    
        let passwordVisionButton = UIButton(type: .custom)
        passwordVisionButton.setImage(UIImage(named: "password-invision")?.resize(to: CGSize(width: 24, height: 24)), for: .normal)
        passwordVisionButton.addTarget(nil, action: #selector(LogInViewController.passwordVisionButtonTapped), for: .touchUpInside)
        passwordVisionButton.setImage(UIImage(named: "password-vision")?.resize(to: CGSize(width: 24, height: 24)), for: .selected)
        passwordVisionButton.frame = CGRect(x: 0, y: (30 - 24) / 2, width: 24, height: 24)
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 39, height: 30))
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
        rightPaddingView.addSubview(passwordVisionButton)
                
        textField.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
        textField.layer.cornerRadius = 18
        textField.isSecureTextEntry = true
        
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
        
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.applyColorAnimation()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1)
        button.layer.cornerRadius = 18
        return button
    }()
    
    private let findPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return button
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원 가입", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return button
    }()
    
    private let testButton: UIButton = {
        let button = UIButton()
        button.setTitle("마이페이지", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        setupUI()
        
        emailTextField.delegate = self
    
        autoLoginButton.addTarget(self, action: #selector(autoLoginTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        findPasswordButton.addTarget(self, action: #selector(findPasswordTapped), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        
        testButton.addTarget(self, action: #selector(testButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        print("LogInViewController의 handleTapGesture")
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayViewController?.view.frame = CGRect(x: self.view.frame.size.width, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.dimmingView?.alpha = 0
        }) { (_) in
            self.overlayViewController?.removeFromParent()
            self.overlayViewController?.view.removeFromSuperview()
            self.dimmingView?.removeFromSuperview()
        }
    }
    
    @objc func testButtonTapped() {
        dimmingView = UIView(frame: UIScreen.main.bounds)
        dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView?.alpha = 0
        if let dimmingView = dimmingView {
            view.addSubview(dimmingView)
        }
        
        overlayViewController = MyPageViewController()
        overlayViewController?.view.frame = CGRect(x: view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        if let overlayViewController = overlayViewController {
            addChild(overlayViewController)
        }
        if let x = overlayViewController?.view {
            view.addSubview(x)
        }
        overlayViewController?.dimmingView = dimmingView
        
        UIView.animate(withDuration: 0.3) {
            self.overlayViewController?.view.frame = CGRect(x: 70, y: 0, width: self.view.frame.size.width - 70, height: self.view.frame.size.height)
            self.dimmingView?.alpha = 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
        
        // MyPageViewController를 터치한 경우에는 아무 작업도 수행하지 않습니다.
//        guard let touch = touches.first, let view = touch.view else {
//            return
//        }
//        
//        if view == overlayViewController?.view {
//            print("FUCK")
//            return
//        }
    }
    
    private func setupUI() {
        view.addSubview(testButton)
        testButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(0)
        }

        view.addSubview(logoImageView)
        view.addSubview(logoTextView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(autoLoginButton)
        view.addSubview(loginButton)
        view.addSubview(findPasswordButton)
        view.addSubview(signupButton)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.17)
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
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.1)
            make.height.equalTo(54)
        }   
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.1)
            make.height.equalTo(54)
        }
        
        autoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.leading.equalTo(loginButton.snp.leading).offset(0)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(65)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.1)
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
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func loginTapped() {
        if emailTextField.text != "", passwordTextField.text != "" {
            if let email = emailTextField.text, let password = passwordTextField.text {
                login(email: email, password: password)
            }
        } else {
            print("로그인 탭 에러")
        }
    }
    
    @objc private func signupTapped() {
        navigationController?.pushViewController(EnterEmailViewController(), animated: true)
    }
    
    @objc func autoLoginTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @objc func findPasswordTapped(_ sender: UIButton) {
        navigationController?.pushViewController(FindPasswordViewController(), animated: true)
    }
    
    @objc func closeCircleButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        emailTextField.text = ""
        emailTextField.rightView?.isHidden = true
    }
    
    @objc private func passwordVisionButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTextField.isSecureTextEntry = !sender.isSelected
    }
}

extension LogInViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if !newText.isEmpty {
            let closeButton = UIButton(type: .custom)
            closeButton.setImage(UIImage(named: "close-circle")?.resize(to: CGSize(width: 24, height: 24)), for: .normal)
            closeButton.addTarget(self, action: #selector(closeCircleButtonTapped), for: .touchUpInside)
            closeButton.frame = CGRect(x: 0, y: (30 - 24) / 2, width: 24, height: 24)
            
            let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 39, height: 30))
            textField.rightView = rightPaddingView
            textField.rightViewMode = .always
            rightPaddingView.addSubview(closeButton)
        } else {
            textField.rightView = nil
            textField.rightViewMode = .never
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            textField.resignFirstResponder()            
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

extension LogInViewController {
    
    func login(email: String, password: String) {
        UserService.shared.loginUser(email: email, password: password) { result in
            switch result {
            case .success(let response):
                if response.resultCode == 200 {
                    guard let token = response.token,
                          let email = response.email,
                          let nickname = response.nickname
                    else { return }
                    
                    if self.autoLoginButton.isSelected {
                        UserDefaults.standard.set(true, forKey: "autoLogin")
                        print("자동로그인 O : \(UserDefaults.standard.bool(forKey: "autoLogin"))")
                    } else {
                        UserDefaults.standard.set(false, forKey: "autoLogin")
                        print("자동로그인 X : \(UserDefaults.standard.bool(forKey: "autoLogin"))")
                    }
                    
                    TokenManager.shared.saveToken(token)
                    print("토큰 저장 완료 : \(token)")
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(nickname, forKey: "nickname")
                    
                    if let image = response.image {
                        UserDefaults.standard.set(image, forKey: "image")
                        print("사용자 이미지")
                    } else { // image == nil
                        if let defaultImage = UIImage(named: "default-profile") {
                            let image = UserSession.shared.imageToBase64String(image: defaultImage)
                            UserDefaults.standard.set(image, forKey: "image")
                            print("기본 이미지")
                        }
                    }
                    DispatchQueue.main.async {
                        let nextVC = TodoMainViewController()
                        nextVC.modalPresentationStyle = .fullScreen
                        self.present(nextVC, animated: false, completion: nil)
                    }
                } else {
                    print("로그인 실패 : \(response)")
                }
            case .failure(_):
                let dimmingView = UIView(frame: UIScreen.main.bounds)
                dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                dimmingView.alpha = 0
                self.view.addSubview(dimmingView)
                
                let popupView = CustomPopupView(title: "로그인 실패", message: "이메일 혹은 비밀번호를\n다시 확인해 주세요.", buttonText: "확인", dimmingView: dimmingView)
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
            }
        }
    }
    
//    func login2(email: String, password: String) {
//        UserService.shared.login(email: email, password: password) {
//            response in
//            switch response {
//            case .success(let data):
//                if let json = data as? [String: Any], let resultCode = json["resultCode"] as? Int {
//                    if resultCode == 200 {
//                        print("이백")
//                        guard let token = json["token"] as? String,
//                              let nickname = json["nickname"] as? String,
//                              let email = json["email"] as? String,
//                              let image = json["image"] else {
//                            print("데이터 저장 오류")
//                            return
//                        }
//
//                        TokenManager.shared.saveToken(token)
//                        print("토큰 저장 완료 : \(token)")
//                        
//                        UserSession.shared.nickname = nickname
//                        UserSession.shared.email = email
//                        
//                        if let myImage = image as? String {
//                            UserSession.shared.profileImage = myImage
//                            print("사용자 이미지 프로필 String")
//                            
//                            if let imageData = Data(base64Encoded: myImage, options: .ignoreUnknownCharacters) {
//                                let image = UIImage(data: imageData)
//                                UserSession.shared.image = image
//                                print("사용자 이미지 프로필 UIImage")
//                            }
//                        } else {
//                            print("<null>: 기본 이미지 프로필")
//                        }
//                        
//                        DispatchQueue.main.async {
//                            let myPageViewController = MyPageViewController()
//                            self.navigationController?.pushViewController(myPageViewController, animated: true)
//                        }
//                    } else if resultCode == 500 {
//                        print("오백")
//                        
//                        let dimmingView = UIView(frame: UIScreen.main.bounds)
//                        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//                        dimmingView.alpha = 0
//                        self.view.addSubview(dimmingView)
//                        
//                        let popupView = CustomPopupView(title: "로그인 실패", message: "이메일 혹은 비밀번호를\n다시 확인해 주세요.", buttonText: "확인", dimmingView: dimmingView)
//                        popupView.alpha = 0
//                        self.view.addSubview(popupView)
//                        
//                        UIView.animate(withDuration: 0.3) {
//                            popupView.alpha = 1
//                            dimmingView.alpha = 1
//                        }
//                        
//                        popupView.snp.makeConstraints { make in
//                            make.center.equalToSuperview()
//                            make.width.equalTo(264)
//                            make.height.equalTo(167)
//                        }
//                    }
//                }
//            case .failure:
//                print("FUCKING fail")
//            }
//        }
//        
//    }
}
