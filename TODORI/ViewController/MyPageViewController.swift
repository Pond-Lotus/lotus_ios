//
//  MyPageViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/13.
//

import UIKit

class MyPageViewController: UIViewController {

    private var initialPosition: CGPoint = .zero
    var dimmingView: UIView?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 41/2
        return imageView
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        if let nickname = UserDefaults.standard.string(forKey: "nickname")  {
            label.text = nickname
        } else {
            label.text = "(NONE)"
        }
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        if let email = UserDefaults.standard.string(forKey: "email")  {
            label.text = email
        } else {
            label.text = "(NONE)"
        }
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "edit-profile")?.resize(to: CGSize(width: 24, height: 24)), for: .normal)
        return button
    }()
    
    private let titleLabel1: UILabel = {
        let label = UILabel()
        label.text = "환경 설정"
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let changePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle(" 비밀번호 변경", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        let image = UIImage(named: "setting")?.resize(to: CGSize(width: 18, height: 18))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton()
        button.setTitle(" 알림 설정", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        let image = UIImage(named: "setting")?.resize(to: CGSize(width: 18, height: 18))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel2: UILabel = {
        let label = UILabel()
        label.text = "그룹 설정"
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let settingGroupButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        let image = UIImage(systemName: "chevron.right")?.resize(to: CGSize(width: 10, height: 14))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle(" 로그아웃", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        let image = UIImage(named: "logout")?.resize(to: CGSize(width: 18, height: 18))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var underlineViews: [UIView] = []

    private func createUnderlineView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private var colorViews: [UIImageView] = []

    private func createColorView(_ filename: String) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: filename))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
            
        editProfileButton.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        settingGroupButton.addTarget(self, action: #selector(settingGroupButtonTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        }
        
        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
            nickNameLabel.text = nickname
        }
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupUI() {
        let stackView1 = UIStackView(arrangedSubviews: [changePasswordButton, notificationButton])
        stackView1.axis = .vertical
        stackView1.spacing = 22
        stackView1.alignment = .leading
        
//        let stackView2 = UIStackView(arrangedSubviews: [])
        let stackView2 = UIStackView()
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
        
        for _ in 1...4 { underlineViews.append(createUnderlineView()) }
        underlineViews.forEach { view.addSubview($0) }

        underlineViews[0].snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(21)
            make.leading.equalToSuperview().offset(17)
            make.centerX.equalToSuperview()
            make.height.equalTo(1.0)
        }
        underlineViews[1].snp.makeConstraints { make in
            make.top.equalTo(stackView1.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(17)
            make.centerX.equalToSuperview()
            make.height.equalTo(1.0)
        }
        underlineViews[2].snp.makeConstraints { make in
            make.top.equalTo(stackView2.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(17)
            make.centerX.equalToSuperview()
            make.height.equalTo(1.0)
        }
        underlineViews[3].snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-64)
            make.leading.equalToSuperview().offset(17)
            make.centerX.equalToSuperview()
            make.height.equalTo(1.0)
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
            make.top.equalToSuperview().offset(98)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        editProfileButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(84)
            make.trailing.equalToSuperview().offset(-18)
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
            make.trailing.equalToSuperview().offset(-22)
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
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        // MyPageViewController의 뷰를 터치한 경우에만 아래 코드가 실행됩니다.
        // 터치 이벤트를 소비하여 상위 뷰 컨트롤러로 전달되지 않도록 합니다.
        gesture.cancelsTouchesInView = true
    }
    
    @objc func editProfileButtonTapped() {
        navigationController?.pushViewController(EditProfileViewController(), animated: true)
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
            
            let popupView = LogoutPopupView(title: "로그아웃", message: "로그아웃 하시겠습니까?", buttonText1: "취소", buttonText2: "로그아웃", dimmingView: dimmingView)
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
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            initialPosition = view.center
        case .changed:
//            view.center = CGPoint(x: initialPosition.x + translation.x, y: initialPosition.y)
            let newX = initialPosition.x + translation.x
            if newX > initialPosition.x {
                view.center = CGPoint(x: newX, y: initialPosition.y)
            }
        case .ended, .cancelled:
            let screenWidth = UIScreen.main.bounds.width
            
            if view.center.x > screenWidth / 2 {
                // 오른쪽으로 당겨졌으므로 다시 들어가도록 애니메이션 처리
                UIView.animate(withDuration: 0.2) {
                    self.view.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: self.view.frame.height)
                } completion: { _ in
                    self.view.removeFromSuperview()
                    self.removeFromParent()
                    self.dimmingView?.isHidden = true   
                }
            } else {
                // 왼쪽으로 당겨지지 않았으므로 초기 위치로 되돌림
                UIView.animate(withDuration: 0.3) {
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
        UserService.shared.logout() { response in
            switch response {
            case .success(let data):
                if let json = data as? [String: Any], let resultCode = json["resultCode"] as? Int {
                    if resultCode == 200 {
                        print("로그아웃 이백")
                        UserDefaults.standard.set(false, forKey: "autoLogin")
                        
                        if let navigationController = self.navigationController {
                            navigationController.setViewControllers([], animated: false)
                            navigationController.pushViewController(LogInViewController(), animated: true)
                        }

//                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
//                            return
//                        }
//
//                        let navigationController = UINavigationController(rootViewController: LogInViewController())
//                        sceneDelegate.window?.rootViewController = navigationController
//                        sceneDelegate.window?.makeKeyAndVisible()
//                        self.navigationController?.popToRootViewController(animated: true)

                    } else if resultCode == 500 {
                        print("오백")
                        print("로그아웃 실패")
                    }
                }
            case .failure:
                print("FUCKING fail")
            }
        }
    }
    
    func inquireGroup() {
        TodoService.shared.inquireGroupName() { response in
            switch response {
            case .success(let data):
                if let json = data as? ToDoResponse {
                    if json.resultCode == 200 {
                        print("이백")
                        
                        let groupSettingVC = GroupSettingViewController()
                        if let group1 = json.data["1"] {
                            groupSettingVC.firstGroupName = group1
                        }
                        if let group2 = json.data["2"] {
                            groupSettingVC.secondGroupName = group2
                        }
                        if let group3 = json.data["3"] {
                            groupSettingVC.thirdGroupName = group3
                        }
                        if let group4 = json.data["4"] {
                            groupSettingVC.fourthGroupName = group4
                        }
                        if let group5 = json.data["5"] {
                            groupSettingVC.fifthGroupName = group5
                        }
                        if let group6 = json.data["6"] {
                            groupSettingVC.sixthGroupName = group6
                        }
                        self.navigationController?.pushViewController(groupSettingVC, animated: true)
                        
                    } else if json.resultCode == 500 {
                        print("오백")
                    }
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}

extension MyPageViewController: LogoutPopupViewDelegate {
    func logoutButtonTappedDelegate() {
        logout()
    }
}
