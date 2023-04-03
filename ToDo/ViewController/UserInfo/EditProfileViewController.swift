//
//  EditProfileViewController.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/31.
//

import UIKit
import PhotosUI

class EditProfileViewController : UIViewController{
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var editPWButton: UIButton!
    
    var selectedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageSetting()
        editPWButtonSetting()
        
        let userDefault = UserDefaults.standard
        
        if let profileImage = userDefault.string(forKey: "profileImage"){
            guard let decodedData = Data(base64Encoded: profileImage) else {print("base 64 decode error");return}
            let decodedImage = UIImage(data: decodedData)
            profileImageView.image = decodedImage
        }
        if let nickname = userDefault.string(forKey: "nickname"){
            nicknameTextField.text = nickname
        }
        if let email = userDefault.string(forKey: "email"){
            emailTextField.text = email
        }
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchImageView))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
        
        
    }
    
    @objc func touchImageView(){
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let cancleAction = UIAlertAction(title: "닫기", style: UIAlertAction.Style.cancel)
        let defaultAction = UIAlertAction(title: "앨범에서 선택하기", style: UIAlertAction.Style.default) { (_) in
            var configuration = PHPickerConfiguration()
            
            configuration.selectionLimit = 1
            configuration.filter = .images
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            
            self.present(picker, animated: true)
        }
        let destructiveAction = UIAlertAction(title: "기본 이미지로 변경", style: UIAlertAction.Style.destructive) { (_) in
            self.profileImageView.image = UIImage(named: "profileImage")
        }
        
        alert.addAction(cancleAction)
        alert.addAction(defaultAction)
        alert.addAction(destructiveAction)
        
        self.present(alert, animated: true)
        
    }
    
    private func editPWButtonSetting(){
        editPWButton.layer.borderWidth = 1
        editPWButton.layer.borderColor = UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1).cgColor
        editPWButton.layer.cornerRadius = 8
        editPWButton.layer.masksToBounds = false
    }
    
    private func profileImageSetting(){
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        self.profileImageView.clipsToBounds = true
    }

    @IBAction func tapFinishButton(_ sender: Any) {
        guard let profileImage = self.profileImageView.image else {return}
        
        
        UserInfoService.shared.editImageAndNickname(image: profileImage, nickname: nicknameTextField.text ?? "") { (response) in
            switch response{
            case .success(let resultData):
                if let data = resultData as? EditImageAndNicknameResonseData{
                    print(data.resultCode)
                    if data.resultCode == 200 {
                        UserDefaults.standard.set(data.data.image, forKey: "profileImage")
                        UserDefaults.standard.set(data.data.nickname, forKey: "nickname")
                        self.presentingViewController?.dismiss(animated: false)


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
    
    @IBAction func tapPreButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @IBAction func tapEditPWButton(_ sender: Any) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "EditPWViewController") as? EditPWViewController else {return}
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false)
    }
}
extension EditProfileViewController : PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider //결과값의 첫번째만 불러온다는????맞나
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self){//이건 또 뭔지 모르겠음
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    guard let selectedImage = image as? UIImage else {return}
                    self.profileImageView.image = selectedImage
                    self.selectedImage = selectedImage
                }
            }
        }
    }
    
    
}

