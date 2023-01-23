//
//  TodoTableViewCell.swift
//  ToDo
//
//  Created by 제임스 on 2023/01/23.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if self.titleTextField.isEditing {
            
        }
    }

}
