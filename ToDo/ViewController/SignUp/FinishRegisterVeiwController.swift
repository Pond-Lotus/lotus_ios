//
//  FinishRegisterVeiwController.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/11.
//

import UIKit

class FinishRegisterVeiwController : UIViewController{
    @IBOutlet weak var nicknameLabel: UILabel!
    var nickname:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameLabel.text = nickname
    }
    @IBAction func tapLoginButton(_ sender: Any) {
        guard let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {return}
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: false)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view?.endEditing(true)
        print("touch")
    }
}
