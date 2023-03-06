//
//  DrawerViewController.swift
//  ToDo
//
//  Created by 제임스 on 2023/02/10.
//

import UIKit

class DrawerViewController : UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileEditImageView: UIImageView!
    
    
    @IBOutlet weak var roundView1: UIView!
    @IBOutlet weak var roundView2: UIView!
    @IBOutlet weak var roundView3: UIView!
    @IBOutlet weak var roundView4: UIView!
    @IBOutlet weak var roundView5: UIView!
    @IBOutlet weak var roundView6: UIView!
    
    var priorityArray:[Character] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchProfileEditButton))
        profileEditImageView.addGestureRecognizer(tapGesture)
        profileEditImageView.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profileSetting()
        imageViewSetting()
        
        TodoService.shared.getPriority { (response) in
            switch (response){
            case .success(let resultData):
                if let data = resultData as? PriorityResponseData{
                    if data.resultCode == 200{
                        self.priorityArray = Array(String(data.data))
                        self.roundViewSetting(view: self.roundView1,color: self.priorityArray[0])
                        self.roundViewSetting(view: self.roundView2,color: self.priorityArray[1])
                        self.roundViewSetting(view: self.roundView3,color: self.priorityArray[2])
                        self.roundViewSetting(view: self.roundView4,color: self.priorityArray[3])
                        self.roundViewSetting(view: self.roundView5,color: self.priorityArray[4])
                        self.roundViewSetting(view: self.roundView6,color: self.priorityArray[5])
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
        
        if let email = UserDefaults.standard.string(forKey: "email") {
            emailLabel.text = email
        }
    }
    
    @IBAction func tapNextButton(_ sender: Any) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SetPriorityViewController") as? SetPriorityViewController else{return}
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false)
    }
    
    @objc func touchProfileEditButton(){
        guard let viewController  = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController else {return}
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false)
    }
    
    private func profileSetting(){
        if let profileImage = UserDefaults.standard.string(forKey: "profileImage"){
            guard let decodedData = Data(base64Encoded: profileImage) else {print("base 64 decode error");return}
            let decodedImage = UIImage(data: decodedData)
            self.profileImageView.image = decodedImage
        }else{
            print("no profile image")
        }
        
        if let nickname = UserDefaults.standard.string(forKey: "nickname"){
            self.nicknameLabel.text = nickname
        }else{
            print("no nickname")
        }
    }
    
    private func roundViewSetting(view:UIView, color:Character){
        switch(color){
        case "1": view.backgroundColor = Color.red
        case "2": view.backgroundColor = Color.yellow
        case "3": view.backgroundColor = Color.green
        case "4": view.backgroundColor = Color.blue
        case "5": view.backgroundColor = Color.pink
        case "6": view.backgroundColor = Color.purple
        default: view.backgroundColor = Color.gray
        }
        view.layer.cornerRadius = view.fs_width/2
    }
    
    private func imageViewSetting(){
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        self.profileImageView.clipsToBounds = true

    }
}
