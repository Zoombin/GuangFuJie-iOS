//
//  Safeself.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/8.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class SafeCell: UITableViewCell {
    var viewCreated = false
    var nameLabel : UILabel!
    var phoneLabel : UILabel!
    var idLabel : UILabel!
    var priceLabel : UILabel!
    var tipsLabel : UILabel!
    
    var safeTypeLabel : UILabel!
    var yearsSizeLabel : UILabel!
    var rangeLabel : UILabel!
    var baoeLabel : UILabel!
    var addressLabel : UILabel!
    
    var buyTimeLabel : UILabel!
    var viewMoreButton : UIButton!
    var payButton : UIButton!
    
    func initCell() {
        if (viewCreated) {
            return
        }
        viewCreated = true
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.contentView.backgroundColor = Colors.bkgColor
        
        let dir : CGFloat = PhoneUtils.kScreenWidth / 40
        let bkgViewWidth = PhoneUtils.kScreenWidth - dir * 2
        let bkgViewHeight = SafeCell.cellHeight() - dir
        let bkgView = UIView.init(frame: CGRectMake(dir, 0, bkgViewWidth, bkgViewHeight))
        bkgView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(bkgView)
        
        let topView = UIView.init(frame: CGRectMake(0, 0, bkgViewWidth, bkgViewHeight / 3))
        bkgView.addSubview(topView)
        
        let dir2 : CGFloat = PhoneUtils.kScreenWidth / 36
        
        let labelHeight1 = (topView.frame.size.height - dir2 * 2) / 3
        let labelWidth1 = topView.frame.size.width * 0.6
        let labelWidth2 = topView.frame.size.width * 0.4
        
        let line1 = UIView.init(frame: CGRectMake(dir2, topView.frame.size.height, bkgViewWidth - dir2 * 2, 0.5))
        line1.backgroundColor = UIColor.lightGrayColor()
        bkgView.addSubview(line1)
        
        nameLabel = UILabel.init(frame: CGRectMake(dir2, dir2, labelWidth1, labelHeight1))
        nameLabel.font = UIFont.systemFontOfSize(Dimens.fontSizelarge2)
        nameLabel.text = "123123123"
        topView.addSubview(nameLabel)
        
        phoneLabel = UILabel.init(frame: CGRectMake(dir2, CGRectGetMaxY(nameLabel.frame), labelWidth1, labelHeight1))
        phoneLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        phoneLabel.text = "123123123"
        phoneLabel.textColor = UIColor.lightGrayColor()
        topView.addSubview(phoneLabel)
        
        idLabel = UILabel.init(frame: CGRectMake(dir2, CGRectGetMaxY(phoneLabel.frame), labelWidth1, labelHeight1))
        idLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        idLabel.text = "123123123"
        idLabel.textColor = UIColor.lightGrayColor()
        topView.addSubview(idLabel)
        
        priceLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(nameLabel.frame) - dir2, dir2, labelWidth2 - dir2, labelHeight1))
        priceLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        priceLabel.text = "123123123"
        priceLabel.textColor = UIColor.blackColor()
        priceLabel.textAlignment = NSTextAlignment.Right
        topView.addSubview(priceLabel)
    
        tipsLabel = UILabel.init(frame: CGRectMake(CGRectGetMinX(priceLabel.frame), CGRectGetMaxY(priceLabel.frame), labelWidth2 - dir2, labelHeight1))
        tipsLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        tipsLabel.text = "已投保"
        tipsLabel.textColor = Colors.installColor
        tipsLabel.textAlignment = NSTextAlignment.Right
        topView.addSubview(tipsLabel)
        
        let bottomView = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(topView.frame), bkgViewWidth, bkgViewHeight * 2 / 3))
        bkgView.addSubview(bottomView)
        
        let pointOffSetY = (bottomView.frame.size.height * 0.15 - dir2) / 2
        
        safeTypeLabel = UILabel.init(frame: CGRectMake(dir2 * 3, bottomView.frame.size.height * 0.05, bkgViewWidth - dir2 * 5, bottomView.frame.size.height * 0.15))
        safeTypeLabel.text = "这里显示的是描述"
        safeTypeLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        bottomView.addSubview(safeTypeLabel)
        
        let typePoint = UIImageView.init(frame: CGRectMake(dir2, CGRectGetMinY(safeTypeLabel.frame) + pointOffSetY, dir2, dir2))
        typePoint.image = UIImage(named: "ic_point_blue")
        bottomView.addSubview(typePoint)
        
        yearsSizeLabel = UILabel.init(frame: CGRectMake(dir2 * 3, CGRectGetMaxY(safeTypeLabel.frame), (bkgViewWidth - dir2 * 5) / 3.5, bottomView.frame.size.height * 0.15))
        yearsSizeLabel.text = "这里显示的是描述"
        yearsSizeLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        bottomView.addSubview(yearsSizeLabel)
        
        rangeLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(yearsSizeLabel.frame), CGRectGetMaxY(safeTypeLabel.frame), (bkgViewWidth - dir2 * 5) / 2, bottomView.frame.size.height * 0.15))
        rangeLabel.text = "这里显示的是描述"
        rangeLabel.textColor = UIColor.lightGrayColor()
        rangeLabel.textAlignment = NSTextAlignment.Left
        rangeLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall2)
        bottomView.addSubview(rangeLabel)
        
        let sizePoint = UIImageView.init(frame: CGRectMake(dir2, CGRectGetMinY(yearsSizeLabel.frame) + pointOffSetY, dir2, dir2))
        sizePoint.image = UIImage(named: "ic_yellow_point")
        bottomView.addSubview(sizePoint)
        
        baoeLabel = UILabel.init(frame: CGRectMake(dir2 * 3, CGRectGetMaxY(yearsSizeLabel.frame), bkgViewWidth - dir2 * 5, bottomView.frame.size.height * 0.15))
        baoeLabel.text = "这里显示的是描述"
        baoeLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        bottomView.addSubview(baoeLabel)
        
        let pricePoint = UIImageView.init(frame: CGRectMake(dir2, CGRectGetMinY(baoeLabel.frame) + pointOffSetY, dir2, dir2))
        pricePoint.image = UIImage(named: "ic_green_point")
        bottomView.addSubview(pricePoint)
        
        addressLabel = UILabel.init(frame: CGRectMake(dir2 * 3, CGRectGetMaxY(baoeLabel.frame), bkgViewWidth - dir2 * 5, bottomView.frame.size.height * 0.15))
        addressLabel.text = "这里显示的是描述"
        addressLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        bottomView.addSubview(addressLabel)
        
        let addressPoint = UIImageView.init(frame: CGRectMake(dir2, CGRectGetMinY(addressLabel.frame) + pointOffSetY, dir2, dir2))
        addressPoint.image = UIImage(named: "ic_point_red")
        bottomView.addSubview(addressPoint)

        let line2 = UIView.init(frame: CGRectMake(dir2, CGRectGetMaxY(addressLabel.frame) + bottomView.frame.size.height * 0.05, bkgViewWidth - dir2 * 2, 0.5))
        line2.backgroundColor = UIColor.lightGrayColor()
        bottomView.addSubview(line2)

        buyTimeLabel = UILabel.init(frame: CGRectMake(dir2, CGRectGetMaxY(line2.frame), bkgViewWidth * 0.5, bottomView.frame.size.height * 0.3))
        buyTimeLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        buyTimeLabel.textColor = UIColor.blackColor()
        buyTimeLabel.text = "投保日期: 2016-1-1"
        bottomView.addSubview(buyTimeLabel)
        
        viewMoreButton = UIButton.init(type: UIButtonType.Custom)
        viewMoreButton.frame = CGRectMake(CGRectGetMaxX(line2.frame) - bkgViewWidth * 0.2, CGRectGetMaxY(line2.frame) + buyTimeLabel.frame.size.height * 0.2, bkgViewWidth * 0.2, buyTimeLabel.frame.size.height * 0.6)
        viewMoreButton.setTitle("查看更多", forState: UIControlState.Normal)
        viewMoreButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        viewMoreButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        viewMoreButton.layer.borderWidth = 0.5
        viewMoreButton.layer.borderColor = UIColor.blackColor().CGColor
        bottomView.addSubview(viewMoreButton)
        
        payButton = UIButton.init(type: UIButtonType.Custom)
        payButton.frame = CGRectMake(CGRectGetMinX(viewMoreButton.frame) - dir2 - bkgViewWidth * 0.2, CGRectGetMaxY(line2.frame) + buyTimeLabel.frame.size.height * 0.2, bkgViewWidth * 0.2, buyTimeLabel.frame.size.height * 0.6)
        payButton.backgroundColor = Colors.installColor
        payButton.setTitle("立即付款", forState: UIControlState.Normal)
        payButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        payButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        bottomView.addSubview(payButton)
    }
    
    func setData(info : InsuranceInfo, isSelf : Bool) {
        var name = ""
        if (info.beneficiary_name != nil) {
            name = name + info.beneficiary_name! + " "
        }
        name = name + "已购买保险"
        self.nameLabel.text = isSelf ? "我购买的保险" : name
        
        var phone = ""
        if (info.phone != nil) {
            phone = info.phone!
        }
        self.phoneLabel.text = isSelf ? "" : phone
        
        var idCard = "身份信息："
        if (info.id_no != nil) {
            idCard = idCard + info.id_no!
        }
        self.idLabel.text = isSelf ? "" : idCard
        
        var type = ""
        var baoeValue = "保额："
        if (info.size != nil) {
            type = "光伏街发电系统" + info.size! + "版"
            
            let size = NSString.init(string: info.size!)
            size.stringByReplacingOccurrencesOfString("KW", withString: "")
            let sizeFloat : CGFloat = CGFloat(size.floatValue)
            
            let baoe1 : CGFloat = sizeFloat * 0.7
            let baoe2 : CGFloat = sizeFloat * 0.7
            let baoe3 : CGFloat = 2.0
            let total : CGFloat = baoe1 + baoe2 + baoe3
            let baoe = String(format: "%.1f万/年", total)
            baoeValue = baoeValue  + baoe
        }
        self.baoeLabel.text = baoeValue
        self.safeTypeLabel.text = type
        
        var time = "投保年限："
        if (info.years != nil) {
            time = time + String(info.years!) + "年"
        }
        self.yearsSizeLabel.text = time
        
        var range = ""
        if (info.insured_from != nil && info.insured_end != nil) {
            range = info.insured_from! + "至" + info.insured_end!
            self.buyTimeLabel.text = "投保日期：" + info.insured_from!
        }
        self.rangeLabel.text = range
        
        var price = ""
        if (info.insured_price != nil) {
            price = "￥" + String(info.insured_price!)
        }
        self.priceLabel.text = price
        
        var location = ""
        if (info.station_address != nil) {
            location = info.station_address!
        }
        self.addressLabel.text = location
        
        self.payButton.hidden = true
        if (isSelf) {
            if (info.order_status!.integerValue == 2) {
                self.tipsLabel.text = "已成功投保"
            } else if (info.order_status!.integerValue == 1){
                self.tipsLabel.text = "已投保"
            } else {
                self.tipsLabel.text = "未付款"
                self.payButton.hidden = false
            }
        }
    }
    
    static func cellHeight() -> CGFloat {
        var height = PhoneUtils.kScreenHeight
        if (height < 568) {
            height = 568
        }
        return height / 3
    }

}
