//
//  TodoTableViewCell.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/23.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    var todo:TodoList = .init(title: "", done: false, isNew: false, writer: "", color: 0, id: 0, description: "", year: "", month: "", day: "")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBackgroundView.layer.cornerRadius = 8
        
        titleTextField.addTarget(self, action: #selector(writeTodo), for: .editingDidEnd)
        
        
        titleTextField.becomeFirstResponder()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if todo.isNew{
            titleTextField.isEnabled = true
            titleTextField.becomeFirstResponder()
        }else{
            titleTextField.isEnabled = false
        }
    }
    
    @IBAction func tapCheckbox(_ sender: Any) {
        print("id: \(self.todo.id), color: \(self.todo.color), done: \(self.todo.done)")
        
        TodoService.shared.editDone(id: todo.id, done: !todo.done) { (response) in
            switch (response){
            case .success(let resultData):
                if let data = resultData as? TodoEditResponseData{
                    print(data.resultCode)
                    if data.resultCode == 200{
                        self.todo.done = !self.todo.done
                        print("edit done : \(self.todo.done)")
                        if self.todo.done{
                            switch self.todo.color{
                            case 1: self.checkbox.setImage(UIImage(named: "checkbox_red"), for: .normal)
                            case 2: self.checkbox.setImage(UIImage(named: "checkbox_yellow"), for: .normal)
                            case 3: self.checkbox.setImage(UIImage(named: "checkbox_green"), for: .normal)
                            case 4: self.checkbox.setImage(UIImage(named: "checkbox_blue"), for: .normal)
                            case 5: self.checkbox.setImage(UIImage(named: "checkbox_pink"), for: .normal)
                            case 6: self.checkbox.setImage(UIImage(named: "checkbox_purple"), for: .normal)
                            default : self.checkbox.setImage(UIImage(named: "checkbox_gray"), for: .normal)
                            }
                        }else{
                            self.checkbox.setImage(UIImage(named: "checkbox"), for: .normal)
                            
                        }
                    }
                }
            case .requestErr(let message):
                print("requestErr", message)
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
    
    @objc func writeTodo(){
        print("finish writing")
        TodoService.shared.writeTodo(year: todo.year, month: todo.month, day: todo.day, title: titleTextField.text ?? "", color: todo.color) { (response) in
            switch (response){
            case .success(let resultData):
                if let data = resultData as? TodoWriteResponseData{
                    if data.resultCode == 200 {
                        self.todo.isNew = false
                        self.titleTextField.isEnabled = false
                        self.todo.id = data.data.id
                        self.todo.title = self.titleTextField.text ?? ""
                        self.reloadInputViews() //isnew = false로 변경하고 cell reload
                    }
                }
            case .requestErr(let message):
                print("requestErr", message)
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
    
    private func setCheckBox(color:Int, checkbox:UIButton){
        switch (color){
        case 1:
            self.checkbox.setImage(UIImage(named: "checkbox_red"), for: .normal)
            break
        case 2:
            self.checkbox.setImage(UIImage(named: "checkbox_yellow"), for: .normal)
            break
        case 3:
            self.checkbox.setImage(UIImage(named: "checkbox_green"), for: .normal)
            break
        case 4:
            self.checkbox.setImage(UIImage(named: "checkbox_blue"), for: .normal)
            break
        case 5:
            self.checkbox.setImage(UIImage(named: "checkbox_pink"), for: .normal)
            break
        case 6:
            self.checkbox.setImage(UIImage(named: "checkbox_purple"), for: .normal)
            break
        default:
            break
        }
    }
}

