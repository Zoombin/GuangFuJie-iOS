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
    //    var addressLabel : UILabel!
    
    var buyTimeLabel : UILabel!
    var viewMoreButton : UIButton!
    var payButton : UIButton!
    
    func initCell() {
        if (viewCreated) {
            return
        }
        viewCreated = true
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.contentView.backgroundColor = Colors.bkgColor
        
        let dir : CGFloat = PhoneUtils.kScreenWidth / 40
        let bkgViewWidth = PhoneUtils.kScreenWidth - dir * 2
        let bkgViewHeight = SafeCell.cellHeight() - dir
        let bkgView = UIView.init(frame: CGRect(x: dir, y: 0, width: bkgViewWidth, height: bkgViewHeight))
        bkgView.backgroundColor = UIColor.white
        self.contentView.addSubview(bkgView)
        
        let topView = UIView.init(frame: CGRect(x: 0, y: 0, width: bkgViewWidth, height: bkgViewHeight / 3))
        bkgView.addSubview(topView)
        
        let dir2 : CGFloat = PhoneUtils.kScreenWidth / 36
        
        let labelHeight1 = (topView.frame.size.height - dir2 * 2) / 3
        let labelWidth1 = topView.frame.size.width * 0.6
        let labelWidth2 = topView.frame.size.width * 0.4
        
        let line1 = UIView.init(frame: CGRect(x: dir2, y: topView.frame.size.height, width: bkgViewWidth - dir2 * 2, height: 0.5))
        line1.backgroundColor = UIColor.lightGray
        bkgView.addSubview(line1)
        
        nameLabel = UILabel.init(frame: CGRect(x: dir2, y: dir2, width: labelWidth1, height: labelHeight1))
        nameLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        nameLabel.text = "123123123"
        topView.addSubview(nameLabel)
        
        phoneLabel = UILabel.init(frame: CGRect(x: dir2, y: (nameLabel.frame).maxY, width: labelWidth1, height: labelHeight1))
        phoneLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        phoneLabel.text = "123123123"
        phoneLabel.textColor = UIColor.lightGray
        topView.addSubview(phoneLabel)
        
        idLabel = UILabel.init(frame: CGRect(x: dir2, y: (phoneLabel.frame).maxY, width: labelWidth1, height: labelHeight1))
        idLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        idLabel.text = "123123123"
        idLabel.textColor = UIColor.lightGray
        topView.addSubview(idLabel)
        
        priceLabel = UILabel.init(frame: CGRect(x: (nameLabel.frame).maxX - dir2, y: dir2, width: labelWidth2 - dir2, height: labelHeight1))
        priceLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        priceLabel.text = "123123123"
        priceLabel.textColor = UIColor.black
        priceLabel.textAlignment = NSTextAlignment.right
        topView.addSubview(priceLabel)
        
        tipsLabel = UILabel.init(frame: CGRect(x: (priceLabel.frame).minX, y: (priceLabel.frame).maxY, width: labelWidth2 - dir2, height: labelHeight1))
        tipsLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        tipsLabel.text = "已投保"
        tipsLabel.textColor = Colors.installColor
        tipsLabel.textAlignment = NSTextAlignment.right
        topView.addSubview(tipsLabel)
        
        let bottomView = UIView.init(frame: CGRect(x: 0, y: (topView.frame).maxY, width: bkgViewWidth, height: bkgViewHeight * 2 / 3))
        bkgView.addSubview(bottomView)
        
        let pointOffSetY = (bottomView.frame.size.height * 0.2 - dir2) / 2
        
        safeTypeLabel = UILabel.init(frame: CGRect(x: dir2 * 3, y: bottomView.frame.size.height * 0.05, width: bkgViewWidth - dir2 * 5, height: bottomView.frame.size.height * 0.2))
        safeTypeLabel.text = "这里显示的是描述"
        safeTypeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        bottomView.addSubview(safeTypeLabel)
        
        let typePoint = UIImageView.init(frame: CGRect(x: dir2, y: (safeTypeLabel.frame).minY + pointOffSetY, width: dir2, height: dir2))
        typePoint.image = UIImage(named: "ic_point_blue")
        bottomView.addSubview(typePoint)
        
        yearsSizeLabel = UILabel.init(frame: CGRect(x: dir2 * 3, y: (safeTypeLabel.frame).maxY, width: (bkgViewWidth - dir2 * 5) / 3.2, height: bottomView.frame.size.height * 0.2))
        yearsSizeLabel.text = "这里显示的是描述"
        yearsSizeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        bottomView.addSubview(yearsSizeLabel)
        
        rangeLabel = UILabel.init(frame: CGRect(x: (yearsSizeLabel.frame).maxX, y: (safeTypeLabel.frame).maxY, width: (bkgViewWidth - dir2 * 5) / 2, height: bottomView.frame.size.height * 0.2))
        rangeLabel.text = "这里显示的是描述"
        rangeLabel.textColor = UIColor.lightGray
        rangeLabel.textAlignment = NSTextAlignment.left
        rangeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall2)
        bottomView.addSubview(rangeLabel)
        
        let sizePoint = UIImageView.init(frame: CGRect(x: dir2, y: (yearsSizeLabel.frame).minY + pointOffSetY, width: dir2, height: dir2))
        sizePoint.image = UIImage(named: "ic_yellow_point")
        bottomView.addSubview(sizePoint)
        
        baoeLabel = UILabel.init(frame: CGRect(x: dir2 * 3, y: (yearsSizeLabel.frame).maxY, width: bkgViewWidth - dir2 * 5, height: bottomView.frame.size.height * 0.2))
        baoeLabel.text = "这里显示的是描述"
        baoeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        bottomView.addSubview(baoeLabel)
        
        let pricePoint = UIImageView.init(frame: CGRect(x: dir2, y: (baoeLabel.frame).minY + pointOffSetY, width: dir2, height: dir2))
        pricePoint.image = UIImage(named: "ic_green_point")
        bottomView.addSubview(pricePoint)
        
        let line2 = UIView.init(frame: CGRect(x: dir2, y: (baoeLabel.frame).maxY + bottomView.frame.size.height * 0.05, width: bkgViewWidth - dir2 * 2, height: 0.5))
        line2.backgroundColor = UIColor.lightGray
        bottomView.addSubview(line2)
        
        buyTimeLabel = UILabel.init(frame: CGRect(x: dir2, y: (line2.frame).maxY, width: bkgViewWidth * 0.5, height: bottomView.frame.size.height * 0.3))
        buyTimeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        buyTimeLabel.textColor = UIColor.black
        buyTimeLabel.text = "投保日期: 2016-1-1"
        bottomView.addSubview(buyTimeLabel)
        
        viewMoreButton = UIButton.init(type: UIButtonType.custom)
        viewMoreButton.frame = CGRect(x: (line2.frame).maxX - bkgViewWidth * 0.2, y: (line2.frame).maxY + buyTimeLabel.frame.size.height * 0.2, width: bkgViewWidth * 0.2, height: buyTimeLabel.frame.size.height * 0.6)
        viewMoreButton.setTitle("查看更多", for: UIControlState.normal)
        viewMoreButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        viewMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        viewMoreButton.layer.borderWidth = 0.5
        viewMoreButton.layer.borderColor = UIColor.black.cgColor
        bottomView.addSubview(viewMoreButton)
        
        payButton = UIButton.init(type: UIButtonType.custom)
        payButton.frame = CGRect(x: (viewMoreButton.frame).minX - dir2 - bkgViewWidth * 0.2, y: (line2.frame).maxY + buyTimeLabel.frame.size.height * 0.2, width: bkgViewWidth * 0.2, height: buyTimeLabel.frame.size.height * 0.6)
        payButton.backgroundColor = Colors.installColor
        payButton.setTitle("立即付款", for: UIControlState.normal)
        payButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        payButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        bottomView.addSubview(payButton)
    }
    
    func setData(_ info : InsuranceInfo, isSelf : Bool) {
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
            type = YCStringUtils.getString(info.label)
            baoeValue = baoeValue  + YCStringUtils.getString(info.baoe) + "万/年"
        }
        self.baoeLabel.text = baoeValue
        self.safeTypeLabel.text = type
        
        var time = "投保年限："
        if (info.years != nil) {
            time = time + String(describing: info.years!) + "年"
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
            price = "￥" + String(describing: info.insured_price!)
        }
        self.priceLabel.text = price
        
        //        var location = ""
        //        if (info.station_address != nil) {
        //            location = info.station_address!
        //        }
        //        self.addressLabel.text = location
        
        self.payButton.isHidden = true
        if (isSelf) {
            if (info.order_status!.int32Value == 2) {
                self.tipsLabel.text = "已成功投保"
            } else if (info.order_status!.int32Value == 1){
                self.tipsLabel.text = "已投保"
            } else {
                self.tipsLabel.text = "未付款"
                self.payButton.isHidden = false
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

