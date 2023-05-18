//
//  TodoCell.swift
//  TODORI
//
//  Created by 제임스 on 2023/04/29.
//

import UIKit
import SnapKit

protocol TodoTableViewCellDelegate:AnyObject{
    func sendData(section:Int, row:Int, todo:Todo)
}
class TodoTableViewCell:UITableViewCell{

    
    var checkbox:UIButton = UIButton()
    var titleTextField:UITextField = UITextField()
    var cellBackgroundView:UIView = UIView()
    var todo:Todo = .init(year: "", month: "", day: "", title: "", done: false, isNew: false, writer: "", color: 0, id: 0, time: "0000", description: "")
    var section:Int = 0
    var row:Int = 0
    weak var delegate:TodoTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "TodoCell")
        
        self.addComponent()
        self.setAutoLayout()
        self.setAppearence()
        self.addTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponent(){
        cellBackgroundView.addSubview(titleTextField)
        cellBackgroundView.addSubview(checkbox)
        self.contentView.addSubview(cellBackgroundView)

    }
    
    private func addTarget(){
//        titleTextField.addTarget(self, action: #selector(textFieldEndEdit), for: .editingDidEnd)
        //return키 눌렀을 때
        titleTextField.addTarget(self, action: #selector(textFieldEndEdit), for: .editingDidEndOnExit)

    }
    
    private func setAutoLayout(){
        cellBackgroundView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.centerY.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(3)
            make.bottom.equalToSuperview().inset(3)
        }
        checkbox.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }

        titleTextField.snp.makeConstraints { make in
            make.left.equalTo(checkbox.snp.right).offset(7)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    private func setAppearence(){
        cellBackgroundView.backgroundColor = .white
        cellBackgroundView.layer.cornerRadius = 10
        cellBackgroundView.clipsToBounds = true
        self.backgroundColor = .clear
        
        titleTextField.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        checkbox.setImage(UIImage(named: "checkbox"), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if todo.isNew{
            titleTextField.isEnabled = true
            titleTextField.becomeFirstResponder()
        }else{
            titleTextField.isEnabled = false
        }
    }
    
    @objc private func textFieldEndEdit(){
        TodoAPIConstant.shared.writeTodo(year: todo.year, month: todo.month, day: todo.day, title: titleTextField.text ?? "", color: todo.color) { [self] (response) in
            switch(response){
            case .success(let resultData):
                if let data = resultData as? TodoWriteResponseData{
                    if data.resultCode == 200 {
                        self.todo.isNew = false
                        self.titleTextField.isEnabled = false
                        self.todo.id = data.data.id
                        self.todo.title = data.data.title
                        self.todo.description = data.data.title
                        self.todo.time = data.data.time
                        self.todo.writer = data.data.writer
                        self.delegate?.sendData(section: self.section, row: self.row, todo: self.todo)
                        self.reloadInputViews() //isnew = false로 변경하고 cell reload
                    }
                }
            case .failure(let message):
                print("failure", message)
            }
        }
    }
}


