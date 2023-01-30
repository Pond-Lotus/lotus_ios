//
//  ListViewController.swift
//  ToDo
//
//  Created by KDS on 2023/01/18.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    // weak로 하면 버튼을 눌렀을 때 done으로 바뀌면서 메모리에서 해제가 되어 재사용할 수 없게 됨
    @IBOutlet var editButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem?
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var tasks = [Task]() {
        didSet {
//            self.saveTasks()
            self.saveToDo()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
        self.tableView.dataSource = self
        self.tableView.delegate = self
//        self.loadTasks()
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
            
//            let task = Task(title: title, done: false)
//            self?.tasks.append(task)
//            self?.tableView.reloadData()
            
            let date = DateFormatter()
            date.dateFormat = "Y"
            let year = date.string(from: Date())
            date.dateFormat = "M"
            let month = date.string(from: Date())
            date.dateFormat = "D"
            let day = date.string(from: Date())

            self?.writeCheck(year: year, month: month, day: day, title: title)
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
        
        self.searchCheck(year: year, month: month, day: "24")
    }
    
    @IBAction func tapDeleteButton(_ sender: Any) {
        let date = DateFormatter()
        date.dateFormat = "Y"
        let year = date.string(from: Date())
        date.dateFormat = "M"
        let month = date.string(from: Date())
        date.dateFormat = "D"
        let day = date.string(from: Date())
        
        self.deleteCheck(year: year, month: month, day: day, title: "ss", done: "true")
    }
    
    func saveTasks() {
        let data = self.tasks.map {
            [
                "title": $0.title,
                "done": $0.done
            ]
        }
        // UserDefaults는 싱글톤이기 때문에 하나의 인스턴스만 존재?
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
    }
    
    func loadTasks() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else {return}
        self.tasks = data.compactMap {
            guard let title = $0["title"] as? String else {return nil}
            guard let done = $0["done"] as? Bool else {return nil}
            
            return Task(title: title, done: done)
        }
    }
    
    func saveToDo() {
    }
    
    func loadToDo() {
    }
    
}

