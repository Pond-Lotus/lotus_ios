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
    
    var tasks = [Task]() {
        didSet {
            // tasks 배열에 추가될 때마다 UserDefaults에 할 일이 저장됨
            self.saveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
        // 이게 없으면 extension에 정의한 함수가 호출되지 않음
        self.tableView.dataSource = self
        
        self.tableView.delegate = self

        self.loadTasks()
        
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
            
            let task = Task(title: title, done: false)
            self?.tasks.append(task)
            self?.tableView.reloadData()
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(registerButton)
        alert.addAction(cancelButton)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "할 일을 입력하세요."
        })
        
        self.present(alert, animated: true, completion: nil)
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
    }
    
}
