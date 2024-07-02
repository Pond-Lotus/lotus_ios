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
        label.textColor = UIColor.textColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let notificationSwitch: UISwitch = {
        let notificationSwitch: UISwitch = UISwitch()
        notificationSwitch.onTintColor = UITraitCollection.current.userInterfaceStyle == .light ? UIColor.mainBeige : UIColor.todoriOrange
        return notificationSwitch
    }()

    
    private let grayLine: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.dg04
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("will apeear")
        initialSettingOfSwitch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("did appear")
    }
    
    private func setUI(){
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction:  #selector(backButtonTapped), title: "알림 설정", showSeparator: false)
        self.view.backgroundColor = UITraitCollection.current.userInterfaceStyle == .light ? .white : UIColor(red: 0.196, green: 0.192, blue: 0.204, alpha: 1)

        self.view.addSubview(notificationTurnOnAndOffLabel)
        self.view.addSubview(notificationSwitch)
        self.view.addSubview(grayLine)
        
        
        notificationTurnOnAndOffLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(32)
            make.left.equalToSuperview().offset(26)
        }
        
        notificationSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(notificationTurnOnAndOffLabel)
            make.right.equalToSuperview().offset(-20)
        }
        
        grayLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.right.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(notificationTurnOnAndOffLabel.snp.bottom).offset(24)
        }
        
    }
    
    private func initialSettingOfSwitch(){
        UNUserNotificationCenter.current().getNotificationSettings { permission in
            let localPermission: String = UserDefaults.standard.string(forKey: "notificationPermission") ?? ""
            
            var authorizationStatus: Bool = false
            switch permission.authorizationStatus {
            case .notDetermined, .authorized, .ephemeral:
                //시스템 설정이 on이지만 자체 설정이 off면 끄기. 이 외의 상황은 on
                if localPermission == "denied" {
                    authorizationStatus = false
                } else {
                    authorizationStatus = true
                }
            case .provisional, .denied:
                //시스템 설정이 off면 무조건 off
                authorizationStatus = false
            @unknown default:
                print("error")
            }
            
            DispatchQueue.main.async {
                self.notificationSwitch.isOn = authorizationStatus
                UserDefaults.standard.set(authorizationStatus ? "authorized" : "denied", forKey: "notificationPermission")
                self.notificationTurnOnAndOffLabel.textColor = authorizationStatus ? UIColor.textColor : UIColor.dg02
            }
        }
        self.notificationSwitch.addTarget(self, action: #selector(tapSwitch), for: .valueChanged)
    }

    @objc func tapSwitch(){
        if self.notificationSwitch.isOn {
            ToDoMainViewController().initNotification()
            self.notificationTurnOnAndOffLabel.textColor = UIColor.textColor
            UserDefaults.standard.set("authorized", forKey: "notificationPermission")
            UNUserNotificationCenter.current().getNotificationSettings { permission in
                switch permission.authorizationStatus {
                case .authorized:
                    break
                default:
                    guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {return}
                    if UIApplication.shared.canOpenURL(settingURL) {
                        DispatchQueue.main.async {
                            UIApplication.shared.open(settingURL)
                        }
                    } else {
                        print("cant open")
                    }
                }
            }
            
        } else {
            self.notificationTurnOnAndOffLabel.textColor = UIColor.dg02
            UserDefaults.standard.set("denied", forKey: "notificationPermission")
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
