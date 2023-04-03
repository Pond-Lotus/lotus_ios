//
//  PriorityTableViewCell.swift
//  ToDo
//
//  Created by 제임스 on 2023/02/24.
//

import UIKit

class PriorityTableViewCell:UITableViewCell{
    
    @IBOutlet weak var colorRoundView: UIView!
    @IBOutlet weak var categoryNameTextField: UITextField!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
