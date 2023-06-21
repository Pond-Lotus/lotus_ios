//
//  GroupSettingViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/15.
//

import UIKit

class GroupSettingViewController: UIViewController {
    private var mainStackView = UIStackView()
    
    private func createStackView(image: String, text: String, tag: Int) -> UIStackView {
        let imageView = UIImageView(image: UIImage(named: image))
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.width.equalTo(23)
        }
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        let button = UIButton()
        button.titleLabel?.text = image + "," + text + "," + String(tag)
        button.setImage(UIImage(named: "edit-group")?.resize(to: CGSize(width: 19, height: 19)), for: .normal)
        button.addTarget(self, action: #selector(groupTapped), for: .touchUpInside)
        button.contentHorizontalAlignment = .trailing
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        view.addSubview(stackView)
        stackView.snp.makeConstraints() { make in
            make.width.equalToSuperview()
            make.height.equalTo(60)
        }
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        stackView.setCustomSpacing(16, after: imageView)
        
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
        
        navigationController?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        mainStackView.removeFromSuperview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    private func setupUI() {
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction:  #selector(backButtonTapped), title: "그룹 설정", showSeparator: false)
        
        guard let first = GroupData.shared.firstGroupName,
              let second = GroupData.shared.secondGroupName,
              let third = GroupData.shared.thirdGroupName,
              let fourth = GroupData.shared.fourthGroupName,
              let fifth = GroupData.shared.fifthGroupName,
              let sixth = GroupData.shared.sixthGroupName
        else { return }
        
        let firstStackView = createStackView(image: "red-circle", text: first, tag: 1)
        let secondStackView = createStackView(image: "yellow-circle", text: second, tag: 2)
        let thirdStackView = createStackView(image: "green-circle", text: third, tag: 3)
        let fourthStackView = createStackView(image: "blue-circle", text: fourth, tag: 4)
        let fifthStackView = createStackView(image: "pink-circle", text: fifth, tag: 5)
        let sixthStackView = createStackView(image: "purple-circle", text: sixth, tag: 6)
        
        var underlineViews: [UIView] = []
        for _ in 1...6 { underlineViews.append(createUnderlineView()) }
        underlineViews.forEach { view.addSubview($0) }

        mainStackView = UIStackView() // 있고 없고 차이 발생
        mainStackView.axis = .vertical
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
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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
            navigationController?.pushViewController(editGroupSettingVC, animated: true)
        }
    }
    
    private func createUnderlineView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        view.snp.makeConstraints { make in
            make.height.equalTo(1.0)
        }
        return view
    }
}

extension GroupSettingViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}

extension GroupSettingViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
