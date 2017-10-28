//
//  HInstallerCell.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/10/28.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

//这是业主
class HInstallerCell: UITableViewCell {

    var viewCreated = false
    var avatarImageView : UIImageView!
    var nameLabel : UILabel!
    var timeLabel : UILabel!
    var roofTypeLabel : UILabel!
    var roofSizeLabel : UILabel!
    var roofPriceLabel : UILabel!
    var addressLabel : UILabel!
    
    var viewMoreButton : UIButton!
    
    func initCell() {
        if (viewCreated) {
            return
        }
        viewCreated = true
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.contentView.backgroundColor = UIColor.white
        
        let dir : CGFloat = PhoneUtils.kScreenWidth / 40
        let bkgViewWidth = PhoneUtils.kScreenWidth - dir * 2
        let bkgViewHeight = HInstallerCell.cellHeight() - dir
        let bkgView = UIView.init(frame: CGRect(x: dir, y: dir, width: bkgViewWidth, height: bkgViewHeight))
        bkgView.backgroundColor = UIColor.white
        self.contentView.addSubview(bkgView)
        
        let topView = UIView.init(frame: CGRect(x: 0, y: 0, width: bkgViewWidth, height: bkgViewHeight * 0.4))
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
        
        timeLabel = UILabel.init(frame: CGRect(x: avatarImageView.frame.maxX + dir2, y: nameLabel.frame.maxY, width: 200, height: avatarImageView.frame.size.height / 2))
        timeLabel.textColor = UIColor.lightGray
        timeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        timeLabel.text = "2015-12-12 12:12"
        topView.addSubview(timeLabel)
        
        let times = PhoneUtils.kScreenWidth / 375
        
        let line1 = UIView.init(frame: CGRect(x: dir2, y: topView.frame.size.height, width: bkgViewWidth - dir2 * 2, height: 0.5))
        line1.backgroundColor = UIColor.lightGray
        bkgView.addSubview(line1)
        
        viewMoreButton = UIButton.init(type: UIButtonType.custom)
        viewMoreButton.frame = CGRect(x: line1.frame.maxX - 62 * times, y: 10 * times, width: 62 * times, height: 27 * times)
        viewMoreButton.setTitle("查看更多", for: UIControlState.normal)
        viewMoreButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        viewMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        viewMoreButton.layer.borderWidth = 0.5
        viewMoreButton.layer.borderColor = UIColor.lightGray.cgColor
        topView.addSubview(viewMoreButton)
        
        let bottomView = UIView.init(frame: CGRect(x: 0, y: (topView.frame).maxY, width: bkgViewWidth, height: bkgViewHeight * 0.6))
        bkgView.addSubview(bottomView)
        
        let pointOffSetY = (bottomView.frame.size.height * 0.25 - dir2) / 2
        
        roofTypeLabel = UILabel.init(frame: CGRect(x: dir2 * 3, y: bottomView.frame.size.height * 0.05, width: bkgViewWidth - dir2 * 5, height: bottomView.frame.size.height * 0.25))
        roofTypeLabel.text = "这里显示的是描述"
        roofTypeLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        roofTypeLabel.numberOfLines = 3
        roofTypeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        bottomView.addSubview(roofTypeLabel)
        
        let typePoint = UIImageView.init(frame: CGRect(x: dir2, y: (roofTypeLabel.frame).minY + pointOffSetY, width: dir2, height: dir2))
        typePoint.image = UIImage(named: "ic_point_blue")
        bottomView.addSubview(typePoint)
        
        roofSizeLabel = UILabel.init(frame: CGRect(x: dir2 * 3, y: (roofTypeLabel.frame).maxY, width: bkgViewWidth - dir2 * 5, height: bottomView.frame.size.height * 0.25))
        roofSizeLabel.text = "这里显示的是描述"
        roofSizeLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        roofSizeLabel.numberOfLines = 3
        roofSizeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        bottomView.addSubview(roofSizeLabel)
        
        let sizePoint = UIImageView.init(frame: CGRect(x: dir2, y: (roofSizeLabel.frame).minY + pointOffSetY, width: dir2, height: dir2))
        sizePoint.image = UIImage(named: "ic_yellow_point")
        bottomView.addSubview(sizePoint)
        
        roofPriceLabel = UILabel.init(frame: CGRect(x: dir2 * 3, y: (roofSizeLabel.frame).maxY, width: bkgViewWidth - dir2 * 5, height: bottomView.frame.size.height * 0.25))
        roofPriceLabel.text = "这里显示的是描述"
        roofPriceLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        roofPriceLabel.numberOfLines = 3
        roofPriceLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        bottomView.addSubview(roofPriceLabel)
        
        let pricePoint = UIImageView.init(frame: CGRect(x: dir2, y: (roofPriceLabel.frame).minY + pointOffSetY, width: dir2, height: dir2))
        pricePoint.image = UIImage(named: "ic_green_point")
        bottomView.addSubview(pricePoint)
        
        addressLabel = UILabel.init(frame: CGRect(x: dir2 * 3, y: (roofPriceLabel.frame).maxY, width: bkgViewWidth - dir2 * 5, height: bottomView.frame.size.height * 0.25))
        addressLabel.text = "这里显示的是描述"
        addressLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        addressLabel.numberOfLines = 3
        addressLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        bottomView.addSubview(addressLabel)
        
        let addressPoint = UIImageView.init(frame: CGRect(x: dir2, y: (addressLabel.frame).minY + pointOffSetY, width: dir2, height: dir2))
        addressPoint.image = UIImage(named: "ic_point_red")
        bottomView.addSubview(addressPoint)
    }
    
    func setData(userInfo: RoofInfo) {
        if ((userInfo.fullname) != nil) {
            self.nameLabel.text = userInfo.fullname! + " " + "屋顶出租"
        }
        if ((userInfo.created_date) != nil) {
            self.timeLabel.text = userInfo.created_date!
        }
        if (userInfo.area_image != nil) {
            self.avatarImageView.setImageWith(URL.init(string: userInfo.area_image!)! as URL)
        } else {
            self.avatarImageView.image = UIImage(named: "ic_avatar_yezhu")
        }
        var type = "屋顶类型:"
        var size = "屋顶面积:"
        var price = "屋顶租金:"
        if (userInfo.area_size != nil) {
            size = size + String(format: "%.2f", userInfo.area_size!.floatValue) + "㎡"
        }
        if (userInfo.type != nil) {
            type = type + (userInfo.type == 2 ? "斜面" : "平面")
        }
        if (userInfo.price != nil) {
            price = price + String(describing: userInfo.price!) + "元/㎡"
        }
        self.roofTypeLabel.text = type
        self.roofSizeLabel.text = size
        self.roofPriceLabel.text = price
        
        var location = ""
        if ((userInfo.province_label) != nil) {
            location = location + userInfo.province_label!
        }
        if ((userInfo.city_label) != nil) {
            location = location + userInfo.city_label!
        }
        if ((userInfo.address) != nil) {
            location = location + userInfo.address!
        }
        self.addressLabel.text = location
    }
    
    static func cellHeight() -> CGFloat {
        var height = PhoneUtils.kScreenHeight
        if (height < 568) {
            height = 568
        }
        return height / 4
    }

}
