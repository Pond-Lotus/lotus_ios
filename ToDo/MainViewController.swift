//
//  MainViewController.swift
//  ToDo
//
//  Created by KDS on 2023/01/09.
//

import UIKit

class MainViewController : UIViewController
{
    @IBOutlet weak var welcomLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
       
//        let nickname =  ?? "사람"
//
//        welcomLabel.text = """
//        환영합니다.
//        \(nickname)님
//        """
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
