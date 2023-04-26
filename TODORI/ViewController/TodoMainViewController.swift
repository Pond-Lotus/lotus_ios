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
    
    var calendarView:FSCalendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 330, height: 270))
    var segmentedControl:UISegmentedControl = UISegmentedControl()
    var tableView:UITableView = UITableView()
    var topBarView:UIView = UIView()
    var hambuergerButton:UIButton = UIButton()
    var calendarImageView:UIImageView = UIImageView(image: UIImage(named: "calendar"))
    var dateLabel:UILabel = UILabel()
    var stackViewOfDateLabel:UIStackView = UIStackView()
    var dateFormatter = DateFormatter()
    var calendarBackgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dateFormatter.locale = Locale(identifier: "ko")
 
        self.view.addSubview(topBarView)
        topBarView.addSubview(segmentedControl)
        topBarView.addSubview(hambuergerButton)
        
        self.view.addSubview(tableView)
        tableView.addSubview(calendarBackgroundView)
        calendarBackgroundView.addSubview(calendarImageView)
        calendarBackgroundView.addSubview(dateLabel)
        calendarBackgroundView.addSubview(calendarView)
                
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
        dateLabel.textColor = UIColor.black
        dateLabel.font.withSize(15)
        dateLabel.text = DateFormat.shared.getdateLabelString(date: calendarView.currentPage)
        dateLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        //캘린더뷰 외형 설정
        calendarView.headerHeight = 0
        calendarView.select(calendarView.today)
        calendarView.calendarWeekdayView.weekdayLabels.forEach({
            $0.textColor = .black
        })
        
        //캘린더 백그라운드 뷰 외형 설정
        calendarBackgroundView.backgroundColor = .red

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
        
        calendarBackgroundView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(500)
        }
        
        calendarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(21)
            make.topMargin.equalTo(15)
            make.leftMargin.equalTo(38)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(calendarImageView.snp.right).offset(5)
            make.centerY.equalTo(calendarImageView)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(calendarImageView.snp.bottom).offset(20)
//            make.centerX.equalToSuperview()
            //center이 안 잡힘 왜지?
        }
    }
}
