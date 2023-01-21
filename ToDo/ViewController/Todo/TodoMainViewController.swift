//
//  TodoMainViewController.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/21.
//

import UIKit
import FSCalendar
import BetterSegmentedControl

class TodoMainViewController:UIViewController, FSCalendarDataSource, FSCalendarDelegate{
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarSetting()
        segmentedControlSetting()
        calendarView.dataSource = self
        calendarView.delegate = self
        
    }
    
    @IBAction func switchSegmentedControl(_ sender: Any) {
        if self.segmentControl.selectedSegmentIndex == 0{
            calendarView.scope = .month
        }else{
            calendarView.scope = .week
        }
    }
    
    private func calendarSetting(){
        self.calendarView.appearance.headerTitleAlignment = .left
        self.calendarView.appearance.headerDateFormat = "YYYY.MM"
        self.calendarView.appearance.headerTitleFont = .boldSystemFont(ofSize: 20.0)
    }
    
    private func segmentedControlSetting(){
        segmentControl.layer.cornerRadius = 15
        segmentControl.layer.masksToBounds = true
        segmentControl.clipsToBounds = true
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //제대로 동작 안 함 모지모지?><
        let formatter = DateFormatter()
        let dateString = formatter.string(from: date)
        print(dateString)
        dateLabel.text = dateString
    }
    
}
