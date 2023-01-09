//
//  EnterEmailViewController.swift
//  ToDo
//
//  Created by KDS on 2023/01/09.
//

import UIKit

class EnterEmailViewController : UIViewController
{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 20
        nextButton.isEnabled = false
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // 화면을 켰을 때 커서가 있는 위치
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        let email = emailTextField.text ?? "" // optional?
        let password = passwordTextField.text ?? ""
        let passwordCheck = passwordCheckTextField.text ?? ""
        
        print(email)
        
        if password == passwordCheck
        {
            self.showMainViewController()
        }
        else
        {
            self.errorMessageLabel.text = "비밀번호가 일치하지 않습니다."
        }

    }
    
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(mainViewController, sender: nil)
    }
    
}

extension EnterEmailViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailTextField.text == ""
        let isPasswordEmpty = passwordTextField.text == ""
        let isPasswordCheckEmpty = passwordTextField.text == ""

        nextButton.isEnabled = !isEmailEmpty && !isPasswordEmpty && !isEmailEmpty && (passwordTextField.text == passwordCheckTextField.text)
    }
}
