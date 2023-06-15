//
//  BottomSheetViewController.swift
//  TODORI
//
//  Created by 제임스 on 2023/06/15.
//

import UIKit

class BottomSheetViewController: UIViewController{
    //ToDoMainViewController 내부 bottom sheet를 클래스로 분리하는 작업 진행중
    //미완성 코드
    var bottomSheetView: UIView = UIView()
    var colorBarViewInBottomsheet: UIView = UIView()
    var titleTextFieldInBottomSheet: UITextField = UITextField()
    var dateLabelInBottomSheet: UILabel = UILabel()
    var descriptionBackgroundView: UIView = UIView()
    var descriptionTextView: UITextView = UITextView()
    var blackViewOfBottomSheet: UIView = UIView()
    var blackViewOfDrawer: UIView = UIView()
    var clockImageView: UIImageView = UIImageView(image: UIImage(named: "clock"))
    var timeLiterallyLabel: UILabel = UILabel()
    var timeLabel: UILabel = UILabel()
    var datePickerBackgroundView: UIView = UIView()
    var datePicker: UIDatePicker = UIDatePicker()
    var cancelButtonInDatePicker: UIButton = UIButton()
    var finishButtonInDatePicker: UIButton = UIButton()
    var grayLineNextDateLabel: UIView = UIView()
    var redCircleButton: UIButton = {
        var button: UIButton = UIButton()
        button.tag = 1
        button.setImage(UIImage(named: "red-circle"), for: .normal)
        return button
    }()
    var yellowCircleButton:UIButton = {
        var button: UIButton = UIButton()
        button.tag = 2
        button.setImage(UIImage(named: "yellow-circle"), for: .normal)
        return button
    }()
    var greenCircleButton:UIButton = {
        var button: UIButton = UIButton()
        button.tag = 3
        button.setImage(UIImage(named: "green-circle"), for: .normal)
        return button
    }()
    var blueCircleButton:UIButton = {
        var button: UIButton = UIButton()
        button.tag = 4
        button.setImage(UIImage(named: "blue-circle"), for: .normal)
        return button
    }()
    var pinkCircleButton:UIButton = {
        var button: UIButton = UIButton()
        button.tag = 5
        button.setImage(UIImage(named: "pink-circle"), for: .normal)
        return button
    }()
    var purpleCircleButton:UIButton = {
        var button: UIButton = UIButton()
        button.tag = 6
        button.setImage(UIImage(named: "purple-circle"), for: .normal)
        return button
    }()
    var colorCircleButtonStackView:UIStackView = UIStackView()
    var grayLineInBottomSheet:UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setAutoLayout(){
        
        bottomSheetView.snp.makeConstraints{ make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
//            bottomSheetHeightConstraint = make.height.equalTo(0)
        }
        
        dateLabelInBottomSheet.snp.makeConstraints { make in
            make.top.equalTo(colorBarViewInBottomsheet.snp.top)
            make.left.equalTo(colorBarViewInBottomsheet.snp.right).offset(8)
        }
        
        titleTextFieldInBottomSheet.snp.makeConstraints { make in
            make.left.equalTo(dateLabelInBottomSheet)
            make.top.equalTo(dateLabelInBottomSheet.snp.bottom).offset(3)
            make.right.equalToSuperview().offset(-25)
        }
        
        colorBarViewInBottomsheet.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(40)
            make.width.equalTo(9)
            make.bottom.equalTo(titleTextFieldInBottomSheet)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextFieldInBottomSheet.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.rightMargin.leftMargin.equalTo(25)
        }
        
        clockImageView.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.left.equalTo(descriptionTextView)
            make.top.equalTo(descriptionTextView.snp.bottom).offset(22)
        }
        
        timeLiterallyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(clockImageView)
            make.left.equalTo(clockImageView.snp.right).offset(4)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(clockImageView)
            make.left.equalTo(timeLiterallyLabel.snp.right).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        grayLineInBottomSheet.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-25)
            make.left.equalToSuperview().offset(25)
            make.top.equalTo(timeLiterallyLabel.snp.bottom).offset(26)
            make.height.equalTo(1)
        }
        
        redCircleButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        yellowCircleButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        greenCircleButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        blueCircleButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        pinkCircleButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        purpleCircleButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        
        colorCircleButtonStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-42)
            make.left.equalToSuperview().offset(42)
            make.top.equalTo(grayLineInBottomSheet).offset(20)
        }
    }
    
    private func setAppearence(){
        
    }
}
