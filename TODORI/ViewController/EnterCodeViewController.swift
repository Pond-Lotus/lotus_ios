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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "전송된 인증코드를\n입력해 주세요"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "인증코드"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
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
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        codeTextField.delegate = self
        
        setupUI()
        
        codeTextField.becomeFirstResponder()
        let inputlabels = [firstLabel, secondLabel, thirdLabel, fourthLabel, fifthLabel, sixthLabel]
        inputlabels.forEach { label in
            label.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped)) // 모든 라벨에 대해 제스처를 추가하기 위해서는 tapGesture 객체를 라벨마다 새로 생성해야 합니다.
            label.addGestureRecognizer(tapGesture)
        }
        
        //        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
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
            if let navigationBarHeight = navigationController?.navigationBar.frame.height {
                make.top.equalToSuperview().offset(navigationBarHeight + 40)
            }
//            make.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.15)
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
            make.bottom.equalToSuperview().offset(-UIScreen.main.bounds.height * 0.02)
        }
    }
    
    @objc func labelTapped() {
        codeTextField.becomeFirstResponder()
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        //        dismiss(animated: true, completion: nil) // 이전 뷰 컨트롤러로 이동
    }
    
    @objc func nextButtonTapped() {
        if let code = codeTextField.text, let email = UserSession.shared.signUpEmail {
            print("email: \(email)")
            print("code: \(code)")
            codeCheck(email: email, code: code)
        } else {
            print("이메일 또는 코드 값이 없습니다.")
        }
    }
}

extension EnterCodeViewController {
    func codeCheck(email: String, code: String) {
        UserService.shared.codeCheck(email: email, code: code) { result in
            switch result {
            case .success(let data):
                if let data = data as? ResultCodeResponse {
                    if data.resultCode == 200 {
                        print("이백")
                        self.errorLabel.isHidden = true
                        self.navigationController?.pushViewController(EnterProfileViewController(), animated: true)
                    } else if data.resultCode == 500 {
                        print("오백")
                        self.errorLabel.isHidden = false
                    }
                }
            case .failure:
                print("FUCKING failure")
            }
        }
    }
}

extension EnterCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        print("updatedText : \(updatedText)")
        
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
            //            textField.resignFirstResponder()
        }
        return updatedText.count <= 6
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if fifthLabel.text != "" {
            print("Fifth")
        }
        if sixthLabel.text !=  "" {
            print("Sixth")
            textField.resignFirstResponder()
        }
        return true
    }
}
