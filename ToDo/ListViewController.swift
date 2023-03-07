//
//  ListViewController.swift
//  ToDo
//
//  Created by KDS on 2023/01/18.
//

import UIKit
import FSCalendar
import SnapKit

class ListViewController: UIViewController {
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarSegmentedControl: UISegmentedControl!
    @IBOutlet weak var calendarView: FSCalendar!
    // weak로 하면 버튼을 눌렀을 때 done으로 바뀌면서 메모리에서 해제가 되어 재사용할 수 없게 됨
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var floatingButton: UIButton!
    
    private lazy var dateFormatter: DateFormatter = { // lazy?
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "yyyy. MM"
        return df
    }()
    
    var tasks = [Task]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var events = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.dataSource = self
        calendarView.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.calendarView.calendarHeaderView.isHidden = true
        self.monthLabel.text = self.dateFormatter.string(from: calendarView.currentPage)
        self.monthLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.dateLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        self.dateLabel.text = ""
        
        calendarView.appearance.weekdayTextColor = .black
        calendarView.appearance.titleWeekendColor = .red
        calendarView.appearance.todayColor = .none
        calendarView.appearance.titleTodayColor = .black
        calendarView.appearance.selectionColor = UIColor(red: 1, green: 0.784, blue: 0.592, alpha: 1)
        calendarView.appearance.titleSelectionColor = .black
        calendarView.appearance.titleFont = .systemFont(ofSize: 13, weight: .semibold)
        calendarView.appearance.weekdayFont = .systemFont(ofSize: 13, weight: .regular)

        self.view.addSubview(calendarView)
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false // AutoLayout 적용
        calendarView.widthAnchor.constraint(equalToConstant: 329).isActive = true
        calendarView.heightAnchor.constraint(equalToConstant: 264).isActive = true
        calendarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110).isActive = true
        calendarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 31).isActive = true
        calendarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -31).isActive = true

        calendarView.appearance.eventDefaultColor = UIColor(red: 1, green: 0.704, blue: 0.704, alpha: 1)
        calendarView.appearance.eventSelectionColor = UIColor(red: 1, green: 0.704, blue: 0.704, alpha: 1)

        
        setEvents()

//        topView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
//        topView.layer.cornerRadius = 20
        
//        topView.layer.shadowOpacity = 1
//        topView.layer.shadowColor = UIColor.black.cgColor
//        topView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        topView.layer.shadowRadius = 10
//        topView.layer.masksToBounds = false
        
        self.view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.widthAnchor.constraint(equalToConstant: 114).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        
        
        self.view.addSubview(floatingButton)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -23).isActive = true
        floatingButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -37).isActive = true
        
        self.view.addSubview(floatingButton2)
        
        print(UserDefaults.standard.string(forKey: "myToken")!)
    }
    
//    private func rotateFloatingButton() {
//        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
//        let fromValue = isActive ? 0 : CGFloat.pi / 4
//        let toValue = isActive ? CGFloat.pi / 4 : 0
//        animation.fromValue = fromValue
//        animation.toValue = toValue
//        animation.duration = 0.3
//        animation.fillMode = .forwards
//        animation.isRemovedOnCompletion = false
//        floatingButton.layer.add(animation, forKey: nil)
//    }
    private lazy var floatingButton2: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemPink
        config.cornerStyle = .capsule
//        config.image = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
//        config.image = UIImage(named: "logo1")
        button.configuration = config
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
//        button.addTarget(self, action: #selector(didTapFloatingButton), for: .touchUpInside)
        return button
    }()
    
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
            date.dateFormat = "HHMM"
            let time = date.string(from: Date())
            
            let description: String = " "
            let color: Int = 1

            self?.writeCheck(year: year, month: month, day: day, title: title, color: color, description: description, time: time)
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(registerButton)
        alert.addAction(cancelButton)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "할 일을 입력하세요."
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func setEvents() {
        let dfMatter = DateFormatter()
        dfMatter.locale = Locale(identifier: "ko_KR")
        dfMatter.dateFormat = "yyyy-MM-dd"
        
        // events
        let myFirstEvent = dfMatter.date(from: "2023-03-01")
        let mySecondEvent = dfMatter.date(from: "2023-03-20")
        let myThirdEvent = dfMatter.date(from: "2023-03-20")
        
        events = [myFirstEvent!, mySecondEvent!, myThirdEvent! , myThirdEvent!, myThirdEvent!]
    }
}

extension ListViewController {
    func writeCheck(year: String, month: String, day: String, title: String, color: Int, description: String, time: String) {
        ToDoService.shared.writeToDo(year: year, month: month, day: day, title: title, color: color, description: description, time: time) {
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
                print("requestErr : \(err)")
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
                print("requestErr : \(err)")
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
                print("requestErr : \(err)")
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
                print("requestErr : \(err)")
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
        
        dateFormatter.dateFormat = "EEEEEE"
        let tmp = dateFormatter.string(from: date)
    
        self.dateLabel.text = tmp
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.monthLabel.text = self.dateFormatter.string(from: calendar.currentPage)

    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.events.contains(date) {
            var count = 0
            for e in self.events {
                if e == date {
                    count += 1
                }
            }
            return count
        } else {
            return 0
        }
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
        let task = self.tasks[indexPath.row]
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
