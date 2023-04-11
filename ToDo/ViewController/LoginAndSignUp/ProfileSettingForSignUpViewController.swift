//
//  ProfileSettingForSignUpViewController.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/09.
//

import UIKit

class ProfileSettingForSignUpViewController:UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    var email:String?
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwCheckTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var pwRuleErrorLabel: UILabel!
    @IBOutlet weak var pwCheckErrorLabel: UILabel!
    
    var keyHeight:CGFloat?
    var isValidPassword = false
    var isPasswordCheckOk = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfieldViewSetting()
        emailTextField.text = email
        nicknameTextField.becomeFirstResponder()
        pwTextField.addTarget(self, action: #selector(pwRuleCheck), for: .editingChanged)
        pwCheckTextField.addTarget(self, action: #selector(pwCheck), for: .editingChanged)
    }
    
    @IBAction func tapNextButton(_ sender: Any) {
        if pwTextField.text == pwCheckTextField.text{
            print("password check OK")
            doRegister()
        }else{
            print("passwords are not same")
        }
    }
    
    
    @IBAction func tapPreButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
        
    }
    
    @objc func pwRuleCheck(){
        if isValidPassword(testStr: pwTextField.text ?? ""){
            pwRuleErrorLabel.isHidden = true
            isValidPassword = true
        }else {
            pwRuleErrorLabel.isHidden = false
            isValidPassword = false
        }
    }
    
    @objc func pwCheck(){
        if pwTextField.text ?? "" == pwCheckTextField.text ?? "" {
            pwCheckErrorLabel.isHidden = true
            isPasswordCheckOk = true
        } else {
            pwCheckErrorLabel.isHidden = false
            isPasswordCheckOk = false
        }
    }
    
    func isValidPassword(testStr:String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,15}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return emailTest.evaluate(with: testStr)
    }
    
    private func textfieldViewSetting(){
        emailTextField.clipsToBounds = true
        emailTextField.layer.cornerRadius = 8
    }
    
    func doRegister(){
        if isValidPassword && isPasswordCheckOk{
            RegisterService.shared.register(nickname: nicknameTextField.text ?? "", email: email ?? "", password: pwTextField.text ?? "") { (response) in
                switch (response){
                case .success(let resultData):
                    if let data = resultData as? RegisterResponseData{
                        print(data.resultCode)
                        if data.resultCode == 200{
                            guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "FinishRegisterVeiwController") as? FinishRegisterVeiwController else {return}
                            nextViewController.modalPresentationStyle = .fullScreen
                            nextViewController.nickname = data.account.nickname
                            self.present(nextViewController, animated: false)
                        }
                    }
                case .requestErr(let message):
                    print("requestErr", message)
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
                case .decodeErr:
                    print("decodeErr")
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.scrollView?.endEditing(true)
        print("touch")
    }
    
}
