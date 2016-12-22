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
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.contentView.backgroundColor = Colors.bkgColor
        
        let dir : CGFloat = PhoneUtils.kScreenWidth / 40
        let bkgViewWidth = PhoneUtils.kScreenWidth - dir * 2
        let bkgViewHeight = YeZhuCell.cellHeight() - dir
        let bkgView = UIView.init(frame: CGRect(x: dir, y: 0, width: bkgViewWidth, height: bkgViewHeight))
        bkgView.backgroundColor = UIColor.white
        self.contentView.addSubview(bkgView)
        
        let topView = UIView.init(frame: CGRect(x: 0, y: 0, width: bkgViewWidth, height: bkgViewHeight / 3))
        bkgView.addSubview(topView)
        
        let dir2 : CGFloat = PhoneUtils.kScreenWidth / 36
        avatarImageView = UIImageView.init(frame: CGRect(x: dir2, y: dir2, width: bkgViewWidth / 4.5, height: topView.frame.size.height - dir2 * 2))
        avatarImageView.image = UIImage(named: "ic_avatar_yezhu")
        topView.addSubview(avatarImageView)
        
        let labelWidth = bkgViewWidth - avatarImageView.frame.size.width - dir2 * 3
        nameLabel = UILabel.init(frame: CGRect(x: (avatarImageView.frame).maxX + dir2, y: dir2, width: labelWidth, height: avatarImageView.frame.size.height / 2))
        nameLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        nameLabel.text = "这里是公司名称"
        topView.addSubview(nameLabel)
        
        statusLabel = UILabel.init(frame: CGRect(x: avatarImageView.frame.maxX + dir2, y: nameLabel.frame.maxY, width: 100, height: avatarImageView.frame.size.height / 2))
        statusLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        statusLabel.text = "已认证"
        topView.addSubview(statusLabel)
        
        let line1 = UIView.init(frame: CGRect(x: dir2, y: topView.frame.size.height, width: bkgViewWidth - dir2 * 2, height: 0.5))
        line1.backgroundColor = UIColor.lightGray
        bkgView.addSubview(line1)
        
        let bottomView = UIView.init(frame: CGRect(x: 0, y: (topView.frame).maxY, width: bkgViewWidth, height: bkgViewHeight * 2 / 3))
        bkgView.addSubview(bottomView)
        
        descriptionLabel = TopLeftLabel.init(frame: CGRect(x: dir2 * 3, y: bottomView.frame.size.height * 0.05, width: bkgViewWidth - dir2 * 5, height: bottomView.frame.size.height * 0.45))
        descriptionLabel.text = "这里显示的是描述"
        descriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        descriptionLabel.numberOfLines = 3
        descriptionLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        bottomView.addSubview(descriptionLabel)
        
        let desPoint = UIImageView.init(frame: CGRect(x: dir2, y: descriptionLabel.frame.minY + 2, width: dir2, height: dir2))
        desPoint.image = UIImage(named: "ic_yellow_point")
        bottomView.addSubview(desPoint)
        
        addressLabel = TopLeftLabel.init(frame: CGRect(x: dir2 * 3, y: (descriptionLabel.frame).maxY, width: bkgViewWidth - dir2 * 5, height: bottomView.frame.size.height * 0.20))
        addressLabel.text = "这里显示的地址"
        addressLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        bottomView.addSubview(addressLabel)
        
        let addressPoint = UIImageView.init(frame: CGRect(x: dir2, y: addressLabel.frame.minY + 2, width: dir2, height: dir2))
        addressPoint.image = UIImage(named: "ic_green_point")
        bottomView.addSubview(addressPoint)
        
        let line2 = UIView.init(frame: CGRect(x: dir2, y: (addressLabel.frame).maxY, width: bkgViewWidth - dir2 * 2, height: 0.5))
        line2.backgroundColor = UIColor.lightGray
        bottomView.addSubview(line2)
        
        tipsLabel = UILabel.init(frame: CGRect(x: dir2, y: (line2.frame).maxY, width: bkgViewWidth * 0.5, height: bottomView.frame.size.height * 0.3))
        tipsLabel.textColor = UIColor.init(red: 244/255.0, green: 187/255.0, blue: 35/255.0, alpha: 1.0)
        tipsLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        tipsLabel.text = "正在寻找屋顶"
        bottomView.addSubview(tipsLabel)
        
        viewMoreButton = UIButton.init(type: UIButtonType.custom)
        viewMoreButton.frame = CGRect(x: (line2.frame).maxX - bkgViewWidth * 0.2, y: (line2.frame).maxY + tipsLabel.frame.size.height * 0.2, width: bkgViewWidth * 0.2, height: tipsLabel.frame.size.height * 0.6)
        viewMoreButton.setTitle("查看更多", for: UIControlState.normal)
        viewMoreButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        viewMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        viewMoreButton.layer.borderWidth = 0.5
        viewMoreButton.layer.borderColor = UIColor.black.cgColor
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
