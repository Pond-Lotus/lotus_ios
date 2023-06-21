//
//  EnterCodeViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/05/02.
//

import UIKit

class EnterCodeViewController: UIViewController {
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "2/3"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "전송된 인증코드를\n입력해 주세요"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "인증코드"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        return label
    }()
    
    private let codeTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        textField.becomeFirstResponder()
        return textField
    }()
    
    private let firstLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 41).isActive = true
        label.heightAnchor.constraint(equalToConstant: 53).isActive = true
        
        return label
    }()
    
    private let secondLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 41).isActive = true
        label.heightAnchor.constraint(equalToConstant: 53).isActive = true
        
        return label
    }()
    
    private let thirdLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 41).isActive = true
        label.heightAnchor.constraint(equalToConstant: 53).isActive = true
        
        return label
    }()
    
    private let fourthLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 41).isActive = true
        label.heightAnchor.constraint(equalToConstant: 53).isActive = true
        
        return label
    }()
    
    private let fifthLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 41).isActive = true
        label.heightAnchor.constraint(equalToConstant: 53).isActive = true
        
        return label
    }()
    
    private let sixthLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0.913, green: 0.913, blue: 0.913, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 41).isActive = true
        label.heightAnchor.constraint(equalToConstant: 53).isActive = true
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        //        stack.spacing = 1
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "유효하지 않은 인증코드입니다."
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let nextButton: UIButton = {
        return ButtonManager.shared.getNextButton()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        codeTextField.delegate = self
        navigationController?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        setupTapGesture()
        setupUI()
    }
    
    private func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing)))
        
        let inputlabels = [firstLabel, secondLabel, thirdLabel, fourthLabel, fifthLabel, sixthLabel]
        inputlabels.forEach { label in
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped)))
        }
    }
    
    private func setupUI() {
        NavigationBarManager.shared.setupNavigationBar(for: self, backButtonAction: #selector(backButtonTapped), title: "", showSeparator: false)
        
        view.addSubview(numberLabel)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(codeTextField)
        view.addSubview(errorLabel)
        view.addSubview(stackView)
        stackView.addArrangedSubview(firstLabel)
        stackView.addArrangedSubview(secondLabel)
        stackView.addArrangedSubview(thirdLabel)
        stackView.addArrangedSubview(fourthLabel)
        stackView.addArrangedSubview(fifthLabel)
        stackView.addArrangedSubview(sixthLabel)
        view.addSubview(nextButton)
        
        numberLabel.snp.makeConstraints { make in
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let topSafeAreaHeight = windowScene.windows.first?.safeAreaInsets.top,
               let navigationBarHeight = navigationController?.navigationBar.frame.height {
                let totalHeight = topSafeAreaHeight + navigationBarHeight
                make.top.equalToSuperview().offset(totalHeight + 40)
            }
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }
        
        codeTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-100)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
            make.trailing.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.06)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
            make.trailing.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.06)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(UIScreen.main.bounds.width * 0.06)
        }
        
        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-UIScreen.main.bounds.width * 0.04)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
        }
    }
    
    @objc func labelTapped() {
        codeTextField.becomeFirstResponder()
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonTapped() {
        if let code = codeTextField.text, let email = UserSession.shared.signUpEmail {
            self.nextButton.isEnabled = false
            print(code)
            codeCheck(email: email, code: code)
        }
    }
}

extension EnterCodeViewController {
    func codeCheck(email: String, code: String) {
        UserService.shared.codeCheck(email: email, code: code) { result in
            switch result {
            case .success(let data):
                self.nextButton.isEnabled = true
                if data.resultCode == 200 {
                    print("이백")
                    self.errorLabel.isHidden = true
                    self.navigationController?.pushViewController(EnterProfileViewController(), animated: true)
                } else if data.resultCode == 500 {
                    print("오백")
                    self.errorLabel.isHidden = false
                }
            case .failure:
                print("failure")
                self.nextButton.isEnabled = true
                self.errorLabel.isHidden = false
            }
        }
    }    
}

extension EnterCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
                
        if updatedText.isEmpty {
            firstLabel.text = ""
        } else if updatedText.count == 1 {
            firstLabel.text = String(updatedText[updatedText.index(updatedText.startIndex, offsetBy: 0)])
            secondLabel.text = ""
        } else if updatedText.count == 2 {
            secondLabel.text = String(updatedText[updatedText.index(updatedText.startIndex, offsetBy: 1)])
            thirdLabel.text = ""
        } else if updatedText.count == 3 {
            thirdLabel.text = String(updatedText[updatedText.index(updatedText.startIndex, offsetBy: 2)])
            fourthLabel.text = ""
        } else if updatedText.count == 4 {
            fourthLabel.text = String(updatedText[updatedText.index(updatedText.startIndex, offsetBy: 3)])
            fifthLabel.text = ""
        } else if updatedText.count == 5 {
            fifthLabel.text = String(updatedText[updatedText.index(updatedText.startIndex, offsetBy: 4)])
            sixthLabel.text = ""
        } else if updatedText.count == 6 {
            sixthLabel.text = String(updatedText[updatedText.index(updatedText.startIndex, offsetBy: 5)])
            DispatchQueue.main.async {
                textField.resignFirstResponder()
            }
        }
        return updatedText.count <= 6
    }
}

extension EnterCodeViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}

extension EnterCodeViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
