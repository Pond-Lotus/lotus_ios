//
//  TwoButtonPopupViewController.swift
//  TODORI
//
//  Created by 제이콥 on 4/19/24.
//

import UIKit

class TwoButtonPopupViewController: UIViewController {
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
    var negativeActionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.textColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    var positiveActionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.textColor, for: .normal)
        button.backgroundColor = UIColor.mainColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
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
    var action: () -> Void = {}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI(){
        if self.traitCollection.userInterfaceStyle == .dark {
            negativeActionButton.backgroundColor = UIColor(white: 0.26, alpha: 1)
            positiveActionButton.backgroundColor = UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1.00)
        } else {
            negativeActionButton.backgroundColor = UIColor(white: 0.92, alpha: 1)
            positiveActionButton.backgroundColor = UIColor.mainColor
        }
        
        positiveActionButton.addTarget(self, action: #selector(positiveAction), for: .touchDown)
        negativeActionButton.addTarget(self, action: #selector(negativeAction), for: .touchDown)
        
        buttonStackView.addArrangedSubviews([negativeActionButton, positiveActionButton])
        popupBackgroundView.addSubViews([titleLabel, messageLabel, buttonStackView])
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
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(37)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
    }
    
    @objc private func positiveAction() {
        action()
    }
    
    @objc private func negativeAction() {
        self.dismiss(animated: false)
    }
}
