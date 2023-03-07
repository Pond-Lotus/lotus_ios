//
//  EnterCodeViewController.swift
//  ToDo
//
//  Created by KDS on 2023/01/17.
//

import UIKit

class EnterCodeViewController: UIViewController {

    var originEmail: String?
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if let code = codeTextField.text {
            codeCheck(email: originEmail!, code: code)
        }
    }
}

extension EnterCodeViewController {
    
    func codeCheck(email: String, code: String) {
        UserService.shared.codeCheck(email: email, code: code) {
            response in
            switch response {
            case .success(let data):
                guard let data = data as? SignupResponse else { return }
                if data.resultCode == 200 {
                    guard let goToNextController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
                    goToNextController.originEmail = self.originEmail
                    self.navigationController?.pushViewController(goToNextController, animated: true)
                } else if data.resultCode == 500 {
                    self.alertLoginFail(message: "resultCode : 500")
                }
                
            case .requestErr(let err):
                print(err)
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
    
    func alertLoginFail(message:String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        present(alertVC,animated:true,completion: nil)
    }
    
    func alertLogin(message: String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "확인", style: .default){
//            action in
//            let sb = UIStoryboard.init(name: "MainViewController", bundle: nil)
//            guard let mainVC = sb.instantiateViewController(withIdentifier: "MainViewController") as? UITabBarController else {return}
//            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(mainVC, animated: false)
//        }
//        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}

