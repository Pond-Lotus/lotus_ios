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
    var calendarBackgroundView:UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //기본 뷰 색상 설정
        view.backgroundColor = .white
        
        //데이트 포멧터 설정
        dateFormatter.locale = Locale(identifier: "ko")
        
        addComponent() //컴포넌트 및 뷰 추가
        setAutoLayout() //오토 레이아웃 설정
        setComponentAppearence() //컴포넌트 외형 설정
    }
    
    private func addComponent(){
        //기본 뷰에 세그먼티트 컨트롤, 햄버거바를 담을 뷰 추가
        self.view.addSubview(topBarView)
        
        //상위 뷰에 새그먼티트 컨트롤, 햄버거바 추가
        topBarView.addSubview(segmentedControl)
        topBarView.addSubview(hambuergerButton)
        
        //기본 뷰에 테이블뷰 추가
        self.view.addSubview(tableView)
        
        //        calendarBackgroundView.addSubview(calendarImageView)
        //        calendarBackgroundView.addSubview(dateLabel)
        //        calendarBackgroundView.addSubview(calendarView)
        tableView.tableHeaderView = calendarBackgroundView
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 400)
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
        
        //테이블뷰 설정 - 디버깅
        tableView.backgroundColor = .yellow
        print("height: \(tableView.tableHeaderView?.fs_height), width:\(tableView.tableHeaderView?.fs_width) ")
        
        
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
            make.left.right.top.equalTo(tableView)
            make.height.equalTo(200)
        }
        
//        calendarImageView.snp.makeConstraints { make in
//            make.width.height.equalTo(21)
//            make.top.equalTo(calendarBackgroundView.snp.top).offset(16)
//            make.leftMargin.equalTo(calendarBackgroundView.snp.left).offset(38)
//        }
//
//        dateLabel.snp.makeConstraints { make in
//            make.left.equalTo(calendarImageView.snp.right).offset(5)
//            make.centerY.equalTo(calendarImageView)
//        }
//
//        calendarView.snp.makeConstraints { make in
//            make.top.equalTo(calendarImageView.snp.bottom).offset(20)
//        }
    }
}

extension TodoMainViewController:UITableViewDelegate{
    
}
extension TodoMainViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .gray
        return cell
    }
    
    
}
