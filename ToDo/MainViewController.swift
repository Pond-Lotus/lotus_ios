//
//  MainViewController.swift
//  
//
//  Created by KDS on 2023/01/23.
//

import UIKit
import PhotosUI

class MainViewController: UIViewController {
    
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var nickNameTextField: UITextField!
    var tmpImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileView.backgroundColor = UIColor.gray
        self.profileView.contentMode = .scaleAspectFill

        profileView.layer.cornerRadius = 75
        
        print(UserDefaults.standard.string(forKey: "myToken")!)
        
//        let rect: CGRect = .init(x: 0, y: 0, width: 150, height: 150)
//        let myView: UIView = .init(frame: rect)
//        
//        myView.backgroundColor = .yellow
//        self.view.addSubview(myView)
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        var configurcation = PHPickerConfiguration()
        configurcation.filter = .any(of: [.images])
        
        let picker = PHPickerViewController(configuration: configurcation)
        picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tapEditButton(_ sender: Any) {
        let nickname = nickNameTextField.text ?? ""
        self.editCheck(nickname: nickname, image: tmpImage)
    }
    
    func editCheck(nickname: String, image: UIImage?) {
        UserService.shared.editProfile(nickname: nickname, image: image) {
            response in
            switch response {
            case .success(let data):
                guard let data = data as? EditProfileResponse else { return }
                if data.resultCode == 200 {
                    self.alertTitle(message: "프로필 수정 성공")
                    if let data = Data(base64Encoded: data.data.image, options: .ignoreUnknownCharacters) {
                        let decodedImg = UIImage(data: data)
                        self.profileView.image = decodedImg
                    }
                } else if data.resultCode == 500 {
                    self.alertTitle(message: "프로필 수정 실패")
                    self.profileView.backgroundColor = .red
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
    
    func alertTitle(message:String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        present(alertVC,animated:true,completion: nil)
    }
}

extension MainViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) // 1
        
        let itemProvider = results.first?.itemProvider // 2
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in // 4
                DispatchQueue.main.async {
                    self.profileView.image = image as? UIImage
                    self.tmpImage = image as? UIImage
                }
            }
        } else {
            // TODO: Handle empty results or item provider not being able load UIImage
        }
    }
}
