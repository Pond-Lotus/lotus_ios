//
//  DrawerViewController.swift
//  TODORI
//
//  Created by 제임스 on 2023/05/19.
//

import UIKit
import SnapKit

class DrawerViewController:UIViewController{
    var profileImageView:UIImageView = UIImageView()
    var nickNameLabel:UILabel = UILabel()
    var emailLabel:UILabel = UILabel()
    var profileEditButton:UIButton = UIButton()
    var stackViewOfNicknameEmailLabel:UIStackView = UIStackView()
    var grayLine1:UIView = UIView()
    var settingLabel:UILabel = UILabel()
    var passwordEditButton:UIButton = UIButton()
    var nicknameEditButton:UIButton = UIButton()
    var nicknameSettingImage:UIImageView = UIImageView()
    var passwordSettingImage:UIImageView = UIImageView()
    var nicknameEditStackView:UIStackView = UIStackView()
    var passwordEditStackView:UIStackView = UIStackView()

    
    override func viewDidLoad() {
        addComponent()
        setComponentAppearence()
        setAutoLayout()
        addFunctionToComponent()
        profileSetting()
        
        UserDefaults.standard.set("vldzm100411226@gmail.com", forKey: "email")
    }
    
    private func addComponent(){
        self.view.addSubview(profileImageView)
        stackViewOfNicknameEmailLabel.addArrangedSubview(nickNameLabel)
        stackViewOfNicknameEmailLabel.addArrangedSubview(emailLabel)
        self.view.addSubview(stackViewOfNicknameEmailLabel)
        self.view.addSubview(profileEditButton)
        self.view.addSubview(grayLine1)
        self.view.addSubview(settingLabel)
        nicknameEditStackView.addArrangedSubview(nicknameSettingImage)
        nicknameEditStackView.addArrangedSubview(nicknameEditButton)
        self.view.addSubview(nicknameEditStackView)
        passwordEditStackView.addArrangedSubview(passwordSettingImage)
        passwordEditStackView.addArrangedSubview(passwordEditButton)
        self.view.addSubview(passwordEditStackView)
    }
    private func setComponentAppearence(){
        self.view.backgroundColor = .white
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 41/2
        profileImageView.backgroundColor = .gray
        
        stackViewOfNicknameEmailLabel.axis = .vertical
        
        nickNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        nickNameLabel.textColor = .black
        
        emailLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        emailLabel.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        
        profileEditButton.setImage(UIImage(named: "profile-edit"), for: .normal)
        
        grayLine1.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        
        settingLabel.text = "환경설정"
        settingLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        settingLabel.textColor = .black
        
        nicknameSettingImage.image = UIImage(named: "setting")
        passwordSettingImage.image = UIImage(named: "setting")
        
        nicknameEditStackView.axis = .horizontal
        nicknameEditStackView.spacing = 6
        
        passwordEditStackView.axis = .horizontal
        passwordEditStackView.spacing = 6
        
        nicknameEditButton.setTitle("닉네임 수정", for: .normal)
        nicknameEditButton.setTitleColor(.black, for: .normal) //titlelabel.textcolor로 변경하니 변경되지 않음
        nicknameEditButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        passwordEditButton.setTitle("비밀번호 변경", for: .normal)
        passwordEditButton.setTitleColor(.black, for: .normal) //titlelabel.textcolor로 변경하니 변경되지 않음
        passwordEditButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    private func setAutoLayout(){
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(73)
            make.left.equalToSuperview().offset(22)
            make.width.height.equalTo(41)
        }
        
        profileEditButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-18)
            make.width.height.equalTo(24)
            make.centerY.equalTo(profileImageView)
        }
        
        stackViewOfNicknameEmailLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.right.equalTo(profileEditButton.snp.left).offset(-6)
        }
        
        grayLine1.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(21)
            make.left.equalToSuperview().offset(17)
            make.right.equalToSuperview().offset(-17)
            make.height.equalTo(1)
        }
        
        settingLabel.snp.makeConstraints { make in
            make.top.equalTo(grayLine1).offset(21)
            make.left.equalToSuperview().offset(22)
        }
    
        nicknameSettingImage.snp.makeConstraints { make in
            make.width.height.equalTo(18)
        }
        
        passwordSettingImage.snp.makeConstraints { make in
            make.width.height.equalTo(18)
        }
        
        nicknameEditStackView.snp.makeConstraints { make in
            make.top.equalTo(settingLabel.snp.bottom).offset(19)
            make.left.equalToSuperview().offset(23)
        }
        
        passwordEditStackView.snp.makeConstraints { make in
            make.top.equalTo(nicknameEditStackView.snp.bottom).offset(22)
            make.left.equalToSuperview().offset(23)
            
        }
    
    
    }
    private func addFunctionToComponent(){
        profileEditButton.addTarget(self, action: #selector(tapEditButton), for: .touchDown)
    }
    
    private func profileSetting(){
        if let profileImage = UserDefaults.standard.string(forKey: "image"){
            guard let decodedData = Data(base64Encoded: profileImage) else {print("base 64 decode error");return}
            let decodedImage = UIImage(data: decodedData)
            self.profileImageView.image = decodedImage
        }else{
            self.profileImageView.image = UIImage(named: "profile-image")
        }
        
        if let nickname = UserDefaults.standard.string(forKey: "nickname"){
            self.nickNameLabel.text = nickname
        }else{
            print("no nickname")
        }
        
        if let email = UserDefaults.standard.string(forKey: "email"){
            self.emailLabel.text = email
        }else{
            print("no email")
        }
        
    }
    
    @objc private func tapEditButton(){
        
    }

}
