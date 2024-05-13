//
//  ViewManager.swift
//  TODORI
//
//  Created by Dasol on 2023/06/22.
//

import UIKit

class ViewManager {
    static let shared = ViewManager()
    
    private init() {}
    
    func getUnderlineView(for view: UIView) -> UIView {
        let underlineView = UIView()
        underlineView.backgroundColor = UITraitCollection.current.userInterfaceStyle == .light ? UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1) : UIColor(red: 0.322, green: 0.322, blue: 0.322, alpha: 1)
        view.addSubview(underlineView)
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1.0)
            make.leading.equalToSuperview().offset(22)
            make.centerX.equalToSuperview()
        }
        return underlineView
    }
    
    func getAccountInfo() -> UIView {
        let view = UIView()
        view.backgroundColor = UITraitCollection.current.userInterfaceStyle == .light ? UIColor(red: 0.958, green: 0.958, blue: 0.958, alpha: 1) : UIColor(red: 0.125, green: 0.125, blue: 0.125, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }
}
