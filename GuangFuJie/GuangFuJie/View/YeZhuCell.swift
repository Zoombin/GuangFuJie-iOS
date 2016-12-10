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
    var avatarImageView : UIImageView!
    var nameLabel : UILabel!
    var statusLabel : UILabel!
    
    var descriptionLabel : TopLeftLabel!
    var addressLabel : TopLeftLabel!
    
    var tipsLabel : UILabel!
    var viewMoreButton : UIButton!
    
    func initCell() {
        if (viewCreated) {
            return
        }
        viewCreated = true
        
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
        
        statusLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(avatarImageView.frame) + dir2, CGRectGetMaxY(nameLabel.frame), 100, avatarImageView.frame.size.height / 2))
        statusLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        statusLabel.text = "已认证"
        topView.addSubview(statusLabel)
        
        let line1 = UIView.init(frame: CGRectMake(dir2, topView.frame.size.height, bkgViewWidth - dir2 * 2, 0.5))
        line1.backgroundColor = UIColor.lightGrayColor()
        bkgView.addSubview(line1)
        
        let bottomView = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(topView.frame), bkgViewWidth, bkgViewHeight * 2 / 3))
        bkgView.addSubview(bottomView)
        
        descriptionLabel = TopLeftLabel.init(frame: CGRectMake(dir2 * 3, bottomView.frame.size.height * 0.05, bkgViewWidth - dir2 * 5, bottomView.frame.size.height * 0.45))
        descriptionLabel.text = "这里显示的是描述"
        descriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        descriptionLabel.numberOfLines = 3
        descriptionLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        bottomView.addSubview(descriptionLabel)
        
        let desPoint = UIImageView.init(frame: CGRectMake(dir2, CGRectGetMinY(descriptionLabel.frame) + 2, dir2, dir2))
        desPoint.image = UIImage(named: "ic_yellow_point")
        bottomView.addSubview(desPoint)
        
        addressLabel = TopLeftLabel.init(frame: CGRectMake(dir2 * 3, CGRectGetMaxY(descriptionLabel.frame), bkgViewWidth - dir2 * 5, bottomView.frame.size.height * 0.20))
        addressLabel.text = "这里显示的地址"
        addressLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        bottomView.addSubview(addressLabel)
        
        let addressPoint = UIImageView.init(frame: CGRectMake(dir2, CGRectGetMinY(addressLabel.frame) + 2, dir2, dir2))
        addressPoint.image = UIImage(named: "ic_green_point")
        bottomView.addSubview(addressPoint)
        
        let line2 = UIView.init(frame: CGRectMake(dir2, CGRectGetMaxY(addressLabel.frame), bkgViewWidth - dir2 * 2, 0.5))
        line2.backgroundColor = UIColor.lightGrayColor()
        bottomView.addSubview(line2)
        
        tipsLabel = UILabel.init(frame: CGRectMake(dir2, CGRectGetMaxY(line2.frame), bkgViewWidth * 0.5, bottomView.frame.size.height * 0.3))
        tipsLabel.textColor = UIColor.init(red: 244/255.0, green: 187/255.0, blue: 35/255.0, alpha: 1.0)
        tipsLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        tipsLabel.text = "正在寻找屋顶"
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
