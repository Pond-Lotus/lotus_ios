//
//  ButtonManager.swift
//  TODORI
//
//  Created by Dasol on 2023/06/05.
//

import UIKit

class ButtonManager {
    static let shared = ButtonManager()
    
    private init() {}
    
    func getNextButton() -> UIButton {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "next-button")?.resize(to: CGSize(width: UIScreen.main.bounds.width * 0.16, height: UIScreen.main.bounds.width * 0.16))
        button.setImage(image, for: .normal)
        
        return button
    }
}
