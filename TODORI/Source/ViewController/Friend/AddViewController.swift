//
//  AddViewController.swift
//  TODORI
//
//  Created by 제임스 on 2023/10/06.
//

import UIKit
import SnapKit

class AddViewController: UIViewController {
    
    let emailLabel = LabelManager.shared.getAddEmailLabel()
    var emailTextField = TextFieldManager.shared.getAddEmailTextField()
    var addFriendButton = ButtonManager.shared.getAddFriendButton()
    var popupVC: OneButtonPopupViewController = {
        let popup = OneButtonPopupViewController()
        popup.titleLabel.text = "친구 추가"
        popup.messageLabel.text = "친구 요청이 전송되었어요!"
        popup.actionButton.setTitle("확인", for: .normal)
        popup.modalPresentationStyle = .overCurrentContext
        return popup
    }()
    
    var addButtonTextColor: UIColor = UIColor()
    var addButtonBackgroundColor: UIColor = UIColor()
    var addButtonBorderColor: UIColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addFunction()
    }
    
    private func setUI(){
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(addFriendButton)
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(21)
            make.width.equalTo(37)
        }
        
        emailTextField.addLeftPadding(inset: 16)
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(45)
        }
        
        addFriendButton.snp.makeConstraints { make in
            make.width.equalTo(106)
            make.height.equalTo(35)
            make.right.equalTo(emailTextField.snp.right)
            make.top.equalTo(emailTextField.snp.bottom).offset(13)
        }

        if traitCollection.userInterfaceStyle == .dark {
            addButtonBackgroundColor = UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1.00)
            addButtonBorderColor = UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1.00)
            addButtonTextColor = UIColor(red: 0.26, green: 0.26, blue: 0.26, alpha: 1.00)
        } else {
            addButtonBackgroundColor = .clear
            addButtonBorderColor = .black
            addButtonTextColor = .black
        }
        
        addFriendButton.backgroundColor = addButtonBackgroundColor
        addFriendButton.setTitleColor(addButtonTextColor, for: .normal)
        addFriendButton.layer.borderColor = addButtonBorderColor.cgColor
    }
    
    private func addFunction(){
        addFriendButton.addTarget(self, action: #selector(tapAddFriendButton), for: .touchDown)
        emailTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
    }
    
    @objc private func tapAddFriendButton(){
        request(email: emailTextField.text ?? "")
    }
    
    @objc private func textFieldChanged(_ sender: Any?) {
        let text = emailTextField.text ?? ""
        if text.isEmpty {
            addFriendButton.isEnabled = false
            addFriendButton.backgroundColor = addButtonBackgroundColor
            addFriendButton.layer.borderColor = addButtonBorderColor.cgColor
            addFriendButton.setTitleColor(addButtonTextColor, for: .normal)
        } else {
            addFriendButton.isEnabled = true
            addFriendButton.backgroundColor = UIColor.selectionColor
            addFriendButton.layer.borderColor = UIColor.selectionColor?.cgColor
            addFriendButton.setTitleColor(.black, for: .normal)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle == .dark {
            addButtonBackgroundColor = UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1.00)
            addButtonBorderColor = UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1.00)
            addButtonTextColor = UIColor(red: 0.26, green: 0.26, blue: 0.26, alpha: 1.00)
        } else {
            addButtonBackgroundColor = .clear
            addButtonBorderColor = .black
            addButtonTextColor = .black
        }
        
        let text = emailTextField.text ?? ""
        if text.isEmpty {
            addFriendButton.isEnabled = false
            addFriendButton.backgroundColor = addButtonBackgroundColor
            addFriendButton.layer.borderColor = addButtonBorderColor.cgColor
            addFriendButton.setTitleColor(addButtonTextColor, for: .normal)
        } else {
            addFriendButton.isEnabled = true
            addFriendButton.backgroundColor = UIColor.selectionColor
            addFriendButton.layer.borderColor = UIColor.selectionColor?.cgColor
            addFriendButton.setTitleColor(.black, for: .normal)
        }
    }
    
}
extension AddViewController{
    private func request(email: String){
        FriendService.shared.requestFriend(email: email) { (response) in
            let dimmingView = UIView(frame: UIScreen.main.bounds)
            dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            dimmingView.alpha = 0
            self.view.addSubview(dimmingView)
            dimmingView.snp.makeConstraints { make in
                make.left.right.top.bottom.equalToSuperview()
            }
            switch(response){
            case .success(let data):
                if let result = data as? ResultCodeResponse{
                    if result.resultCode == 200 {
                        self.present(self.popupVC, animated: false)
                    }else{
                        print("request friend error")
                    }
                }
                
            case .failure(let error):
                print(error)
            
            }
        }
    }
}
