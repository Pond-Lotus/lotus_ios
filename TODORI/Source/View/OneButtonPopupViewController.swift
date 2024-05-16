//
//  CustomPopupView.swift
//  TODORI
//
//  Created by Dasol on 2023/05/12.
//

import UIKit

class OneButtonPopupViewController: UIViewController {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        label.textColor = UIColor.textColor
        return label
    }()
    var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = UIColor.textColor
        return label
    }()
    var actionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.textColor, for: .normal)
        button.backgroundColor = UIColor.mainColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    var popupBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.todoriWhite
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    var blackOpacityView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI(){
        actionButton.addTarget(self, action: #selector(tapActionButton), for: .touchDown)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            actionButton.backgroundColor = UIColor(red: 0.26, green: 0.26, blue: 0.27, alpha: 1.00)
        }
        
        popupBackgroundView.addSubViews([titleLabel, messageLabel, actionButton])
        self.view.addSubViews([blackOpacityView, popupBackgroundView])
        
        blackOpacityView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        popupBackgroundView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(63)
            make.right.equalToSuperview().offset(-63)
            make.height.equalTo(167)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(37)
            make.centerX.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(11)
            make.centerX.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(37)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
    }
    
    @objc private func tapActionButton() {
        self.dismiss(animated: false)
    }
}

