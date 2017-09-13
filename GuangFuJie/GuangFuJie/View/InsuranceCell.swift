//
//  InsuranceCell.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/9/13.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class InsuranceCell: UITableViewCell {
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var phoneLabel : UILabel!
    @IBOutlet var idLabel : UILabel!
    @IBOutlet var priceLabel : UILabel!
    @IBOutlet var tipsLabel : UILabel!
    
    @IBOutlet var safeTypeLabel : UILabel!
    @IBOutlet var yearsSizeLabel : UILabel!
    @IBOutlet var rangeLabel : UILabel!
    @IBOutlet var baoeLabel : UILabel!
    //    var addressLabel : UILabel!
    
    @IBOutlet var buyTimeLabel : UILabel!
    @IBOutlet var viewMoreButton : UIButton!
    @IBOutlet var payButton : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
            type = StringUtils.getString(info.label)
            baoeValue = baoeValue  + StringUtils.getString(info.baoe) + "万/年"
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
}
