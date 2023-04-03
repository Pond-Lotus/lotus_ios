//
//  EditPWViewController.swift
//  ToDo
//
//  Created by 제임스 on 2023/03/07.
//

import UIKit

class EditPWViewController:UIViewController{
    
    @IBOutlet weak var originPwTextField: UITextField!
    @IBOutlet weak var newPwTextField: UITextField!
    @IBOutlet weak var newPwCheckTextField: UITextField!
    @IBOutlet weak var originPwErrorLabel: UILabel!
    @IBOutlet weak var newPwErrorLabel: UILabel!
    @IBOutlet weak var newPwCheckErrorLabel: UILabel!
    
    var isPwCheckOK = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabelSetting()
    }
    
    private func errorLabelSetting(){
        self.originPwErrorLabel.isHidden = true
        self.newPwErrorLabel.isHidden = true
        self.newPwCheckErrorLabel.isHidden = true
    }
    @IBAction func tapFinishButton(_ sender: Any) {
        if isPwCheckOK{
            guard let originPW = originPwTextField.text else {return}
            guard let newPW = newPwCheckTextField.text else {return}
            
            UserInfoService.shared.editPassword(originPW: originPW, newPW: newPW) { (response) in
                switch (response){
                case .success(let resultData):
                    if let data = resultData as? ResponseData{
                        print(data.resultCode)
                        if data.resultCode == 200 {
                            self.presentingViewController?.dismiss(animated: false)
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
    
    @IBAction func didPwCheck(_ sender: Any) {
        if newPwTextField.text != newPwCheckTextField.text{
            self.newPwCheckErrorLabel.isHidden = false
            self.isPwCheckOK = false
        }else{
            self.newPwCheckErrorLabel.isHidden = true
            self.isPwCheckOK = true
        }
    }
    
    @IBAction func tapPreButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
}
