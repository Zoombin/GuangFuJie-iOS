//
//  CalResultCommonCell.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/9/18.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class CalResultCommonCell: UITableViewCell {

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        firstLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        secondLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        thirdLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        fourthLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        
        let width = PhoneUtils.kScreenWidth / 4
        firstLabel.frame = CGRect(x: 0, y: 0, width: width, height: firstLabel.frame.size.height)
        secondLabel.frame = CGRect(x: width, y: 0, width: width, height: secondLabel.frame.size.height)
        thirdLabel.frame = CGRect(x: width * 2, y: 0, width: width, height: thirdLabel.frame.size.height)
        fourthLabel.frame = CGRect(x: width * 3, y: 0, width: width, height: fourthLabel.frame.size.height)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
