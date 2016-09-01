//
//  YeZhuCell.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/8/20.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class YeZhuCell: UITableViewCell {

    var viewCreated = false
    var titleLabel : UILabel!
    var tagLabel : UILabel!
    var describeLabel : TopLeftLabel!
    var addressLabel : UILabel!
    var contractLabel : UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if (viewCreated) {
            titleLabel.text = ""
            describeLabel.text = ""
            addressLabel.text = ""
            contractLabel.text = ""
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
        
        let cellViewHeight : CGFloat = height / 6
        let bkgView = UIView.init(frame: CGRectMake(dir, dir, width, cellViewHeight - dir))
        bkgView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(bkgView)
        
        let labelHeight = bkgView.frame.size.height / 4
        let labelWidth = bkgView.frame.size.width
        
        let iconWidthHeight = labelHeight - 10
        
        titleLabel = UILabel.init(frame: CGRectMake(0, 0, labelWidth * 3 / 4, labelHeight))
        titleLabel.text = ""
        titleLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        titleLabel.textColor = UIColor.lightGrayColor()
        bkgView.addSubview(titleLabel)
        
        tagLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, labelWidth * 1 / 4, labelHeight))
        tagLabel.text = "已认证"
        tagLabel.textAlignment = NSTextAlignment.Right
        tagLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        bkgView.addSubview(tagLabel)
        
        let descIconImageView = UIImageView.init(frame: CGRectMake(5, CGRectGetMaxY(titleLabel.frame) + 5, iconWidthHeight, iconWidthHeight))
        descIconImageView.image = UIImage(named: "ic_brief")
        bkgView.addSubview(descIconImageView)
        
        describeLabel = TopLeftLabel.init(frame: CGRectMake(CGRectGetMaxX(descIconImageView.frame) + 5, CGRectGetMaxY(titleLabel.frame), labelWidth - iconWidthHeight - 5, labelHeight))
        describeLabel.text = ""
        describeLabel.numberOfLines = 0
        describeLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        describeLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        describeLabel.textColor = UIColor.lightGrayColor()
        bkgView.addSubview(describeLabel)
        
        let addressIconImageView = UIImageView.init(frame: CGRectMake(5, CGRectGetMaxY(describeLabel.frame) + 5, iconWidthHeight, iconWidthHeight))
        addressIconImageView.image = UIImage(named: "ic_address")
        bkgView.addSubview(addressIconImageView)
        
        addressLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(addressIconImageView.frame) + 5, CGRectGetMaxY(describeLabel.frame), labelWidth - iconWidthHeight - 5, labelHeight))
        addressLabel.text = ""
        addressLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        addressLabel.textColor = UIColor.lightGrayColor()
        bkgView.addSubview(addressLabel)
        
        let contractIconImageView = UIImageView.init(frame: CGRectMake(5, CGRectGetMaxY(addressLabel.frame) + 5, iconWidthHeight, iconWidthHeight))
        contractIconImageView.image = UIImage(named: "ic_call")
        bkgView.addSubview(contractIconImageView)
        
        contractLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(contractIconImageView.frame) + 5, CGRectGetMaxY(addressLabel.frame), labelWidth - iconWidthHeight - 5, labelHeight))
        contractLabel.text = ""
        contractLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        contractLabel.textColor = UIColor.lightGrayColor()
        bkgView.addSubview(contractLabel)
    }
    
    static func cellHeight() -> CGFloat {
        var height = PhoneUtils.kScreenHeight
        if (height < 568) {
            height = 568
        }
        return height / 6
    }

}
