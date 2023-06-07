//
//  UserSession.swift
//  TODORI
//
//  Created by Dasol on 2023/05/17.
//

import UIKit

class UserSession {
    static let shared = UserSession() // Singleton 객체
    
    var signUpEmail: String?
    
    var token: String?
    
    var nickname: String?
    var email: String?
    var profileImage: String?
    var image: String?
    
    private let userDefaults = UserDefaults.standard
    private let nicknameKey = "nickname"
    private let emailKey = "email"
    private let profileImageKey = "image"
    
    func imageToBase64String(image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        let base64String = imageData.base64EncodedString(options: [])
        return base64String
    }
    
    func base64StringToImage(base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else {
            return nil
        }
        let image = UIImage(data: imageData)
        return image
    }
    
    private init() {
        // Singleton 객체의 생성자를 private으로 설정하여 외부에서 직접 인스턴스를 생성하는 것을 방지합니다.
    }
}
