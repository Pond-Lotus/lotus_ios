//
//  EditProfileViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/15.
//

import UIKit
import PhotosUI

class EditProfileViewController: UIViewController {
    
    private var separatorView: UIView?
    var tmpImage: UIImage?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let editProfileImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "edit-profile-image")?.resize(to: CGSize(width: 26, height: 26)), for: .normal)
        return button
    }()
    
    private let nickNameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nickNameTextField: UITextField = {
        let textField = UITextField()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .light),
            .foregroundColor:  UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
        ]
        
        let attributedPlaceholder: NSAttributedString?
        if let nickname = UserDefaults.standard.string(forKey: "nickname")  {
            attributedPlaceholder = NSAttributedString(string: nickname, attributes: attributes)
        } else {
            attributedPlaceholder = NSAttributedString(string: "(NONE)", attributes: attributes)
        }
        textField.attributedPlaceholder = attributedPlaceholder
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.borderStyle = .none
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red: 0.817, green: 0.817, blue: 0.817, alpha: 1).cgColor
        
        textField.layer.cornerRadius = 8
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        if let email = UserDefaults.standard.string(forKey: "email")  {
            label.text = "   " + email
        } else {
            label.text = "   " + "(NONE)"
        }
        
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.textColor = UIColor(red: 0.617, green: 0.617, blue: 0.617, alpha: 1)
        label.backgroundColor = UIColor(red: 0.946, green: 0.946, blue: 0.946, alpha: 1)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    private let changePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 변경", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1).cgColor
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let deleteAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("계정 탈퇴하기", for: .normal)
        button.setTitleColor( UIColor(red: 0.554, green: 0.554, blue: 0.554, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        editProfileImageButton.addTarget(self, action: #selector(editProfileImageButtonTapped), for: .touchUpInside)
        changePasswordButton.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
        
        setupUI()
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
            emailLabel.text = "   " + email
        } else {
            emailLabel.text = "   " + "(NONE)"
        }
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
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
//        navigationController?.navigationBar.tintColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)
        
        let completeButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonTapped))
//        if 조건 {
//            let attributes: [NSAttributedString.Key: Any] = [
//                .foregroundColor: UIColor.red, // 원하는 폰트 컬러로 설정
//                // 다른 원하는 속성들도 추가 가능
//            ]
//            button.setTitleTextAttributes(attributes, for: .normal)
//        }
        let completeButtonAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium) ,
        ]
        completeButton.setTitleTextAttributes(completeButtonAttributes, for: .normal)
        navigationItem.rightBarButtonItem = completeButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        
        let font = UIFont.systemFont(ofSize: 16, weight: .bold)
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationItem.title = "프로필 수정"
        
        view.addSubview(profileImageView)
        view.addSubview(editProfileImageButton)
        view.addSubview(nickNameTitleLabel)
        view.addSubview(nickNameTextField)
        view.addSubview(emailTitleLabel)
        view.addSubview(emailLabel)
        view.addSubview(changePasswordButton)
        view.addSubview(deleteAccountButton)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(26)
            make.centerX.equalToSuperview()
            make.width.equalTo(89)
            make.height.equalTo(89)
        }
        
        editProfileImageButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(92.83)
            make.leading.equalTo(profileImageView.snp.leading).offset(62)
        }
      
        nickNameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(26)
            make.leading.equalToSuperview().offset(20)
        }
        
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameTitleLabel.snp.bottom).offset(7)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(45)
        }
        
        emailTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(20)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTitleLabel.snp.bottom).offset(7)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(45)
        }
        
        changePasswordButton.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(45)
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-35)
            make.centerX.equalToSuperview()
            make.width.equalTo(93)
            make.height.equalTo(30)
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func completeButtonTapped() {
        
        if let nickname = nickNameTextField.text {
            if let image = UserSession.shared.image {
                UserDefaults.standard.set(image, forKey: "image")
                let image = UserSession.shared.base64StringToImage(base64String: image)
                if nickname == "" {
                    if let nickname = UserDefaults.standard.string(forKey: "nickname") {
                        self.editProfile(image: image, nickname: nickname, imdel: false)
                    }
                } else {
                    self.editProfile(image: image, nickname: nickname, imdel: false)
                }
            } else {
                if let image = UserDefaults.standard.string(forKey: "image") {
                    let image = UserSession.shared.base64StringToImage(base64String: image)
                    if nickname == "" {
                        if let nickname = UserDefaults.standard.string(forKey: "nickname") {
                            self.editProfile(image: image, nickname: nickname, imdel: false)
                        }
                    } else {
                        self.editProfile(image: image, nickname: nickname, imdel: false)
                    }
                }
            }
        } else {
            print("프로필 수정 완료 못함.")
        }
    }

    @objc func editProfileImageButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let albumAction = UIAlertAction(title: "앨범에서 선택", style: .default) { [weak self] _ in
            var configurcation = PHPickerConfiguration()
            configurcation.selectionLimit = 1
            
            let picker = PHPickerViewController(configuration: configurcation)
            picker.delegate = self
            
            self?.present(picker, animated: true, completion: nil)
        }
        
        let defaultImageAction = UIAlertAction(title: "기본 이미지로 설정", style: .default) { _ in
            if let defaultImage = UIImage(named: "default-profile") {
                self.profileImageView.image = defaultImage // 완료 버튼 누르기 전까지 서버에 변경사항 요청하지 않음
                UserSession.shared.image = UserSession.shared.imageToBase64String(image: defaultImage)
            }
        }
        
        let cancelAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        
        alertController.addAction(albumAction)
        alertController.addAction(defaultImageAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func changePasswordButtonTapped() {
//        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(ChangePasswordViewController(), animated: true)
    }
    
    @objc func deleteAccountButtonTapped() {
//        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(DeleteAccountViewController(), animated: true)
    }
}

