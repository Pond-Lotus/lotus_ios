//
//  MyPageViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/13.
//

import UIKit

class MyPageViewController: UIViewController {
    var dimmingView: UIView?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = UserDefaults.standard.string(forKey: "nickname")
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = UserDefaults.standard.string(forKey: "email")
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        return label
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "edit-profile")?.resize(to: CGSize(width: 24, height: 24)), for: .normal)
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        button.configuration = configuration
        return button
    }()
    
    private let titleLabel1: UILabel = {
        let label = UILabel()
        label.text = "환경 설정"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let changePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle(" 비밀번호 변경", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        let image = UIImage(named: "setting")?.resize(to: CGSize(width: 18, height: 18))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton()
        button.setTitle(" 알림 설정", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        let image = UIImage(named: "setting")?.resize(to: CGSize(width: 18, height: 18))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let titleLabel2: UILabel = {
        let label = UILabel()
        label.text = "그룹 설정"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let settingGroupButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.right")?.resize(to: CGSize(width: 10, height: 14))
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        button.contentHorizontalAlignment = .right
        button.contentVerticalAlignment = .top
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle(" 로그아웃", for: .normal)
        button.setTitleColor(UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        let image = UIImage(named: "logout")?.resize(to: CGSize(width: 18, height: 18))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private func createUnderlineView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        self.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.height.equalTo(1.0)
            make.leading.equalToSuperview().offset(22)
            make.centerX.equalToSuperview()
        }
        return view
    }
    
    private func createColorView(_ filename: String) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: filename)?.resize(to: CGSize(width: 25, height: 25)))
        return imageView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
        editProfileButton.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        changePasswordButton.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
        notificationButton.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        settingGroupButton.addTarget(self, action: #selector(settingGroupButtonTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        guard let email = UserDefaults.standard.string(forKey: "email"),
              let nickname = UserDefaults.standard.string(forKey: "nickname")
        else { return }
        
        DispatchQueue.main.async {
            if let imageData = UserDefaults.standard.data(forKey: "image") {
                self.profileImageView.image = UIImage(data: imageData)
            } else {
                self.profileImageView.image = UIImage(named: "default-profile")
            }
        }
        emailLabel.text = email
        nickNameLabel.text = nickname
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let cornerRadius = min(self.profileImageView.bounds.width, self.profileImageView.bounds.height) / 2
        self.profileImageView.layer.cornerRadius = cornerRadius
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setupUI() {        
        let stackView1 = UIStackView(arrangedSubviews: [changePasswordButton, notificationButton])
        stackView1.axis = .vertical
        stackView1.spacing = 22
        stackView1.alignment = .leading
        
        let stackView2 = UIStackView()
        var colorViews: [UIImageView] = []
        colorViews.append(createColorView("red-circle"))
        colorViews.append(createColorView("yellow-circle"))
        colorViews.append(createColorView("green-circle"))
        colorViews.append(createColorView("blue-circle"))
        colorViews.append(createColorView("pink-circle"))
        colorViews.append(createColorView("purple-circle"))
        for colorView in colorViews {
            stackView2.addArrangedSubview(colorView)
        }
        stackView2.axis = .horizontal
        stackView2.distribution = .equalSpacing
        
        view.addSubview(profileImageView)
        view.addSubview(nickNameLabel)
        view.addSubview(emailLabel)
        view.addSubview(editProfileButton)
        view.addSubview(titleLabel1)
        view.addSubview(stackView1)
        view.addSubview(titleLabel2)
        view.addSubview(stackView2)
        view.addSubview(settingGroupButton)
        view.addSubview(logoutButton)
        
        var underlineViews: [UIView] = []
        for _ in 1...4 { underlineViews.append(createUnderlineView()) }
        
        underlineViews[0].snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(21)
        }
        underlineViews[1].snp.makeConstraints { make in
            make.top.equalTo(stackView1.snp.bottom).offset(28)
        }
        underlineViews[2].snp.makeConstraints { make in
            make.top.equalTo(stackView2.snp.bottom).offset(28)
        }
        underlineViews[3].snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-70)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(73)
            make.leading.equalToSuperview().offset(22)
            make.width.equalTo(41)
            make.height.equalTo(41)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(77)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(95)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        editProfileButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.trailing.equalToSuperview().offset(-22 + 10)
        }
        
        titleLabel1.snp.makeConstraints { make in
            make.top.equalTo(underlineViews[0].snp.bottom).offset(21)
            make.leading.equalToSuperview().offset(22)
        }
        
        stackView1.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom).offset(19)
            make.leading.equalToSuperview().offset(22)
        }
        
        titleLabel2.snp.makeConstraints { make in
            make.top.equalTo(underlineViews[1].snp.bottom).offset(21)
            make.leading.equalToSuperview().offset(22)
        }
        
        settingGroupButton.snp.makeConstraints { make in
            make.top.equalTo(underlineViews[1].snp.bottom).offset(21)
            make.bottom.equalTo(underlineViews[2].snp.bottom).offset(-21)
            make.trailing.equalToSuperview().offset(-22)
            make.centerX.equalToSuperview()
        }
        
        stackView2.snp.makeConstraints { make in
            make.top.equalTo(titleLabel2.snp.bottom).offset(19)
            make.leading.equalToSuperview().offset(22)
            make.centerX.equalToSuperview()
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(underlineViews[3].snp.bottom).offset(21)
            make.leading.equalToSuperview().offset(22)
        }
    }
    
    @objc func editProfileButtonTapped() {
        navigationController?.pushViewController(EditProfileViewController(), animated: true)
    }
        
    @objc func changePasswordButtonTapped() {
        navigationController?.pushViewController(ChangePasswordViewController(), animated: true)
    }
    
    @objc func notificationButtonTapped() {
        navigationController?.pushViewController(NotificationViewController(), animated: true)
    }
    
    @objc func settingGroupButtonTapped() {
        inquireGroup()
    }
    
    @objc func logoutButtonTapped() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            let dimmingView = UIView(frame: keyWindow.bounds)
            dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            dimmingView.alpha = 0
            keyWindow.addSubview(dimmingView)
            let popupView = TwoButtonPopupView(title: "로그아웃", message: "로그아웃 하시겠습니까?", buttonText1: "취소", buttonText2: "로그아웃", dimmingView: dimmingView)
            popupView.delegate = self
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
    
    private var initialPosition: CGPoint = .zero
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            initialPosition = view.center
        case .changed:
            let newX = initialPosition.x + translation.x
            if newX > initialPosition.x {
                view.center = CGPoint(x: newX, y: initialPosition.y)
            }
        case .ended, .cancelled:
            if view.frame.minX > 100 {
                let screenWidth = UIScreen.main.bounds.width
                UIView.animate(withDuration: 0.1) {
                    self.view.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: self.view.frame.height)
                } completion: { _ in
                    self.view.removeFromSuperview()
                    self.removeFromParent()
                    self.dimmingView?.removeFromSuperview()
                }
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.view.center = self.initialPosition
                }
            }
        default:
            break
        }
    }
}

