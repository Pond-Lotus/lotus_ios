//
//  SetPriorityVeiwController.swift
//  ToDo
//
//  Created by 제임스 on 2023/02/24.
//

import UIKit

class SetPriorityViewController:UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var priorityArray:[Character] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.setEditing(true, animated: true)
        
        TodoService.shared.getPriority { (response) in
            switch (response){
            case .success(let resultData):
                if let data = resultData as? PriorityResponseData{
                    if data.resultCode == 200{
                        self.priorityArray = Array(String(data.data))
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
    
    @IBAction func tapPreButton(_ sender: Any) {
        self.dismiss(animated: false)
    }
    @IBAction func didLongPressCell(_ sender: Any) {
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
        
        let temp = priorityArray[sourceIndexPath.row]
        priorityArray.remove(at: sourceIndexPath.row)
        priorityArray.insert(temp, at: destinationIndexPath.row)
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

