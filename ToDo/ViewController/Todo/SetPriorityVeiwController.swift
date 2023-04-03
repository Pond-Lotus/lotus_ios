//
//  SetPriorityVeiwController.swift
//  ToDo
//
//  Created by 제임스 on 2023/02/24.
//

import UIKit

class SetPriorityViewController:UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var priorityArray:[Character] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    var categoryArray:[String] = ["","","","","",""]{
        didSet{
            tableView.reloadData()
        }
    }
    
    var categoryDictionary:[Character:String] = ["1":"","2":"","3":"","4":"","5":"","6":""]
    
    var isValueEditing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
            
        getPriority()
    }
    
    
    @IBAction func tapPreButton(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func didLongPressCell(_ sender: Any) {
    }
    
    @IBAction func tapEditButton(_ sender: Any) {
        isValueEditing = !isValueEditing
        if isValueEditing{
            editButton.title = "완료"
            tableView.setEditing(true, animated: true)
        }else{
            editButton.title = "편집"
            tableView.setEditing(false, animated: true)
        }
    }
    
    private func getPriority(){
        TodoService.shared.getPriority { (response) in
            switch (response){
            case .success(let resultData):
                if let data = resultData as? PriorityResponseData{
                    if data.resultCode == 200{
                        self.priorityArray = Array(String(data.data))
                        self.getCategoryName()
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
    
    private func getCategoryName(){
        TodoService.shared.getCategoryName { (response) in
            switch (response){
            case .success(let resultData):
                if let data = resultData as? CategoryResponseData{
                    if data.resultCode == 200{
                        self.categoryArray.removeAll()
                        for i in self.priorityArray{
                            switch(i){
                            case "1":
                                let name = data.data._1
                                self.categoryArray.append(name)
                                self.categoryDictionary["1"] = name
                            case "2":
                                let name = data.data._2
                                self.categoryArray.append(name)
                                self.categoryDictionary["2"] = name
                            case "3":
                                let name = data.data._3
                                self.categoryArray.append(name)
                                self.categoryDictionary["3"] = name
                            case "4":
                                let name = data.data._4
                                self.categoryArray.append(name)
                                self.categoryDictionary["4"] = name
                            case "5":
                                let name = data.data._5
                                self.categoryArray.append(name)
                                self.categoryDictionary["5"] = name
                            case "6":
                                let name = data.data._6
                                self.categoryArray.append(name)
                                self.categoryDictionary["6"] = name
                            default: break
                            }
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
    
    
}
extension SetPriorityViewController:UITableViewDelegate{
    
}
extension SetPriorityViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priorityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PriorityCell", for: indexPath) as! PriorityTableViewCell
    
        switch(priorityArray[indexPath.row]){
        case "1": cell.colorRoundView.backgroundColor = Color.red
        case "2": cell.colorRoundView.backgroundColor = Color.yellow
        case "3": cell.colorRoundView.backgroundColor = Color.green
        case "4": cell.colorRoundView.backgroundColor = Color.blue
        case "5": cell.colorRoundView.backgroundColor = Color.pink
        case "6": cell.colorRoundView.backgroundColor = Color.purple
        default: cell.colorRoundView.backgroundColor = Color.gray
        }
        cell.categoryNameTextField.text = categoryArray[indexPath.row]
        cell.colorRoundView.layer.cornerRadius = cell.colorRoundView.fs_width/2
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let tempPriority = priorityArray[sourceIndexPath.row]
        let tempCategory = categoryArray[sourceIndexPath.row]
        priorityArray.remove(at: sourceIndexPath.row)
        categoryArray.remove(at: sourceIndexPath.row)
        priorityArray.insert(tempPriority, at: destinationIndexPath.row)
        categoryArray.insert(tempCategory, at: destinationIndexPath.row)

        var priorityString = ""
        for i in priorityArray{
            priorityString.append(i)
        }
        
        TodoService.shared.setPriority(priority: priorityString) { (response) in
            switch (response){
            case .success(let resultData):
                if let data = resultData as? PriorityResponseData{
                    print("priority resultCode: \(data.resultCode)")
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
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

}

