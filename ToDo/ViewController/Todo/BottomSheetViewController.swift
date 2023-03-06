//
//  bottomSheetViewController.swift
//  ToDo
//
//  Created by 제임스 on 2023/02/12.
//

import UIKit

class BottomSheetViewController : UIViewController {
    
    @IBOutlet weak var colorBarView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todoTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var alaramSetSwitch: UISwitch!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alaramLabel: UILabel!
    
    var color:Int = 0
    var time = ""
    var id:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstSetting()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        colorSetting(colorNum: color)
    }
    
    private func firstSetting(){
        todoTextField.becomeFirstResponder()
        colorBarView.layer.cornerRadius = colorBarView.fs_width/2
        alaramSetSwitch.isOn = false
        alaramSetSwitch.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        alaramSetSwitch.onTintColor = UIColor(red: 0.983, green: 0.889, blue: 0.778, alpha: 1)
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        TodoService.shared.modifyTodo(id: id, color: color, description: descriptionTextView.text) { (response) in
            switch (response){
            case .success(let resultData):
                if let data = resultData as? TodoEditResponseData{
                    print(data.resultCode)
                    NotificationCenter.default.post(name: NSNotification.Name("finishEditing"), object: nil)
                }
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            case .decodeErr:
                print("decodeErr")
            }
        }
    }
    @IBAction func tapRedButton(_ sender: Any) {
        color = 1
    }
    @IBAction func tapYellowButton(_ sender: Any) {
        color = 2
    }
    @IBAction func tapGreenButton(_ sender: Any) {
        color = 3
    }
    
    @IBAction func tapBlueButton(_ sender: Any) {
        color = 4
    }
    @IBAction func tapPinkButton(_ sender: Any) {
        color = 5
    }
    @IBAction func tapPurpleButton(_ sender: Any) {
        color = 6
    }
    
    func colorSetting(colorNum:Int){
        switch(colorNum){
        case 1:
            colorBarView.backgroundColor = Color.red
            dateLabel.textColor = Color.red
        case 2:
            colorBarView.backgroundColor = Color.yellow
            dateLabel.textColor = Color.yellow
        case 3:
            colorBarView.backgroundColor = Color.green
            dateLabel.textColor = Color.green
        case 4:
            colorBarView.backgroundColor = Color.blue
            dateLabel.textColor = Color.blue
        case 5:
            colorBarView.backgroundColor = Color.pink
            dateLabel.textColor = Color.pink
        case 6:
            colorBarView.backgroundColor = Color.purple
            dateLabel.textColor = Color.purple
        default:
            colorBarView.backgroundColor = Color.gray
            dateLabel.textColor = Color.gray
        }
    }
}
