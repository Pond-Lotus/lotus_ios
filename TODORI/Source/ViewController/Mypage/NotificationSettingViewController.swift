//
//  NotificationSettingViewController.swift
//  TODORI
//
//  Created by 제임스 on 2023/06/21.
//

import UIKit
import UserNotifications

class NotificationViewController: UIViewController{
    private let notificationTurnOnAndOffLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "알림 켜기/끄기"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let notificationSwitch: UISwitch = {
        let notificationSwitch: UISwitch = UISwitch()
        notificationSwitch.addTarget(NotificationViewController.self, action: #selector(tapSwitch(sender:)), for: .valueChanged)
        return notificationSwitch
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNotificationSetting()
        setUI()
    }
    
    private func setUI(){
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction:  #selector(backButtonTapped), title: "알림 설정", showSeparator: false)
        self.view.backgroundColor = .white

        self.view.addSubview(notificationTurnOnAndOffLabel)
        self.view.addSubview(notificationSwitch)
        
        notificationTurnOnAndOffLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(32)
            make.left.equalToSuperview().offset(26)
        }
        
        notificationSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(notificationTurnOnAndOffLabel)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    private func userNotificationSetting(){
        UNUserNotificationCenter.current().getNotificationSettings { setting in
            switch setting.authorizationStatus{
            case .authorized:
                DispatchQueue.main.async {
                    self.notificationSwitch.isOn = true
                }
            case .denied:
                DispatchQueue.main.async {
                    self.notificationSwitch.isOn = false
                }
            default: break
            }
        }
    }
    @objc func tapSwitch(sender: UISwitch){
        if sender.isOn {
            
        }else {
            
        }
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
