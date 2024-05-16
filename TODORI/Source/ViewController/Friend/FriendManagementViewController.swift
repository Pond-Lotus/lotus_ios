//
//  FriendManagementViewController.swift
//  TODORI
//
//  Created by 제임스 on 2023/10/04.
//

import UIKit
import SnapKit

class FriendManagementViewController: UIViewController{
    
    var myFriendButton: UIButton = ButtonManager.shared.getFriendManagementBlackButton(title: "나의 친구")
    var recievingRequestButton: UIButton = ButtonManager.shared.getFriendManagementGrayButton(title: "받은 요청")
    var addTextButton: UIButton = ButtonManager.shared.getFriendManagementGrayButton(title: "추가")
    var selectedBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.textColor
        return view
    }()
    var grayBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.line
        return view
    }()
    
    var redbutton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("버튼버튼", for: .normal)
        return button
    }()
    
    var buttonStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually
        stackview.contentMode = .scaleAspectFill
        return stackview
    }()
    
    var topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.todoriWhite
        return view
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "todori-back"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    var switchView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addFunction()
        changeView(viewController: MyFriendViewController())
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }


    
    private func setUI(){
        self.view.backgroundColor = UIColor.todoriWhite
    
//        addStackView.addArrangedSubviews([addTextButton, addImage])
        buttonStackView.addArrangedSubviews([myFriendButton, recievingRequestButton, addTextButton])
        self.topBarView.addSubview(backButton)
        self.view.addSubview(topBarView)
        self.view.addSubview(buttonStackView)
        self.view.addSubview(grayBarView)
        self.view.addSubview(selectedBarView)
        self.view.addSubview(switchView)
        
        topBarView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(22)
        }
                
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        grayBarView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom)
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
        
        selectedBarView.snp.makeConstraints { make in
            make.bottom.equalTo(grayBarView.snp.bottom)
            make.width.equalTo(self.view.fs_width/3)
            make.height.equalTo(2)
            make.left.equalToSuperview()
        }
        
        switchView.snp.makeConstraints { make in
            make.top.equalTo(grayBarView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        addTextButton.setImage(UIImage(named: "add-deselected"), for: .normal)
        addTextButton.semanticContentAttribute = .forceRightToLeft
        addTextButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
    }
    
    private func addFunction(){
        myFriendButton.addTarget(self, action: #selector(tapMyFriendButton), for: .touchDown)
        recievingRequestButton.addTarget(self, action: #selector(tapRecieveRequestButton), for: .touchDown)
        addTextButton.addTarget(self, action: #selector(tapAddButton), for: .touchDown)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func tapMyFriendButton(){
        myFriendButton.setTitleColor(.textColor, for: .normal)
        recievingRequestButton.setTitleColor(.gray, for: .normal)
        addTextButton.setTitleColor(.gray, for: .normal)
        addTextButton.setImage(UIImage(named: "add-deselected"), for: .normal)

        UIView.animate(withDuration: 0.2, animations: {
            self.selectedBarView.snp.remakeConstraints { make in
                make.bottom.equalTo(self.grayBarView.snp.bottom)
                make.width.equalTo(self.view.fs_width/3)
                make.height.equalTo(2)
                make.left.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        })
        
        changeView(viewController: MyFriendViewController())
    }
    
    @objc private func tapRecieveRequestButton(){
        myFriendButton.setTitleColor(.gray, for: .normal)
        recievingRequestButton.setTitleColor(.textColor, for: .normal)
        addTextButton.setTitleColor(.gray, for: .normal)
        addTextButton.setImage(UIImage(named: "add-deselected"), for: .normal)

        UIView.animate(withDuration: 0.2, animations: {
            self.selectedBarView.snp.remakeConstraints { make in
                make.bottom.equalTo(self.grayBarView.snp.bottom)
                make.width.equalTo(self.view.fs_width/3)
                make.height.equalTo(2)
                make.centerX.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        })
        
        changeView(viewController: RecievedRequestViewController())

    }
    
    @objc private func tapAddButton(){
        myFriendButton.setTitleColor(.gray, for: .normal)
        recievingRequestButton.setTitleColor(.gray, for: .normal)
        addTextButton.setTitleColor(.textColor, for: .normal)
        addTextButton.setImage(UIImage(named: "add-selected"), for: .normal)

        UIView.animate(withDuration: 0.2, animations: {
            self.selectedBarView.snp.remakeConstraints { make in
                make.bottom.equalTo(self.grayBarView.snp.bottom)
                make.width.equalTo(self.view.fs_width/3)
                make.height.equalTo(2)
                make.right.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        })

        changeView(viewController: AddViewController())
    }
    
    private func changeView(viewController: UIViewController){
        let viewController = viewController
        guard let view = viewController.view else {return}
        
        for view in self.switchView.subviews{
            view.removeFromSuperview()
        }
        for viewController in self.children{
            viewController.removeFromParent()
        }
        
        switchView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(switchView)
        }
        self.addChild(viewController)
        
    }
    
    private func setColorsByUserInterfaceStyle(){

    }
}
