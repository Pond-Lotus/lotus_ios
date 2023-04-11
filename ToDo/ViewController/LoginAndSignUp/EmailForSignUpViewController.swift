//
//  EmailForSignUpViewController.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/06.
//

import UIKit

class EmailForSignUpViewController : UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var isValidLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var emailCheckImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isValid:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailCheckImageView.isHidden = true
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        activityIndicator.isHidden = true
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
    }
    
    @IBAction func tapNextButton(_ sender: Any) {
        if emailTextField.text != ""{
            checkEmail()
        }
    }
    
    @IBAction func tapPreButton(_ textfield: UITextField) {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @objc func textFieldDidChange(){
        
        if isValidEmail(testStr: emailTextField.text ?? "") {
            emailCheckImageView.isHidden = false
        }else{
            emailCheckImageView.isHidden = true
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    private func checkEmail(){
        nextButton.isEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        RegisterService.shared.checkValidEamil(email: emailTextField.text ?? "") { (response) in
            switch(response){
            case .success(let resultData):
                //해당 구조체 타입으로 옵셔널 바인딜
                if let data = resultData as? ResponseData{
                    print(data.resultCode)
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    if data.resultCode == 200 {
                        self.nextButton.isEnabled = true
                        self.isValidLabel.isHidden = true
                        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VerificationCodeForSignUpViewController") as? VerificationCodeForSignUpViewController else {return}
                        viewController.modalPresentationStyle = .fullScreen
                        viewController.email = self.emailTextField.text
                        self.present(viewController, animated: false)
                    }else{
                        self.nextButton.isEnabled = true
                        self.isValidLabel.isHidden = false
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
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view?.endEditing(true)
        print("touch")
    }
}


