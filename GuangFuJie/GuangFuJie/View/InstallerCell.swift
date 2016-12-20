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
    var avatarImageView : UIImageView!
    var nameLabel : UILabel!
    var timeLabel : UILabel!
    var roofTypeLabel : UILabel!
    var roofSizeLabel : UILabel!
    var roofPriceLabel : UILabel!
    var addressLabel : UILabel!
    
    var tipsLabel : UILabel!
    var viewMoreButton : UIButton!
    
    func initCell() {
        if (viewCreated) {
            return
        }
        viewCreated = true
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.contentView.backgroundColor = Colors.bkgColor
        
        let dir : CGFloat = PhoneUtils.kScreenWidth / 40
        let bkgViewWidth = PhoneUtils.kScreenWidth - dir * 2
        let bkgViewHeight = YeZhuCell.cellHeight() - dir
        let bkgView = UIView.init(frame: CGRectMake(dir, 0, bkgViewWidth, bkgViewHeight))
        bkgView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(bkgView)
        
        let topView = UIView.init(frame: CGRectMake(0, 0, bkgViewWidth, bkgViewHeight / 3))
        bkgView.addSubview(topView)
        
        let dir2 : CGFloat = PhoneUtils.kScreenWidth / 36
        avatarImageView = UIImageView.init(frame: CGRectMake(dir2, dir2, bkgViewWidth / 4.5, topView.frame.size.height - dir2 * 2))
        avatarImageView.image = UIImage(named: "ic_avatar_yezhu")
        topView.addSubview(avatarImageView)
        
        let labelWidth = bkgViewWidth - avatarImageView.frame.size.width - dir2 * 3
        nameLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(avatarImageView.frame) + dir2, dir2, labelWidth, avatarImageView.frame.size.height / 2))
        nameLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        nameLabel.text = "这里是公司名称"
        topView.addSubview(nameLabel)
        
        timeLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(avatarImageView.frame) + dir2, CGRectGetMaxY(nameLabel.frame), 200, avatarImageView.frame.size.height / 2))
        timeLabel.textColor = UIColor.lightGrayColor()
        timeLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        timeLabel.text = "2015-12-12 12:12"
        topView.addSubview(timeLabel)
        
        let line1 = UIView.init(frame: CGRectMake(dir2, topView.frame.size.height, bkgViewWidth - dir2 * 2, 0.5))
        line1.backgroundColor = UIColor.lightGrayColor()
        bkgView.addSubview(line1)
        
        let bottomView = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(topView.frame), bkgViewWidth, bkgViewHeight * 2 / 3))
        bkgView.addSubview(bottomView)
        
        let pointOffSetY = (bottomView.frame.size.height * 0.15 - dir2) / 2
        
        roofTypeLabel = UILabel.init(frame: CGRectMake(dir2 * 3, bottomView.frame.size.height * 0.05, bkgViewWidth - dir2 * 5, bottomView.frame.size.height * 0.15))
        roofTypeLabel.text = "这里显示的是描述"
        roofTypeLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        roofTypeLabel.numberOfLines = 3
        roofTypeLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        bottomView.addSubview(roofTypeLabel)
        
        let typePoint = UIImageView.init(frame: CGRectMake(dir2, CGRectGetMinY(roofTypeLabel.frame) + pointOffSetY, dir2, dir2))
        typePoint.image = UIImage(named: "ic_point_blue")
        bottomView.addSubview(typePoint)
        
        roofSizeLabel = UILabel.init(frame: CGRectMake(dir2 * 3, CGRectGetMaxY(roofTypeLabel.frame), bkgViewWidth - dir2 * 5, bottomView.frame.size.height * 0.15))
        roofSizeLabel.text = "这里显示的是描述"
        roofSizeLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        roofSizeLabel.numberOfLines = 3
        roofSizeLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        bottomView.addSubview(roofSizeLabel)
        
        let sizePoint = UIImageView.init(frame: CGRectMake(dir2, CGRectGetMinY(roofSizeLabel.frame) + pointOffSetY, dir2, dir2))
        sizePoint.image = UIImage(named: "ic_yellow_point")
        bottomView.addSubview(sizePoint)
        
        roofPriceLabel = UILabel.init(frame: CGRectMake(dir2 * 3, CGRectGetMaxY(roofSizeLabel.frame), bkgViewWidth - dir2 * 5, bottomView.frame.size.height * 0.15))
        roofPriceLabel.text = "这里显示的是描述"
        roofPriceLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        roofPriceLabel.numberOfLines = 3
        roofPriceLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        bottomView.addSubview(roofPriceLabel)
        
        let pricePoint = UIImageView.init(frame: CGRectMake(dir2, CGRectGetMinY(roofPriceLabel.frame) + pointOffSetY, dir2, dir2))
        pricePoint.image = UIImage(named: "ic_green_point")
        bottomView.addSubview(pricePoint)
        
        addressLabel = UILabel.init(frame: CGRectMake(dir2 * 3, CGRectGetMaxY(roofPriceLabel.frame), bkgViewWidth - dir2 * 5, bottomView.frame.size.height * 0.15))
        addressLabel.text = "这里显示的是描述"
        addressLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        addressLabel.numberOfLines = 3
        addressLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        bottomView.addSubview(addressLabel)
        
        let addressPoint = UIImageView.init(frame: CGRectMake(dir2, CGRectGetMinY(addressLabel.frame) + pointOffSetY, dir2, dir2))
        addressPoint.image = UIImage(named: "ic_point_red")
        bottomView.addSubview(addressPoint)
        
        let line2 = UIView.init(frame: CGRectMake(dir2, CGRectGetMaxY(addressLabel.frame) + bottomView.frame.size.height * 0.05, bkgViewWidth - dir2 * 2, 0.5))
        line2.backgroundColor = UIColor.lightGrayColor()
        bottomView.addSubview(line2)
        
        tipsLabel = UILabel.init(frame: CGRectMake(dir2, CGRectGetMaxY(line2.frame), bkgViewWidth * 0.5, bottomView.frame.size.height * 0.3))
        tipsLabel.textColor = UIColor.init(red: 244/255.0, green: 187/255.0, blue: 35/255.0, alpha: 1.0)
        tipsLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        tipsLabel.text = "正在寻找安装商"
        bottomView.addSubview(tipsLabel)
        
        viewMoreButton = UIButton.init(type: UIButtonType.Custom)
        viewMoreButton.frame = CGRectMake(CGRectGetMaxX(line2.frame) - bkgViewWidth * 0.2, CGRectGetMaxY(line2.frame) + tipsLabel.frame.size.height * 0.2, bkgViewWidth * 0.2, tipsLabel.frame.size.height * 0.6)
        viewMoreButton.setTitle("查看更多", forState: UIControlState.Normal)
        viewMoreButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        viewMoreButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        viewMoreButton.layer.borderWidth = 0.5
        viewMoreButton.layer.borderColor = UIColor.blackColor().CGColor
        bottomView.addSubview(viewMoreButton)
    }
    
    static func cellHeight() -> CGFloat {
        var height = PhoneUtils.kScreenHeight
        if (height < 568) {
            height = 568
        }
        return height / 3
    }
    
}

