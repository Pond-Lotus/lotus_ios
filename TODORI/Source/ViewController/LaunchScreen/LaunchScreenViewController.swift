//
//  LaunchScreenViewController.swift
//  TODORI
//
//  Created by Dasol on 2023/04/19.
//

import UIKit
import SnapKit

class LaunchScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView()
        let screenSize = UIScreen.main.bounds.size
        view.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        self.view.addSubview(view)
        
        switch traitCollection.userInterfaceStyle {
        case .light:
            print("라이트테마")
            view.backgroundColor = .white
            
            let layer0 = CAGradientLayer()
            layer0.colors = [
                UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1).cgColor,
                UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1).cgColor
            ]
            layer0.locations = [0, 1]
            layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
            layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
            layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0.94, b: 0.69, c: -0.69, d: 0.2, tx: 0.35, ty: -0.09))
            layer0.bounds = view.bounds.insetBy(dx: -0.9 * view.bounds.size.width, dy: -0.5 * view.bounds.size.height)
            layer0.position = view.center
            view.layer.addSublayer(layer0)
        case .dark:
            print("다크테마")
            view.backgroundColor = UIColor.backgroundColor
        case .unspecified:
            break
        @unknown default:
            break
        }
        
        let logoView = ImageViewManager.shared.getUIImageViewScaleToFit(fileName: "logo-image-splash")
        
        self.view.addSubview(logoView)
        
        logoView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(67)
            $0.height.equalTo(93)
        }
    }
}
//        UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1) // #222222
