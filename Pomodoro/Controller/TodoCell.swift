//
//  TodoCell.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/9/30.
//

import UIKit

class TodoCell: UITableViewCell {

    
    @IBOutlet weak var todo: UILabel!
    @IBOutlet weak var leftTime: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
