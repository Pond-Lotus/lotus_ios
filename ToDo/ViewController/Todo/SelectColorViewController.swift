//
//  SelectColorViewController.swift
//  ToDo
//
//  Created by 제임스 on 2023/02/20.
//

import UIKit

class SelectColorViewController:UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func tapRedButton(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("selectColor"), object: 1)
    }
    
    @IBAction func tapYellowButton(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("selectColor"), object: 2)
    }
    
    @IBAction func tapGreenButton(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("selectColor"), object: 3)
    }
    
    @IBAction func tapBlueButton(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("selectColor"), object: 4)
    }
    
    @IBAction func tapPinkButton(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("selectColor"), object: 5)
    }
    
    @IBAction func tapPurpleButton(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("selectColor"), object: 6)
    }
}