extension MyPageViewController {
    func logout() {
        UserService.shared.logout() { result in
            switch result {
            case .success(let response):
                if response.resultCode == 200 {
                    print("이백")
                    NavigationBarManager.shared.removeSeparatorView()
                    SceneDelegate.reset()
                } else if response.resultCode == 500 {
                    print("오백")
                }
            case .failure:
                print("failure")
            }
        }
    }
    
    func inquireGroup() {
        TodoService.shared.inquireGroupName() { result in
            switch result {
            case .success(let response):
                if response.resultCode == 200 {
                    print("이백")
                    if let group1 = response.data["1"] {
                        GroupData.shared.firstGroupName = group1
                    }
                    if let group2 = response.data["2"] {
                        GroupData.shared.secondGroupName = group2
                    }
                    if let group3 = response.data["3"] {
                        GroupData.shared.thirdGroupName = group3
                    }
                    if let group4 = response.data["4"] {
                        GroupData.shared.fourthGroupName = group4
                    }
                    if let group5 = response.data["5"] {
                        GroupData.shared.fifthGroupName = group5
                    }
                    if let group6 = response.data["6"] {
                        GroupData.shared.sixthGroupName = group6
                    }
                    
                    self.navigationController?.pushViewController(GroupSettingViewController(), animated: true)
                } else if response.resultCode == 500 {
                    print("오백")
                }
            case .failure:
                print("failure")
            }
        }
    }
}

extension MyPageViewController: TwoButtonPopupViewDelegate {
    func buttonTappedDelegate() {
        logout()
    }
}
