//
//  MainViewController.swift
//  
//
//  Created by KDS on 2023/01/23.
//

import UIKit
import PhotosUI

class MainViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.backgroundColor = UIColor.gray

    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        var configurcation = PHPickerConfiguration()
        configurcation.filter = .any(of: [.images])
        
        let picker = PHPickerViewController(configuration: configurcation)
        picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)
    }
    
    func editCheck(nickname: String, image: UIImage?) {
        UserService.shared.editProfile(nickname: <#T##String#>, image: <#T##UIImage?#>) {
            response in
            print("response : \(response)")
            switch response {
            case .success(let data):
                guard let data = data as? ToDoResponse else { return }
                
                if data.resultCode == 200 {
                    self.alertTitle(message: "작성 성공")
                } else if data.resultCode == 500 {
                    self.alertTitle(message: "작성 실패")
                }
            case .requestErr(let err):
                print(err)
                self.alertTitle(message: "작성 실패")
            case .pathErr:
                print("pathErr")
                self.alertTitle(message: "작성 실패")
            case .serverErr:
                print("serverErr")
                self.alertTitle(message: "작성 실패")
            case .networkFail:
                print("networkFail")
                self.alertTitle(message: "작성 실패")
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
                    self.imageView.image = image as? UIImage // 5
                }
            }
        } else {
            // TODO: Handle empty results or item provider not being able load UIImage
        }
        
    }
    
}
