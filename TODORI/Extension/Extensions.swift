//
//  Extensions.swift
//  TODORI
//
//  Created by Dasol on 2023/05/17.
//

import UIKit

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension UIColor {
    static var mainColor: UIColor {
        return UIColor(red: 1, green: 0.855, blue: 0.725, alpha: 1)
    }
}

extension UIImage {
    var circleMasked: UIImage? {
        // 이미지의 크기를 가져옵니다.
        let imageRect = CGRect(origin: .zero, size: size)

        // 새로운 그래픽 컨텍스트를 만듭니다.
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, 0)

        // 원형으로 잘라낼 범위를 계산합니다.
        let path = UIBezierPath(ovalIn: imageRect)
        path.addClip()

        // 이미지를 그립니다.
        draw(in: imageRect)

        // 새로운 이미지를 가져옵니다.
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()

        // 그래픽 컨텍스트를 종료합니다.
        UIGraphicsEndImageContext()

        // 새로운 이미지를 반환합니다.
        return maskedImage
    }
}

extension UIImage {
    func roundedImage() -> UIImage? {
        let rect = CGRect(origin: .zero, size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        UIBezierPath(roundedRect: rect, cornerRadius: self.size.width/2).addClip()
        self.draw(in: rect)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage
    }
}

extension UIImage {
    func squareImage() -> UIImage? {
        let originalWidth = self.size.width
        let originalHeight = self.size.height
        let edgeLength = min(originalWidth, originalHeight)
        let posX = (originalWidth - edgeLength) / 2.0
        let posY = (originalHeight - edgeLength) / 2.0
        let cropRect = CGRect(x: posX, y: posY, width: edgeLength, height: edgeLength)
        
        if let imageRef = self.cgImage?.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        }
        
        return nil
    }
}
