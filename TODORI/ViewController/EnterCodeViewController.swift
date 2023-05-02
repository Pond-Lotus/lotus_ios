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
        textField.backgroundColor = .orange
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
        stack.spacing = 18.8
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
        return label
    }()
        
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("이전", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        button.layer.cornerRadius = 18
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1)
        button.layer.cornerRadius = 18
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        codeTextField.delegate = self
        
        setUI()
        
        let inputlabels = [firstLabel, secondLabel, thirdLabel, fourthLabel, fifthLabel, sixthLabel]
        inputlabels.forEach { label in
            label.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped)) // 모든 라벨에 대해 제스처를 추가하기 위해서는 tapGesture 객체를 라벨마다 새로 생성해야 합니다.
            label.addGestureRecognizer(tapGesture)
        }
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

    }
    
    private func setUI() {
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
        view.addSubview(backButton)
        view.addSubview(nextButton)
        
        numberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.15)
            make.leading.equalToSuperview().offset(25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(25)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(25)
        }
        
        codeTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(25)
        }
        
        backButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(21)
            make.width.equalTo(77)
            make.height.equalTo(38)
        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24)
            make.trailing.equalToSuperview().offset(-21)
            make.width.equalTo(77)
            make.height.equalTo(38)
        }
    }
    
    @objc func labelTapped() {
        codeTextField.becomeFirstResponder()
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil) // 이전 뷰 컨트롤러로 이동
    }
    
    @objc func nextButtonTapped() {
        let viewControllerToPresent = EnterProfileViewController() // 이동할 뷰 컨트롤러 인스턴스 생성
        viewControllerToPresent.modalPresentationStyle = .fullScreen // 화면 전체를 차지하도록 설정
        viewControllerToPresent.modalTransitionStyle = .coverVertical // coverHorizontal 스타일 적용

        present(viewControllerToPresent, animated: true, completion: nil) // 뷰 컨트롤러 이동
    }

}


extension EnterCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldString = textField.text, let newRange = Range(range, in: oldString) else { return true }
        
        let inputString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)
        print("inputString : \(inputString)")
        print("newString : \(newString)")
        if newString.isEmpty {
            firstLabel.text = ""
        } else if newString.count == 1 {
            firstLabel.text = String(newString[newString.index(newString.startIndex, offsetBy: 0)])
            secondLabel.text = ""
        } else if newString.count == 2 {
            secondLabel.text = String(newString[newString.index(newString.startIndex, offsetBy: 1)])
            thirdLabel.text = ""
        } else if newString.count == 3 {
            thirdLabel.text = String(newString[newString.index(newString.startIndex, offsetBy: 2)])
            fourthLabel.text = ""
        } else if newString.count == 4 {
            fourthLabel.text = String(newString[newString.index(newString.startIndex, offsetBy: 3)])
            fifthLabel.text = ""
        } else if newString.count == 5 {
            fifthLabel.text = String(newString[newString.index(newString.startIndex, offsetBy: 4)])
            sixthLabel.text = ""
        } else if newString.count == 6 {
            sixthLabel.text = String(newString[newString.index(newString.startIndex, offsetBy: 5)])
        }
        return newString.count <= 6
    }
}
