//
//  Color.swift
//  ToDo
//
//  Created by 제임스 on 2023/02/12.
//

import UIKit

class Color{
    static let shared = Color()
    
    func getColor(colorNum:Character) -> UIColor{
        var color:UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        switch(colorNum){
        case "1": color = UIColor(red: 1, green: 0.704, blue: 0.704, alpha: 1)
        case "2": color = UIColor(red: 1, green: 0.863, blue: 0.658, alpha: 1)
        case "3": color = UIColor(red: 0.696, green: 0.879, blue: 0.813, alpha: 1)
        case "4": color = UIColor(red: 0.718, green: 0.845, blue: 0.962, alpha: 1)
        case "5": color = UIColor(red: 1, green: 0.721, blue: 0.922, alpha: 1)
        case "6": color = UIColor(red: 0.712, green: 0.694, blue: 0.925, alpha: 1)
        default: break
        }
        return color
    }
    
//    func getColorCheckBoxImage(colorNum:Character) -> UIImage{
//        var image:UIImage = UIImage()
//        switch(colorNum){
//        case "1": image = UIImage(named: "checkbox_red")!
//        case "2": color = UIColor(red: 1, green: 0.863, blue: 0.658, alpha: 1)
//        case "3": color = UIColor(red: 0.696, green: 0.879, blue: 0.813, alpha: 1)
//        case "4": color = UIColor(red: 0.718, green: 0.845, blue: 0.962, alpha: 1)
//        case "5": color = UIColor(red: 1, green: 0.721, blue: 0.922, alpha: 1)
//        case "6": color = UIColor(red: 0.712, green: 0.694, blue: 0.925, alpha: 1)
//        default: break
//        }
//        return color
//    }
    
}


    
    
    
    

