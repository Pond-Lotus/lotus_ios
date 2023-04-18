//
//  VerificationCodeForSignUpViewController.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/09.
//

import UIKit

class VerificationCodeForSignUpViewController :UIViewController {
    @IBOutlet weak var wrongCodeLabel: UILabel!
    var email:String?
    
    
    @IBOutlet weak var numberPad1: UITextField!
    @IBOutlet weak var numberPad2: UITextField!
    @IBOutlet weak var numberPad3: UITextField!
    @IBOutlet weak var numberPad4: UITextField!
    @IBOutlet weak var numberPad5: UITextField!
    @IBOutlet weak var numberPad6: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberPadSetting()
        
        numberPad1.becomeFirstResponder()
        numberPad1.addTarget(self, action: #selector(numberPad1DidChange), for: .editingChanged)
        numberPad2.addTarget(self, action: #selector(numberPad2DidChange), for: .editingChanged)
        numberPad3.addTarget(self, action: #selector(numberPad3DidChange), for: .editingChanged)
        numberPad4.addTarget(self, action: #selector(numberPad4DidChange), for: .editingChanged)
        numberPad5.addTarget(self, action: #selector(numberPad5DidChange), for: .editingChanged)
        numberPad6.addTarget(self, action: #selector(numberPad6DidChange), for: .editingChanged)
    }
    
    @IBAction func tapNextButton(_ sender: Any) {
        guard let num1 = numberPad1.text else {return}
        guard let num2 = numberPad2.text else {return}
        guard let num3 = numberPad3.text else {return}
        guard let num4 = numberPad4.text else {return}
        guard let num5 = numberPad5.text else {return}
        guard let num6 = numberPad6.text else {return}
        
        let code = num1 + num2 + num3 + num4 + num5 + num6
        print(code)
        
        RegisterService.shared.checkVerificationCode(email: email ?? "", code: code) { (response) in
            switch(response){
            case .success(let resultData):
                if let data = resultData as? ResponseData{
                    print(data.resultCode)
                    if data.resultCode == 200 {
                        self.wrongCodeLabel.isHidden = true
                        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileSettingForSignUpViewController") as? ProfileSettingForSignUpViewController else {return}
                        nextViewController.modalPresentationStyle = .fullScreen
                        nextViewController.email = self.email
                        self.present(nextViewController, animated: false)
                    }else{
                        print("verification code is incorrect")
                        self.wrongCodeLabel.isHidden = false
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
    
    @IBAction func tapPreButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    private func numberPadDid(){
        
    }

    @objc func numberPad1DidChange(){
        if numberPad1.text?.count ?? 0 > 0 {
            numberPad2.becomeFirstResponder()
        }
    }
    @objc func numberPad2DidChange(){
        if numberPad2.text?.count ?? 0 > 0 {
            numberPad3.becomeFirstResponder()
        } else {
            numberPad1.becomeFirstResponder()
        }
    }
    @objc func numberPad3DidChange(){
        if numberPad3.text?.count ?? 0 > 0 {
            numberPad4.becomeFirstResponder()
        } else {
            numberPad2.becomeFirstResponder()
        }
    }
    @objc func numberPad4DidChange(){
        if numberPad4.text?.count ?? 0 > 0 {
            numberPad5.becomeFirstResponder()
        } else {
            numberPad3.becomeFirstResponder()
        }
    }
    @objc func numberPad5DidChange(){
        if numberPad5.text?.count ?? 0 > 0 {
            numberPad6.becomeFirstResponder()
        } else {
            numberPad4.becomeFirstResponder()
        }
    }
    @objc func numberPad6DidChange(){
        if numberPad6.text?.count ?? 0 < 1 {
            numberPad5.becomeFirstResponder()
        }
    }
    
    private func numberPadSetting(){
        numberPad1.clipsToBounds = true
        numberPad1.layer.cornerRadius = 10
        numberPad2.clipsToBounds = true
        numberPad2.layer.cornerRadius = 10
        numberPad3.clipsToBounds = true
        numberPad3.layer.cornerRadius = 10
        numberPad4.clipsToBounds = true
        numberPad4.layer.cornerRadius = 10
        numberPad5.clipsToBounds = true
        numberPad5.layer.cornerRadius = 10
        numberPad6.clipsToBounds = true
        numberPad6.layer.cornerRadius = 10
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view?.endEditing(true)
        print("touch")
    }
}
