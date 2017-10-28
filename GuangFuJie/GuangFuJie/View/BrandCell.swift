//
//  BrandCell.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/10/28.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class BrandCell: UITableViewCell {
    var logoImageView: UIImageView!
    var companyNameLabel: UILabel!
    var describeLabel: YCTopLeftLabel!

    var viewCreated = false
    func initCell() {
        if (viewCreated) {
            return
        }
        viewCreated = true
        
        let times = YCPhoneUtils.screenWidth / 375
        logoImageView = UIImageView.init(frame: CGRect(x: 26 * times, y: 31 * times, width: 60 * times, height: 45 * times))
        self.contentView.addSubview(logoImageView)
        
        companyNameLabel = UILabel.init(frame: CGRect(x: logoImageView.frame.maxX + 15 * times, y: 40 * times, width: 80 * times, height: 25 * times))
        companyNameLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 14))
        self.contentView.addSubview(companyNameLabel)
        
        let viewLabel = UILabel.init(frame: CGRect(x: 282 * times, y: 40 * times, width: 75 * times, height: 25 * times))
        viewLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 14))
        viewLabel.text = "查看产品"
        viewLabel.textColor = Colors.appBlue
        viewLabel.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(viewLabel)
        
        describeLabel = YCTopLeftLabel.init(frame: CGRect(x: (YCPhoneUtils.screenWidth - 340 * times) / 2, y: 95 * times, width: 340 * times, height: 90 * times))
        describeLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 14))
        describeLabel.numberOfLines = 0
        describeLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.contentView.addSubview(describeLabel)
        
        let line = UILabel.init(frame: CGRect(x: 0, y: 200 * times - 1, width: YCPhoneUtils.screenWidth, height: 1))
        line.backgroundColor = Colors.bkgColor
        self.contentView.addSubview(line)
    }
    
    func setData(brandInfo: BrandInfo) {
        logoImageView.setImageWith(URL.init(string: YCStringUtils.getString(brandInfo.image))!)
        describeLabel.text = YCStringUtils.getString(brandInfo.desc)
        companyNameLabel.text = YCStringUtils.getString(brandInfo.name)
    }
    
    static func cellHeight() -> CGFloat {
        let times = YCPhoneUtils.screenWidth / 375
        return 200 * times
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
