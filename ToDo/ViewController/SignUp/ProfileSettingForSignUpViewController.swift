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
    
    var keyHeight:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = email
        
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillShow),
//            name: UIResponder.keyboardWillShowNotification,
//            object: nil)
//
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillHide),
//            name: UIResponder.keyboardWillHideNotification,
//            object: nil)
        
//        scrollView.frame.size.height = UIScreen.main.bounds.height - 800
        //키보드 올라가면 그 상태에서 스크롤 안 되는 거 해결해야함 ㅜㅜ
        
        
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
            case .decodeErr:
                print("decodeErr")
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.scrollView?.endEditing(true)
        print("touch")
    }
    
    
    
    
//    @objc func keyboardWillShow(_ sender: Notification) {
//        print("show")
//        self.keyboardWillHide(sender)
//        let userInfo: NSDictionary = sender.userInfo! as NSDictionary
//        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
//        let keyboardRectangle = keyboardFrame.cgRectValue
//        let keyboardHeight = keyboardRectangle.height
//        keyHeight = keyboardHeight
//
//        self.view.frame.size.height -= keyboardHeight
//    }
//    @objc func keyboardWillHide(_ sender: Notification) {
//        print("hide")
//        self.view.frame.size.height += keyHeight ?? 0
//    }
}
