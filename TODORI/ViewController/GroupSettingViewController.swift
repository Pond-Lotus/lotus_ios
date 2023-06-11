//
//  GroupSettingViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/15.
//

import UIKit

class GroupSettingViewController: UIViewController {
    var firstGroupName: String?
    var secondGroupName: String?
    var thirdGroupName: String?
    var fourthGroupName: String?
    var fifthGroupName: String?
    var sixthGroupName: String?
    
    private func createStackView(image: String, text: String, tag: Int) -> UIStackView {
        let stackView = UIStackView()

        stackView.axis = .horizontal
        stackView.snp.makeConstraints() { make in
            make.width.equalTo(500)
            make.height.equalTo(60)
        }
        
        let imageView = UIImageView(image: UIImage(named: image))
        imageView.contentMode = .scaleAspectFit
        stackView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(23)
            make.height.equalTo(23)
        }
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        let button = UIButton()
        button.setImage(UIImage(named: "edit-group")?.resize(to: CGSize(width: 19, height: 19)), for: .normal)
        button.titleLabel?.text = image + "," + text + "," + String(tag)
        button.addTarget(self, action: #selector(groupTapped), for: .touchUpInside)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        
        if let index = stackView.arrangedSubviews.firstIndex(of:    label) {
            stackView.setCustomSpacing(16, after: stackView.arrangedSubviews[index - 1])
        }
        
        return stackView
    }
    
    private let changePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle(" 비밀번호 변경", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        let image = UIImage(named: "setting")?.resize(to: CGSize(width: 23, height: 23))
        button.setImage(image, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NavigationBarManager.shared.removeSeparatorView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    private func setupUI() {
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction:  #selector(backButtonTapped), title: "그룹 설정")
        
        //        let stackView1 = UIStackView(arrangedSubviews: [changePasswordButton, notificationButton, changeThemeButton])
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        
        if let first = firstGroupName, let second = secondGroupName, let third = thirdGroupName, let fourth = fourthGroupName, let fifth = fifthGroupName, let sixth = sixthGroupName {
            let firstStackView = createStackView(image: "red-circle", text: first, tag: 1)
            let secondStackView = createStackView(image: "yellow-circle", text: second, tag: 2)
            let thirdStackView = createStackView(image: "green-circle", text: third, tag: 3)
            let fourthStackView = createStackView(image: "blue-circle", text: fourth, tag: 4)
            let fifthStackView = createStackView(image: "pink-circle", text: fifth, tag: 5)
            let sixthStackView = createStackView(image: "purple-circle", text: sixth, tag: 6)
            
            for _ in 1...6 { underlineViews.append(createUnderlineView()) }
            underlineViews.forEach { view.addSubview($0) }
            
            mainStackView.addArrangedSubview(firstStackView)
            mainStackView.addArrangedSubview(underlineViews[0])
            mainStackView.addArrangedSubview(secondStackView)
            mainStackView.addArrangedSubview(underlineViews[1])
            mainStackView.addArrangedSubview(thirdStackView)
            mainStackView.addArrangedSubview(underlineViews[2])
            mainStackView.addArrangedSubview(fourthStackView)
            mainStackView.addArrangedSubview(underlineViews[3])
            mainStackView.addArrangedSubview(fifthStackView)
            mainStackView.addArrangedSubview(underlineViews[4])
            mainStackView.addArrangedSubview(sixthStackView)
            mainStackView.addArrangedSubview(underlineViews[5])
            
            view.addSubview(mainStackView)
            mainStackView.snp.makeConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(14)
                make.leading.equalToSuperview().offset(28)
                make.trailing.equalToSuperview().offset(-28)
            }
            
            underlineViews.forEach { underline in
                underline.snp.makeConstraints { make in
                    //                make.leading.equalToSuperview().offset(17)
                    make.height.equalTo(1.0)
                }
            }
        }
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func groupTapped(_ sender: UIButton) {
        if let string = sender.titleLabel?.text {
            let components = string.components(separatedBy: ",")
            let color = components[0]
            let label = components[1]
            let index = components[2]
            
            let editGroupSettingVC = EditGroupSettingViewController()
            editGroupSettingVC.color = color
            editGroupSettingVC.label = label
            editGroupSettingVC.index = index
            
            editGroupSettingVC.firstGroupName = self.firstGroupName
            editGroupSettingVC.secondGroupName = self.secondGroupName
            editGroupSettingVC.thirdGroupName = self.thirdGroupName
            editGroupSettingVC.fourthGroupName = self.fourthGroupName
            editGroupSettingVC.fifthGroupName = self.fifthGroupName
            editGroupSettingVC.sixthGroupName = self.sixthGroupName
            
            navigationController?.pushViewController(editGroupSettingVC, animated: true)
        } else {
            print("문자열 에러")
        }
    }
    
    private var underlineViews: [UIView] = []
    
    private func createUnderlineView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

extension GroupSettingViewController {
    
}
