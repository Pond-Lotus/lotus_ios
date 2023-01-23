//
//  TodoMainViewController.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/21.
//

import UIKit
import FSCalendar
import BetterSegmentedControl

class TodoMainViewController:UIViewController{
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var dateLabel: UILabel!
    
    var todoList:[TodoList] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarSetting()
        segmentedControlSetting()
        calendarView.dataSource = self
        calendarView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
//
//        self.tableView.register(UINib.init(nibName: "TodoTableViewCell", bundle: nil), forCellReuseIdentifier: "TodoCell")
        
    }

    @IBAction func tapAddButton(_ sender: Any) {
        self.todoList.append(TodoList(title: "", done: false))
        self.tableView.reloadData()
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
        self.calendarView.locale = Locale(identifier: "ko_KR")
    }
    
    private func segmentedControlSetting(){
        segmentControl.layer.cornerRadius = 15
        segmentControl.layer.masksToBounds = true
        segmentControl.clipsToBounds = true
    }
    
    private func searchDayTodo(year:String, month:String, day:String){
        TodoService.shared.searchTodo(year: year, month: month, day: day) { (response) in
            switch (response){
            case .success(let resultData):
                if let data = resultData as? TodoSearchResponseData{
                    var todoData = data.data
                    self.todoList.removeAll()
                    for i in todoData{
                        self.todoList.append(TodoList(title: i.title, done: i.done))
                    }
                    self.tableView.reloadData()
                    
                }
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    
}
extension TodoMainViewController:UITableViewDelegate{
    
}
extension TodoMainViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(todoList.count)
        return todoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        let todo = todoList[indexPath.row]
        cell.titleTextField.text = todo.title
        return cell
    }
    


}
extension TodoMainViewController:FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //제대로 동작 안 함 모지모지?><
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY MM DD"
        let dateArray = dateFormatter.string(from: date).components(separatedBy: " ")
        
        var year = dateArray[0]
        var month = dateArray[1]
        var day = dateArray[2]
        
        searchDayTodo(year: year, month: month, day: day)
    }
    
}
extension TodoMainViewController:FSCalendarDataSource{
}

