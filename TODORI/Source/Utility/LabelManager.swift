//
//  LabelManager.swift
//  TODORI
//
//  Created by Dasol on 2023/06/21.
//

import UIKit

class SignUpLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLabel()
    }
    
    private func configureLabel() {
        self.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        self.textColor = UIColor(red: 0.621, green: 0.621, blue: 0.621, alpha: 1)
    }
}

class LabelManager {
    static func createNumberLabel(text: String) -> SignUpLabel {
        let label = SignUpLabel()
        label.text = text
        return label
    }
}
