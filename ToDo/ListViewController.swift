//
//  ListViewController.swift
//  ToDo
//
//  Created by KDS on 2023/01/18.
//

import UIKit
import FSCalendar

class ListViewController: UIViewController {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var calendarSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    // weak로 하면 버튼을 눌렀을 때 done으로 바뀌면서 메모리에서 해제가 되어 재사용할 수 없게 됨
    @IBOutlet var editButton: UIBarButtonItem!
    
    var doneButton: UIBarButtonItem?
    
    var tasks = [Task]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        calendarView.allowsMultipleSelection = true
        
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
        
        calendarView.dataSource = self
        calendarView.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        print(UserDefaults.standard.string(forKey: "myToken")!)
    }
    
    @objc func doneButtonTap() {
        self.navigationItem.leftBarButtonItem = self.editButton
        self.tableView.setEditing(false, animated: true)
    }
    
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        guard !self.tasks.isEmpty else {return}
        
        self.navigationItem.leftBarButtonItem = self.doneButton
        self.tableView.setEditing(true, animated: true)
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert)
        // 클로저 내에 캡쳐 목록 정의([weak self])를 하여 강한 순환참조 회피
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: { [weak self] _ in
            guard let title = alert.textFields?[0].text else {return}
            
            let date = DateFormatter()
            date.dateFormat = "Y"
            let year = date.string(from: Date())
            date.dateFormat = "M"
            let month = date.string(from: Date())
            date.dateFormat = "D"
            let day = date.string(from: Date())
            
            self?.writeCheck(year: year, month: month, day: day, title: title) // 요청에 필요한 키를 매개변수로 받음
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(registerButton)
        alert.addAction(cancelButton)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "할 일을 입력하세요."
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tapSearchButton(_ sender: Any) {
        let date = DateFormatter()
        date.dateFormat = "Y"
        let year = date.string(from: Date())
        date.dateFormat = "M"
        let month = date.string(from: Date())
        date.dateFormat = "D"
        let day = date.string(from: Date())
        
        self.inquireCheck(year: year, month: month, day: day)
    }
    
    @IBAction func tapCalendarButton(_ sender: Any) {
        if self.calendarSwitch.isOn == true {
            self.calendarView.scope = .month
        } else {
            self.calendarView.scope = .week
        }
    }
}

extension ListViewController {
    func writeCheck(year: String, month: String, day: String, title: String) {
        ToDoService.shared.writeToDo(year: year, month: month, day: day, title: title) {
            response in
            print("response : \(response)")
            switch response {
            case .success(let data):
                guard let data = data as? ToDoResponse else { return }
                
                if data.resultCode == 200 {
                    self.alertTitle(message: "작성 성공")
                    let task = Task(id: data.data.id, title: title, done: data.data.done)
                    self.tasks.append(task)
                } else if data.resultCode == 500 {
                    self.alertTitle(message: "작성 실패")
                }
            case .requestErr(let err):
                print(err)
                self.alertTitle(message: "작성 실패")
            case .pathErr:
                print("pathErr")
                self.alertTitle(message: "작성 실패")
            case .serverErr:
                print("serverErr")
                self.alertTitle(message: "작성 실패")
            case .networkFail:
                print("networkFail")
                self.alertTitle(message: "작성 실패")
            }
        }
    }

    func inquireCheck(year: String, month: String, day: String) {
        ToDoService.shared.inquireToDo(year: year, month: month, day: day) {
            response in
            print("response : \(response)")
            switch response {
            case .success(let data):
                guard let data = data as? ToDoListResponse else { return }
                
                if data.resultCode == 200 {
                    self.alertTitle(message: "조회 성공")
                    let task = data.data.map {
                        [
                            "id": $0.id,
                            "title": $0.title,
                            "done": $0.done
                        ]
                    }
                    self.tasks = task.compactMap {
                        guard let id = $0["id"] as? Int else {return nil}
                        guard let title = $0["title"] as? String else {return nil}
                        guard let done = $0["done"] as? Bool else {return nil}

                        return Task(id: id, title: title, done: done)
                    }
                }
            case .requestErr(let err):
                print(err)
                self.alertTitle(message: "조회 실패")
            case .pathErr:
                print("pathErr")
                self.alertTitle(message: "조회 실패")
            case .serverErr:
                print("serverErr")
                self.alertTitle(message: "조회 실패")
            case .networkFail:
                print("networkFail")
                self.alertTitle(message: "조회 실패")
            }
        }
    }
    
