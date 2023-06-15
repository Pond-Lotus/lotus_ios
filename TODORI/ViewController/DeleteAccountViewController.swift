//
//  DeleteAccountViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/16.
//

import UIKit

class DeleteAccountViewController: UIViewController {
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
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = UserSession.shared.email ?? "(NONE)"
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        return label
    }()
    
    private let titleLabel2: UIStackView = {
        let label = UILabel()
        label.text = "탈퇴 전 안내드려요"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1)
        let imageView = UIImageView(image: UIImage(named: "delete-icon")?.resize(to: CGSize(width: 16, height: 16)))
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.spacing = 3
        return stackView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "계정 탈퇴 시 모든 정보와 데이터가 삭제됩니다.\n복구 및 백업이 불가능하오니, 신중히 생각해 주세요."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
    
    private let checkLabelButton: UIButton = {
        let button = UIButton()
        button.setTitle("  안내사항을 모두 확인하였으며, 탈퇴를 진행합니다.", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .light)
        button.setTitleColor(UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1), for: .normal)
        button.setImage(UIImage(named: "checkbox-off")?.resize(to: CGSize(width: 16, height: 16)), for: .normal)
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
        
        navigationController?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
                
        setupButton()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let cornerRadius = min(self.profileImageView.bounds.width, self.profileImageView.bounds.height) / 2
        self.profileImageView.layer.cornerRadius = cornerRadius
    }

    private func setupButton() {
        checkLabelButton.addTarget(self, action: #selector(checkLabelTapped), for: .touchUpInside)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
    }
    
    private func setupUI() {
        DispatchQueue.main.async {
            if let imageData = UserDefaults.standard.data(forKey: "image") {
                self.profileImageView.image = UIImage(data: imageData)
            } else {
                self.profileImageView.image = UIImage(named: "default-profile")
            }
        }
        guard let email = UserDefaults.standard.string(forKey: "email"),
              let nickname = UserDefaults.standard.string(forKey: "nickname")
        else { return }
        emailLabel.text = email
        nickNameLabel.text = nickname
        
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction:  #selector(backButtonTapped), title: "계정 탈퇴", showSeparator: false)
        
        view.addSubview(titleLabel1)
        view.addSubview(accountInfo)
        accountInfo.addSubview(profileImageView)
        accountInfo.addSubview(nickNameLabel)
        accountInfo.addSubview(emailLabel)
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
            make.centerX.equalToSuperview()
            make.height.equalTo(63)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(accountInfo.snp.leading).offset(15)
            make.width.equalTo(41)
            make.height.equalTo(41)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(accountInfo.snp.top).offset(15)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }

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
        let dimmingView = UIView(frame: UIScreen.main.bounds)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView.alpha = 0
        self.view.addSubview(dimmingView)
        let popupView = CustomPopupView2(title: "정말 떠나시나요?😢", message: "다음에 또 만나길 기대할게요.", buttonText1: "취소", buttonText2: "확인", dimmingView: dimmingView)
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
    }
}

extension DeleteAccountViewController {
    func deleteAccount() {
        UserService.shared.deleteAccount() { result in
            switch result {
            case .success(let response):
                if response.resultCode == 200 {
                    print("이백")
                    SceneDelegate.reset()
                } else if response.resultCode == 500 {
                    print("오백")
                }
            case .failure:
                print("failure")
            }
        }
    }
}

extension DeleteAccountViewController: CustomPopupView2Delegate {
    func buttonTappedDelegate() {
        deleteAccount()
    }
}

extension DeleteAccountViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}

extension DeleteAccountViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
