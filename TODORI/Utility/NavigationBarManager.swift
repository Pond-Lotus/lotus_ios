//
//  NavigationBarManager.swift
//  TODORI
//
//  Created by Dasol on 2023/06/05.
//

import UIKit

class NavigationBarManager {
    static let shared = NavigationBarManager()
    
    private init() {}
    
    var separatorView: UIView?
    
    func setupNavigationBar(for viewController: UIViewController, backButtonAction: Selector?, title: String, showSeparator: Bool = true) {
        if showSeparator {
            separatorView = UIView()
            separatorView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
            viewController.navigationController?.navigationBar.addSubview(separatorView!)
            
            separatorView?.snp.makeConstraints { make in
                make.top.equalTo(viewController.navigationController!.navigationBar.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(1)
            }
        }
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: viewController, action: backButtonAction)
        backButton.imageInsets = UIEdgeInsets(top: 0, left: -16 + UIScreen.main.bounds.width * 0.06, bottom: 0, right: 0)
        backButton.tintColor = UIColor(red: 0.258, green: 0.258, blue: 0.258, alpha: 1)
        viewController.navigationItem.leftBarButtonItem = backButton
        
        let font = UIFont.systemFont(ofSize: 16, weight: .bold)
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.black]
        viewController.navigationController?.navigationBar.titleTextAttributes = attributes
        viewController.navigationItem.title = title
    }
    
    func removeSeparatorView() {
        separatorView?.removeFromSuperview()
        separatorView = nil
    }
}
