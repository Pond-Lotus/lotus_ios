//
//  Color.swift
//  TODORI
//
//  Created by Dasol on 2023/05/29.
//

import UIKit

class ColorManager {
    static let shared = ColorManager()
    
    let colorSet = ["red-circle", "yellow-circle", "green-circle", "blue-circle", "pink-circle", "purple-circle"]
        
    private init() {}
}

class Color {
    
    static let shared = Color()
    
    var UIColorArray:[UIColor] = [.todoriRed!, .todoriYellow!, .todoriGreen!, .todoriBlue!, .todoriPink!, .todoriPurple!]
    
    func getColor(colorNum:Int) -> UIColor{
        var color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        switch(colorNum){
        case 1: color = .todoriRed!
        case 2: color = .todoriYellow!
        case 3: color = .todoriGreen!
        case 4: color = .todoriBlue!
        case 5: color = .todoriPink!
        case 6: color = .todoriPurple!
        default: break
        }
        return color
    }
    
    func getColor(colorNumString:Character) -> UIColor{
        var color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        switch(colorNumString){
        case "1": color = .todoriRed!
        case "2": color = .todoriYellow!
        case "3": color = .todoriGreen!
        case "4": color = .todoriBlue!
        case "5": color = .todoriPink!
        case "6": color = .todoriPurple!
        default: break
        }
        return color
    }
    
    func getCheckBoxImage(colorNum:Int) -> UIImage? {
        var image = UIImage(named: "checkbox")
        switch(colorNum){
        case 1: image = UIImage(named: "checkbox-red")
        case 2: image = UIImage(named: "checkbox-yellow")
        case 3: image = UIImage(named: "checkbox-green")
        case 4: image = UIImage(named: "checkbox-blue")
        case 5: image = UIImage(named: "checkbox-pink")
        case 6: image = UIImage(named: "checkbox-purple")
        default:break
        }
        return image
    }
    
    func getSeletedCircleImage(colorNum:Int) -> UIImage? {
        var image = UIImage(named: "red-circle-selected")
        switch(colorNum){
        case 1: image = UIImage(named: "red-circle-selected")
        case 2: image = UIImage(named: "yellow-circle-selected")
        case 3: image = UIImage(named: "green-circle-selected")
        case 4: image = UIImage(named: "blue-circle-selected")
        case 5: image = UIImage(named: "pink-circle-selected")
        case 6: image = UIImage(named: "purple-circle-selected")
        default:break
        }
        
        return image
    }
    
}
extension UIColor {
    static let todoriRed = UIColor(named: "todoriRed")
    static let todoriYellow = UIColor(named: "todoriYellow")
    static let todoriGreen = UIColor(named: "todoriGreen")
    static let todoriBlue = UIColor(named: "todoriBlue")
    static let todoriPink = UIColor(named: "todoriPink")
    static let todoriPurple = UIColor(named: "todoriPurple")
    static let todoriOrange = UIColor(named: "todoriOrange")
    static let mainBeige = UIColor(named: "mainBeige")
    static let todoriWhite = UIColor(named: "todoriWhite")
    static let todoriGray = UIColor(named: "todoriGray")
    static let lightGray01 = UIColor(named: "lightGray01")
    static let dg02 = UIColor(named: "dg02")
    static let dg04 = UIColor(named: "dg04")
    static let boxFill = UIColor(named: "boxFill")
    static let boxLine = UIColor(named: "boxLine")
    static let line = UIColor(named: "line")
    static let popupBackgroundColor = UIColor(named: "popupBackgroundColor")
    static let buttonColor = UIColor(named: "buttonColor")
    static let popupButtonColor = UIColor(named: "popupButtonColor")
    static var mainColor: UIColor { return UIColor(red: 1, green: 0.616, blue: 0.302, alpha: 1) }
    static let textFieldColor = UIColor(named: "textfieldColor")

    static let textColor = UIColor(named: "textColor")
    static let shadowColor = UIColor(named: "shadowColor")
    static let calendarNotThisMonthTextColor = UIColor(named: "calendarNotThisMonthTextColor")
 
    static let descriptionBackground = UIColor(named: "descriptionBackground")
    static let selectionColor = UIColor(named: "selectionColor")
    static let todaySelectionColor = UIColor(named: "todaySelectionColor")
    static let sundayLightColor = UIColor(named: "sundayLightColor")
    static let sundayDarkColor = UIColor(named: "sundayDarkColor")
    static let todayTitleColor = UIColor(named: "todayTitleColor")
    static let clearBackgroundColor = UIColor(named: "clearBackgroundColor")
    static let rejectButtonGray = UIColor(named: "rejectButtonGray")
    static let viewBackgroundColor = UIColor(named: "viewBackgroundColor")
}

