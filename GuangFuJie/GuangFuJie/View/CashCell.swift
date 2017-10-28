//
//  CashCell.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/9/18.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class CashCell: UITableViewCell {

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    @IBOutlet weak var sixthLabel: UILabel!
    @IBOutlet weak var seventhLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        firstLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        secondLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        thirdLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        fourthLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        fifthLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        sixthLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        seventhLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        
        let width = PhoneUtils.kScreenWidth / 7
        firstLabel.frame = CGRect(x: 0, y: 0, width: width, height: firstLabel.frame.size.height)
        secondLabel.frame = CGRect(x: width, y: 0, width: width, height: secondLabel.frame.size.height)
        thirdLabel.frame = CGRect(x: width * 2, y: 0, width: width, height: thirdLabel.frame.size.height)
        fourthLabel.frame = CGRect(x: width * 3, y: 0, width: width, height: fourthLabel.frame.size.height)
        fifthLabel.frame = CGRect(x: width * 4, y: 0, width: width, height: fifthLabel.frame.size.height)
        sixthLabel.frame = CGRect(x: width * 5, y: 0, width: width, height: sixthLabel.frame.size.height)
        seventhLabel.frame = CGRect(x: width * 6, y: 0, width: width, height: seventhLabel.frame.size.height)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
