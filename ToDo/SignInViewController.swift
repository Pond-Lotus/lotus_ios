//
//  SignInControlloer.swift
//  ToDo
//
//  Created by KDS on 2023/01/09.
//

import UIKit

class SignInViewController: UIViewController
{
    @IBOutlet var emailLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [emailLoginButton].forEach
        {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.black.cgColor
            $0?.layer.cornerRadius = 20
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // navigation bar 숨기기
        navigationController? .navigationBar.isHidden = true
    }
}

