//
//  DeleteAccountViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/16.
//

import UIKit

class DeleteAccountViewController: UIViewController {
    
    private var separatorView: UIView?
    
    private let titleLabel1: UILabel = {
        let label = UILabel()
        label.text = "계정 정보"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let accountInfo: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.958, green: 0.958, blue: 0.958, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        if let email = UserSession.shared.email {
            label.text = email
        } else {
            label.text = "(NONE)"
        }
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel2: UILabel = {
        let label = UILabel()
        label.text = "탈퇴 전 안내드려요"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        label.textColor = UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1)
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "계정 탈퇴 시 모든 정보와 데이터가 삭제됩니다.\n복구 및 백업이 불가능하오니, 신중히 생각해 주세요."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        
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
    
    private let checkLabelButton: UIButton = {
        let button = UIButton()
        button.setTitle("  안내사항을 모두 확인하였으며, 탈퇴를 진행합니다.", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .light)
        
        // 1
        button.setTitleColor(UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1), for: .normal)
        button.setImage(UIImage(named: "checkbox-off")?.resize(to: CGSize(width: 16, height: 16)), for: .normal)
        // 2
        
        button.setTitleColor(.black, for: .selected)
        button.setImage(UIImage(named: "checkbox-on")?.resize(to: CGSize(width: 16, height: 16)), for: .selected)
        
        return button
    }()
    
    private let deleteAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("계정 탈퇴하기", for: .normal)
        button.setTitleColor(UIColor(red: 0.554, green: 0.554, blue: 0.554, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupUI()
        
        checkLabelButton.addTarget(self, action: #selector(checkLabelTapped), for: .touchUpInside)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        separatorView = UIView(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: 1))
        separatorView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        navigationController?.navigationBar.addSubview(separatorView!)
        
        DispatchQueue.main.async {
            if let image = UserDefaults.standard.string(forKey: "image") {
                if let originalImage = UserSession.shared.base64StringToImage(base64String: image) {
                    let squareImage = originalImage.squareImage()
                    let roundedImage = squareImage?.roundedImage()
                    self.profileImageView.image = roundedImage
                }
            } else {
                print("UserDefaults에 image 없음2.")
            }
        }
        
        if let email = UserDefaults.standard.string(forKey: "email")  {
            emailLabel.text = email
        } else {
            emailLabel.text = "(NONE)"
        }
        
        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
            nickNameLabel.text = nickname
        } else {
            nickNameLabel.text = "(NONE)"
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        separatorView?.removeFromSuperview()
        separatorView = nil
    }
    
    private func setupUI() {
        // 네비게이션 바 설정
//        let separatorView = UIView(frame: CGRect(x: 0, y: navigationController?.navigationBar.frame.maxY ?? 0 - 1, width: view.frame.width, height: 1))
//        separatorView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
//        navigationController?.navigationBar.addSubview(separatorView)
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)
        
        let font = UIFont.systemFont(ofSize: 16, weight: .bold)
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.black]
        let title = "계정 탈퇴"
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationItem.title = title
        
        view.addSubview(titleLabel1)
        view.addSubview(accountInfo)
        view.addSubview(profileImageView)
        view.addSubview(emailLabel)
        view.addSubview(nickNameLabel)
        view.addSubview(titleLabel2)
        view.addSubview(messageLabel)
        view.addSubview(checkLabelButton)
        view.addSubview(deleteAccountButton)
        
        titleLabel1.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(47)
            make.leading.equalToSuperview().offset(34)
        }
        
        accountInfo.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom).offset(7)
            make.leading.equalToSuperview().offset(34)
            make.trailing.equalToSuperview().offset(-34)
            make.width.equalTo(500)
            make.height.equalTo(63)
        }
        
        accountInfo.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(accountInfo.snp.leading).offset(15)
            make.width.equalTo(41)
            make.height.equalTo(41)
        }
        
        accountInfo.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(accountInfo.snp.top).offset(15)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }

        accountInfo.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.bottom.equalTo(accountInfo.snp.bottom).offset(-15)
        }
        
        titleLabel2.snp.makeConstraints { make in
            make.top.equalTo(accountInfo.snp.bottom).offset(22)
            make.leading.equalToSuperview().offset(34)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel2.snp.bottom).offset(7)
            make.leading.equalToSuperview().offset(34)
        }
        
        checkLabelButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(41.5)
            make.leading.equalToSuperview().offset(34)
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.top.equalTo(checkLabelButton.snp.bottom).offset(41.5)
            make.leading.equalToSuperview().offset(34)
            make.trailing.equalToSuperview().offset(-34)
            make.height.equalTo(50)
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func checkLabelTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.deleteAccountButton.backgroundColor = UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1)
            self.deleteAccountButton.setTitleColor(.black, for: .normal)
            self.deleteAccountButton.isEnabled = true
        } else {
            self.deleteAccountButton.setTitleColor(UIColor(red: 0.554, green: 0.554, blue: 0.554, alpha: 1), for: .normal)
            self.deleteAccountButton.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
            self.deleteAccountButton.isEnabled = false
        }
    }
    
    @objc func deleteAccountButtonTapped() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            let dimmingView = UIView(frame: keyWindow.bounds)
            dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            dimmingView.alpha = 0
            keyWindow.addSubview(dimmingView)
            
            let popupView = LogoutPopupView(title: "정말 떠나시나요?😢", message: "다음에 또 만나길 기대할게요.", buttonText1: "취소", buttonText2: "확인", dimmingView: dimmingView)
            popupView.delegate = self // 중요
            popupView.alpha = 0
            keyWindow.addSubview(popupView)
            popupView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(264)
                make.height.equalTo(167)
            }
            
            UIView.animate(withDuration: 0.2) {
                popupView.alpha = 1
                dimmingView.alpha = 1
            }
        }
    }
}

extension DeleteAccountViewController {
    
    func deleteAccount() {
        UserService.shared.deleteAccount() {
            response in
            switch response {
            case .success(let data):
                if let json = data as? [String: Any],
                   let resultCode = json["resultCode"] as? Int {
                    if resultCode == 200 {
                        print("이백")
                        
                        let domain = Bundle.main.bundleIdentifier!
                        UserDefaults.standard.removePersistentDomain(forName: domain)
                        UserDefaults.standard.synchronize()

                        let viewControllerToPresent = LogInViewController() // 이동할 뷰 컨트롤러 인스턴스 생성
                        viewControllerToPresent.modalPresentationStyle = .fullScreen // 화면 전체를 차지하도록 설정
                        self.present(viewControllerToPresent, animated: true, completion: nil) // 뷰 컨트롤러 이동
                    } else if resultCode == 500 {
                        print("오백")
                    }
                }
            case .failure(_):
                print("FUCKING fail")
            }
        }
    }
}

extension DeleteAccountViewController: LogoutPopupViewDelegate {
    func logoutButtonTappedDelegate() {
        deleteAccount()
    }
}