extension EditProfileViewController {

    func editProfile(image: UIImage?, nickname: String, imdel: Bool) {
        if let image = image {
            UserService.shared.editProfile(image: image, nickname: nickname, imdel: imdel) {
                response in
                switch response {
                case .success(let data):
                    if let json = data as? [String: Any],
                       let resultCode = json["resultCode"] as? Int {
                        if resultCode == 200 {
                            print("이백")

                            if let data = json["data"] as? [String: Any] {
                                if let nickname = data["nickname"] as? String {
                                    UserDefaults.standard.set(nickname, forKey: "nickname")
                                } else { print("닉네임 저장 오류")}
                                if let image = data["image"] as? String {
                                    print("이미지 저장 완료")
                                    UserDefaults.standard.set(image, forKey: "image")
                                    
                                    let dimmingView = UIView(frame: UIScreen.main.bounds)
                                    dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                                    dimmingView.alpha = 0
                                    self.view.addSubview(dimmingView)
                                    
                                    let popupView = CustomPopupView(title: "프로필 수정", message: "프로필 수정이 완료되었습니다.", buttonText: "확인", dimmingView: dimmingView)
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
                                } else {
                                    print("이미지 저장 오류")
                                    if let image = UIImage(named: "default-profile") {
                                        UserDefaults.standard.set(image, forKey: "image")
                                    }
                                }
                            } else {
                                print("데이터 저장 오류")
                            }
                        } else if resultCode == 500 {
                            print("오백")
                        }
                    }
                case .failure(let err):
                    print(err)
                }
            }
        } else {
            print("뭐고")
        }
    }
}

extension EditProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) // 1
        
        guard let itemProvider = results.first?.itemProvider else {
            // 선택된 항목이 없을 경우 처리
            return
        }
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in // 4
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        UserSession.shared.image = UserSession.shared.imageToBase64String(image: image) // 완료 눌렀을 때를 위한 임시 저장
                        
                        if let imageData = image.pngData() {
                            // base64String을 서버로 전송하거나 다른 처리에 사용할 수 있습니다.
                            let base64String = imageData.base64EncodedString()
                            if let imageData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) {
                                if let originalImage = UIImage(data: imageData) {
                                    // 이미지를 정사각형으로 잘라내기 위한 크기 계산
                                    let squareSize = min(originalImage.size.width, originalImage.size.height)
                                    let squareRect = CGRect(x: 0, y: 0, width: squareSize, height: squareSize)
                                    
                                    // 정사각형으로 잘라낸 이미지 생성
                                    if let croppedImage = originalImage.cgImage?.cropping(to: squareRect) {
                                        let croppedUIImage = UIImage(cgImage: croppedImage)

                                        // 원형 이미지 생성
                                        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2.0
                                        self.profileImageView.clipsToBounds = true
                                        self.profileImageView.image = croppedUIImage
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            // TODO: Handle empty results or item provider not being able load UIImage
        }
    }
}
