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
        bkgView.layer.cornerRadius = dir
        bkgView.layer.masksToBounds = true
        self.contentView.addSubview(bkgView)
        
        let topView = UIView.init(frame: CGRectMake(0, 0, bkgViewWidth, bkgViewHeight / 3))
        bkgView.addSubview(topView)
        
        let dir2 : CGFloat = PhoneUtils.kScreenWidth / 36
        avatarImageView = UIImageView.init(frame: CGRectMake(dir2, dir2, bkgViewWidth / 4, topView.frame.size.height - dir2 * 2))
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
        
        let desPoint = UIImageView.init(frame: CGRectMake(dir2, 0, dir2, dir2))
        desPoint.image = UIImage(named: "ic_yellow_point")
        bottomView.addSubview(desPoint)
        
        descriptionLabel = TopLeftLabel.init(frame: CGRectMake(dir2 * 2, 0, bkgViewWidth - dir2 * 3, bottomView.frame.size.height * 0.5))
        descriptionLabel.text = "这里显示的是描述"
        descriptionLabel.backgroundColor = UIColor.yellowColor()
        descriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        descriptionLabel.numberOfLines = 3
        descriptionLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        bottomView.addSubview(descriptionLabel)
        
        let addressPoint = UIImageView.init(frame: CGRectMake(dir2, CGRectGetMaxY(descriptionLabel.frame), dir2, dir2))
        addressPoint.image = UIImage(named: "ic_green_point")
        bottomView.addSubview(addressPoint)
        
        addressLabel = TopLeftLabel.init(frame: CGRectMake(dir2 * 2, CGRectGetMaxY(descriptionLabel.frame), bkgViewWidth - dir2 * 3, bottomView.frame.size.height * 0.25))
        addressLabel.text = "这里显示的地址"
        addressLabel.backgroundColor = UIColor.redColor()
        addressLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        bottomView.addSubview(addressLabel)
        
        let line2 = UIView.init(frame: CGRectMake(dir2, CGRectGetMaxY(addressLabel.frame), bkgViewWidth - dir2 * 2, 0.5))
        line2.backgroundColor = UIColor.lightGrayColor()
        bottomView.addSubview(line2)
    }
    
    static func cellHeight() -> CGFloat {
        var height = PhoneUtils.kScreenHeight
        if (height < 568) {
            height = 568
        }
        return height / 3
    }

}
