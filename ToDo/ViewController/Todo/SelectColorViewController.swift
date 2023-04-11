//
//  SelectColorViewController.swift
//  ToDo
//
//  Created by 제임스 on 2023/02/20.
//

import UIKit

class SelectColorViewController:UIViewController{
    
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var pinkButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonArray = [redButton,yellowButton,greenButton,blueButton,pinkButton,purpleButton]
        buttonArray.forEach {
            $0?.clipsToBounds = true
            $0?.layer.cornerRadius = ($0?.fs_width ?? 25)/2
        }

        
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