// 코드 가독성을 위해
extension ListViewController: UITableViewDataSource {
    // UITableViewDataSource에 정의된 옵셔널 함수를 무조건 정의해줘야 함
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    // 스토리보드에서 가져온 셀이 테이블뷰에 생김
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 예를 들어 화면에 5개의 셀만 표시된다면 그만큼만 메모리에 할당
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        // 편집모드 가지 않고 스와이프로도 삭제 가능
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
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
        task.done = !task.done
        self.tasks[indexPath.row] = task
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        
        let alert = UIAlertController(title: "할 일 수정", message: nil, preferredStyle: .alert)
        // 클로저 내에 캡쳐 목록 정의([weak self])를 하여 강한 순환참조 회피
        let registerButton = UIAlertAction(title: "수정", style: .default, handler: { [weak self] _ in
            guard let title = alert.textFields?[0].text else {return}
            
            let task = Task(title: title, done: false)
            self?.tasks.remove(at: indexPath.row)
            self?.tasks.append(task)
            self?.tableView.reloadData()
            
            let date = DateFormatter()
            date.dateFormat = "Y"
            let year = date.string(from: Date())
            date.dateFormat = "M"
            let month = date.string(from: Date())
            date.dateFormat = "D"
            let day = date.string(from: Date())
            let done: String?
            if task.done == true {
                done = "true"
            } else {
                done = "false"
            }
                
            self?.editCheck(year: year, month: month, day: day, title: title, done: done!)
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(registerButton)
        alert.addAction(cancelButton)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "할 일을 입력하세요."
        })
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension ListViewController {
    func writeCheck(year: String, month: String, day: String, title: String) {
        ToDoService.shared.writeToDo(year: year, month: month, day: day, title: title) {
            response in
            print(response)
            switch response {
            case .success(let data):
                guard let data = data as? ToDoResponse else { return }
                
                if data.resultCode == 200 {
                    self.alertLoginFail(message: "작성 성공")
                    
                    let task = Task(title: title, done: false)
                    self.tasks.append(task)
                    self.tableView.reloadData()
                    
                } else if data.resultCode == 500 {
                    self.alertLoginFail(message: "작성 실패")
                }
            case .requestErr(let err):
                print(err)
                self.alertLoginFail(message: "작성 실패")
            case .pathErr:
                print("pathErr")
                self.alertLoginFail(message: "작성 실패")
            case .serverErr:
                print("serverErr")
                self.alertLoginFail(message: "작성 실패")
            case .networkFail:
                print("networkFail")
                self.alertLoginFail(message: "작성 실패")
            }
        }
    }

    func searchCheck(year: String, month: String, day: String) {
        ToDoService.shared.searchToDo(year: year, month: month, day: day) {
            response in
            switch response {
            case .success(let data):
                guard let data = data as? ToDoListResponse else { return }
                
                if data.resultCode == 200 {
                    self.alertLoginFail(message: "조회 성공")
                    let task = data.data.map {
                        [
                            "id": $0.id,
                            "title": $0.title,
                            "done": $0.done
                        ]
                    }
                    self.tasks = task.compactMap {
//                        guard let title = $0["id"] as? Int else {return nil}
                        guard let title = $0["title"] as? String else {return nil}
                        guard let done = $0["done"] as? Bool else {return nil}

                        return Task(title: title, done: done)
                    }
                    self.tableView.reloadData()
                    
                } else {
                    self.alertLoginFail(message: "조회 실패")
                }
            case .requestErr(let err):
                print(err)
                self.alertLoginFail(message: "조회 실패")
            case .pathErr:
                print("pathErr")
                self.alertLoginFail(message: "조회 실패")
            case .serverErr:
                print("serverErr")
                self.alertLoginFail(message: "조회 실패")
            case .networkFail:
                print("networkFail")
                self.alertLoginFail(message: "조회 실패")
            }
        }
    }
    
    func editCheck(year: String, month: String, day: String, title: String, done: String) {
        ToDoService.shared.editToDo(year: year, month: month, day: day, title: title, done: done) {
            response in
            print(response)
            switch response {
            case .success(let data):
                guard let data = data as? ToDoResponse else { return }

                if data.resultCode == 200 {
                    self.alertLoginFail(message: "수정 성공")
                } else {
                    self.alertLoginFail(message: "수정 실패")
                }
            case .requestErr(let err):
                print(err)
                self.alertLoginFail(message: "수정 실패")
            case .pathErr:
                print("pathErr")
                self.alertLoginFail(message: "수정 실패")
            case .serverErr:
                print("serverErr")
                self.alertLoginFail(message: "수정 실패")
            case .networkFail:
                print("networkFail")
                self.alertLoginFail(message: "수정 실패")
            }
        }
    }
    
    func deleteCheck(year: String, month: String, day: String, title: String, done: String) {
        ToDoService.shared.deleteToDo(year: year, month: month, day: day, title: title, done: done) {
            response in
            print(response)
            switch response {
            case .success(let data):
                guard let data = data as? DeleteToDoResponse else { return }
                
                if data.detail.isEmpty
                {
                    self.alertLoginFail(message: "삭제 성공")
                } else {
                    self.alertLoginFail(message: data.detail)
                }
            case .requestErr(let err):
                print(err)
                self.alertLoginFail(message: "삭제 실패")
            case .pathErr:
                print("pathErr")
                self.alertLoginFail(message: "삭제 실패")
            case .serverErr:
                print("serverErr")
                self.alertLoginFail(message: "삭제 실패")
            case .networkFail:
                print("networkFail")
                self.alertLoginFail(message: "삭제 실패")
            }
        }
    }
    
    func alertLoginFail(message:String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        present(alertVC,animated:true,completion: nil)
    }
}
