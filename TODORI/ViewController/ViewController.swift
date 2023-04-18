//
//  ViewController.swift
//  Todo_code
//
//  Created by 제임스 on 2023/04/18.
//

import UIKit

class ViewController: UIViewController {
    var logoImageView:UIImageView = UIImageView(image: UIImage(named: "Logo"))
    var logoTextImageView:UIImageView = UIImageView(image: UIImage(named: "Logo_text"))
    var emailTextfield:UITextField = UITextField()
    var passwordTextField:UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoTextImageView.translatesAutoresizingMaskIntoConstraints = false
        emailTextfield.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(logoImageView)
        self.view.addSubview(logoTextImageView)
        self.view.addSubview(emailTextfield)
        self.view.addSubview(passwordTextField)
        
        logoImageView.widthAnchor.constraint(equalToConstant: 117).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 117).isActive = true
        logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 149).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        logoTextImageView.widthAnchor.constraint(equalToConstant: 103).isActive = true
        logoTextImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logoTextImageView.bottomAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 20).isActive = true
        
        emailTextfield.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 41).isActive = true
        emailTextfield.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -41).isActive = true
        emailTextfield.topAnchor.constraint(equalTo: self.logoTextImageView.bottomAnchor, constant: 67).isActive = true
    }
//수정 
}

