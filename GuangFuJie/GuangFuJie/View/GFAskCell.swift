//
//  GFAskCell.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/14.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class GFAskCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusLabel.layer.cornerRadius = 6.0
        statusLabel.layer.masksToBounds = true
        statusLabel.layer.borderColor = statusLabel.textColor.cgColor
        statusLabel.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
