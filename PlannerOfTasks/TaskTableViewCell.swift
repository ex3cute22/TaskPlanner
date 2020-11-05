//
//  TaskTableViewCell.swift
//  PlannerOfTasks
//
//  Created by Илья Викторов on 30.10.2020.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var statusView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
