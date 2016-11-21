//
//  SafeCell.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/8.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class SafeCell: UITableViewCell {
    var viewCreated = false
    var titleLabel : UILabel!
    var timeLabel : UILabel!
    var describeLabel : UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if (viewCreated) {
            titleLabel.text = ""
            describeLabel.text = ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initCell() {
        if(viewCreated){
            return
        }
        viewCreated = true
        self.backgroundColor = UIColor.clearColor()
        
        let dir : CGFloat = 5
        let width = PhoneUtils.kScreenWidth - 2 * dir
        var height = PhoneUtils.kScreenHeight
        if (height < 568) {
            height = 568
        }
        
        let cellViewHeight : CGFloat = height / 10
        let bkgView = UIView.init(frame: CGRectMake(dir, dir, width, cellViewHeight - dir))
        bkgView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(bkgView)
        
        let labelHeight = bkgView.frame.size.height / 2
        let labelWidth = bkgView.frame.size.width
        
        let iconWidthHeight = labelHeight - 10
        
        titleLabel = UILabel.init(frame: CGRectMake(0, 0, labelWidth * 1 / 2, labelHeight))
        titleLabel.text = ""
        titleLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        titleLabel.textColor = UIColor.lightGrayColor()
        bkgView.addSubview(titleLabel)
        
        timeLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, labelWidth * 1 / 2, labelHeight))
        timeLabel.text = ""
        timeLabel.textAlignment = NSTextAlignment.Right
        timeLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        timeLabel.textColor = UIColor.lightGrayColor()
        bkgView.addSubview(timeLabel)
        
        let descIconImageView = UIImageView.init(frame: CGRectMake(5, CGRectGetMaxY(titleLabel.frame) + 5, iconWidthHeight, iconWidthHeight))
        descIconImageView.image = UIImage(named: "ic_brief")
        bkgView.addSubview(descIconImageView)
        
        describeLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(descIconImageView.frame) + 5, CGRectGetMaxY(titleLabel.frame), labelWidth - iconWidthHeight - dir * 2, labelHeight))
        describeLabel.text = ""
        describeLabel.numberOfLines = 0
        describeLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        describeLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        describeLabel.textColor = UIColor.lightGrayColor()
        bkgView.addSubview(describeLabel)
    }
    
    static func cellHeight() -> CGFloat {
        var height = PhoneUtils.kScreenHeight
        if (height < 568) {
            height = 568
        }
        return height / 10
    }

}
