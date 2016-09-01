//
//  InstallerCell.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/1.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class InstallerCell: UITableViewCell {
    
    var viewCreated = false
    var titleLabel : UILabel!
    var timeLabel : UILabel!
    var describeLabel : UILabel!
    var addressLabel : UILabel!
    var tagLabel : UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if (viewCreated) {
            titleLabel.text = ""
            describeLabel.text = ""
            addressLabel.text = ""
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
        
        let cellViewHeight : CGFloat = height / 7
        let bkgView = UIView.init(frame: CGRectMake(dir, dir, width, cellViewHeight - dir))
        bkgView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(bkgView)
        
        let labelHeight = bkgView.frame.size.height / 3
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
        
        describeLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(descIconImageView.frame) + 5, CGRectGetMaxY(titleLabel.frame), labelWidth - iconWidthHeight, labelHeight))
        describeLabel.text = ""
        describeLabel.numberOfLines = 0
        describeLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        describeLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        describeLabel.textColor = UIColor.lightGrayColor()
        bkgView.addSubview(describeLabel)
        
        let addressIconImageView = UIImageView.init(frame: CGRectMake(5, CGRectGetMaxY(describeLabel.frame) + 5, iconWidthHeight, iconWidthHeight))
        addressIconImageView.image = UIImage(named: "ic_address")
        bkgView.addSubview(addressIconImageView)
        
        addressLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(addressIconImageView.frame) + 5, CGRectGetMaxY(describeLabel.frame), labelWidth - iconWidthHeight, labelHeight))
        addressLabel.text = ""
        addressLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        addressLabel.textColor = UIColor.lightGrayColor()
        bkgView.addSubview(addressLabel)
        
        let tagStartY = (bkgView.frame.size.height - labelHeight) / 2
        tagLabel = UILabel.init(frame: CGRectMake(bkgView.frame.size.width - labelWidth * 1 / 5, tagStartY, labelWidth * 1 / 5, labelHeight))
        tagLabel.text = "点我接单"
        tagLabel.textAlignment = NSTextAlignment.Right
        tagLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        tagLabel.textColor = Colors.installColor
        bkgView.addSubview(tagLabel)
    }
    
    static func cellHeight() -> CGFloat {
        var height = PhoneUtils.kScreenHeight
        if (height < 568) {
            height = 568
        }
        return height / 7
    }
    
}

