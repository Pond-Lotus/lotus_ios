//
//  ProfileSettingForSignUpViewController.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/09.
//

import UIKit

class ProfileSettingForSignUpViewController:UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwCheckTextField: UITextField!
    
    var email:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = email
    }
    
    @IBAction func tapFinishButton(_ sender: Any) {
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
    
    
    func doRegister(){
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
                
            }
        }
    }
}
