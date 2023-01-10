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
    }
}
