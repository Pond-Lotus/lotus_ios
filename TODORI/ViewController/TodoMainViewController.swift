//
//  TodoMainViewController.swift
//  TODORI
//
//  Created by 제임스 on 2023/04/19.
//

import Foundation
import SnapKit
import FSCalendar

class TodoMainViewController : UIViewController{
    
    var calendarView:FSCalendar = FSCalendar()
    var segmentedControl:UISegmentedControl = UISegmentedControl()
    var tableView:UITableView = UITableView()
    var topBarView:UIView = UIView()
    var hambuergerButton:UIButton = UIButton()
    var calendarImageView:UIImageView = UIImageView(image: UIImage(named: "calendar"))
    var dateLabel:UILabel = UILabel()
    var stackViewOfDateLabel:UIStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.view.addSubview(topBarView)
        topBarView.addSubview(segmentedControl)
        topBarView.addSubview(hambuergerButton)
        
        self.view.addSubview(tableView)
        tableView.addSubview(stackViewOfDateLabel)
        stackViewOfDateLabel.addSubview(calendarImageView)
        stackViewOfDateLabel.addSubview(dateLabel)
        tableView.addSubview(calendarView)
                
        setComponentAppearence() //컴포넌트 외형 설정
        setAutoLayout() //오토 레이아웃 설정
    }
    
    private func setComponentAppearence(){
        //segmented control segment 추가 및 초기 셋팅
        segmentedControl.insertSegment(withTitle: "월간", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "주간", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        
        //햄버거 바 버튼 이미지 지정
        hambuergerButton.setImage(UIImage(named: "hamburger-button"), for: .normal)
        
        //캘린더 상단 날짜 라벨
        stackViewOfDateLabel.axis = .horizontal
        stackViewOfDateLabel.spacing = 4
        dateLabel.textColor = UIColor.black
        dateLabel.font.withSize(15)
        dateLabel.text = "2222 22 22"
        
        //캘린더뷰 외형 설정
        calendarView.headerHeight = 0

    }
    
    private func setAutoLayout(){
        topBarView.snp.makeConstraints { make in
            make.right.left.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(138)
            make.right.equalTo(-138)
        }
        
        hambuergerButton.snp.makeConstraints { make in
            make.width.height.equalTo(29)
            make.rightMargin.equalTo(-20)
            make.centerY.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.right.left.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view)
            make.top.equalTo(topBarView.snp.bottom)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(stackViewOfDateLabel)
            make.topMargin.equalTo(10)
            make.leftMargin.equalTo(30)
            make.rightMargin.equalTo(-30)
            make.height.equalTo(300)
        }
        
        stackViewOfDateLabel.snp.makeConstraints { make in
            make.left.equalTo(calendarView)
        }
        
        calendarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(21)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(calendarImageView.snp.right)
            make.leftMargin.equalTo(<#T##other: ConstraintRelatableTarget##ConstraintRelatableTarget#>)
        }
        
    }
}
