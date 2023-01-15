//
//  VerificationCodeForSignUpViewController.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/09.
//

import UIKit

class VerificationCodeForSignUpViewController :UIViewController{
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var wrongCodeLabel: UILabel!
    var email:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(email ?? "")
        textFieldSetting()
    }
    
    @IBAction func tapNextButton(_ sender: Any) {
        RegisterService.shared.checkVerificationCode(email: email ?? "", code: codeTextField.text ?? "") { (response) in
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
            }
        }
    }
    
    @IBAction func tapPreButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }

    func textFieldSetting(){
        codeTextField.defaultTextAttributes.updateValue(45.0, forKey: NSAttributedString.Key.kern)
        codeTextField.borderStyle = .line
    }
}