    func editCheck(id: Int, year: String, month: String, day: String, title: String, done: Bool) {
        ToDoService.shared.editToDo(id: id, year: year, month: month, day: day, title: title, done: done) {
            response in
            print(response)
            switch response {
            case .success(let data):
                guard let data = data as? EditToDoResponse else { return }

                if data.resultCode == 200 {
                    self.alertTitle(message: "수정 성공")
                } else {
                    self.alertTitle(message: "수정 실패")
                }
            case .requestErr(let err):
                print(err)
                self.alertTitle(message: "수정 실패")
            case .pathErr:
                print("pathErr")
                self.alertTitle(message: "수정 실패")
            case .serverErr:
                print("serverErr")
                self.alertTitle(message: "수정 실패")
            case .networkFail:
                print("networkFail")
                self.alertTitle(message: "수정 실패")
            }
        }
    }
    
    func deleteCheck(id: Int) {
        ToDoService.shared.deleteToDo(id: id) {
            response in
            print(response)
            switch response {
            case .success(let data):
                guard let data = data as? DeleteToDoResponse else { return }
                
                if data.resultCode == 200
                {
                    self.alertTitle(message: "삭제 성공")
                } else {
                    self.alertTitle(message: String(data.resultCode))
                }
            case .requestErr(let err):
                print(err)
                self.alertTitle(message: "삭제 실패")
            case .pathErr:
                print("pathErr")
                self.alertTitle(message: "삭제 실패")
            case .serverErr:
                print("serverErr")
                self.alertTitle(message: "삭제 실패")
            case .networkFail:
                print("networkFail")
                self.alertTitle(message: "삭제 실패")
            }
        }
    }
    
    func alertTitle(message:String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        present(alertVC,animated:true,completion: nil)
    }
}

extension ListViewController: FSCalendarDataSource {
    
}

extension ListViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
    
        dateFormatter.dateFormat = "Y"
        let year = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "M"
        let month = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "D"
        let day = dateFormatter.string(from: date)
        self.inquireCheck(year: year, month: month, day: day)
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print(dateFormatter.string(from: date) + " 날짜가 선택 해제 되었습니다.")
    }
}


extension ListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        let task = self.tasks[indexPath.row]
        
        cell.textLabel?.text = task.title
        if task.done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    // 편집모드 가지 않고 스와이프로도 삭제 가능
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let task = self.tasks[indexPath.row]
        deleteCheck(id: task.id)
        self.tasks.remove(at: indexPath.row)
        
        if self.tasks.isEmpty {
            self.doneButtonTap()
        }
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var tasks = self.tasks

        let task = tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(task, at: destinationIndexPath.row)
        self.tasks = tasks
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var task = self.tasks[indexPath.row]
//        task.done = !task.done
//        self.tasks[indexPath.row] = task
//        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        
        let alert = UIAlertController(title: "할 일 수정", message: nil, preferredStyle: .alert)
        // 클로저 내에 캡쳐 목록 정의([weak self])를 하여 강한 순환참조 회피
        let registerButton = UIAlertAction(title: "수정", style: .default, handler: { [weak self] _ in
            guard let title = alert.textFields?[0].text else {return}

            self?.tasks.remove(at: indexPath.row)
            let task = Task(id: task.id, title: title, done: task.done)
            self?.tasks.insert(task, at: indexPath.row)

            let date = DateFormatter()
            date.dateFormat = "Y"
            let year = date.string(from: Date())
            date.dateFormat = "M"
            let month = date.string(from: Date())
            date.dateFormat = "D"
            let day = date.string(from: Date())
            self?.editCheck(id: task.id, year: year, month: month, day: day, title: title, done: task.done)
        })
        
        let doneButton = UIAlertAction(title: "마무리", style: .default, handler: {
            _ in
            let date = DateFormatter()
            date.dateFormat = "Y"
            let year = date.string(from: Date())
            date.dateFormat = "M"
            let month = date.string(from: Date())
            date.dateFormat = "D"
            let day = date.string(from: Date())
            
            self.tasks[indexPath.row].done = !self.tasks[indexPath.row].done
            
            self.editCheck(id: task.id, year: year, month: month, day: day, title: task.title, done: self.tasks[indexPath.row].done)
            
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(registerButton)
        alert.addAction(doneButton)
        alert.addAction(cancelButton)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "할 일을 입력하세요."
        })
        
        self.present(alert, animated: true, completion: nil)
    }
}
