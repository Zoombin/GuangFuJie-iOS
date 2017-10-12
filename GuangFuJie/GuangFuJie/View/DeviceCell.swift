//
//  DeviceCell.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/11.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class DeviceCell: UITableViewCell {
    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var snButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.statusButton.isUserInteractionEnabled = false
        self.snButton.isUserInteractionEnabled = false
    }
    
    func setData(_ device: DeviceListInfo) {
        var imageName = ""
        if (device.device_type?.int32Value == 0) {
            imageName = "ic_devitem_yst"
        } else if (device.device_type?.int32Value == 1) {
            imageName = "ic_devitem_gdw"
        } else if (device.device_type?.int32Value == 2) {
            imageName = "ic_devitem_grwt"
        } else if (device.device_type?.int32Value == 3) {
            imageName = "ic_devitem_khkj"
        }
        self.deviceImageView.image = UIImage(named: imageName)
        if (device.status?.int32Value == 1) {
            self.statusButton.isSelected = false
            self.statusButton.isEnabled = true
        } else if (device.status?.int32Value == 2) {
            self.statusButton.isSelected = false
            self.statusButton.isEnabled = false
        } else if (device.status?.int32Value == 3) {
            self.statusButton.isSelected = true
            self.statusButton.isEnabled = true
        }
        
        self.powerLabel.text = String(format: "%.2fkw", YCStringUtils.getNumber(device.energy_all).floatValue)
        
        let deviceid = YCStringUtils.getString(device.device_id)
        self.snButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.snButton.setTitle(deviceid, for: UIControlState.normal)
    }
    
    static func getNidName() -> String {
        if (PhoneUtils.kScreenWidth == 320) {
            return "DeviceCell"
        } else if (PhoneUtils.kScreenWidth == 375) {
            return "DeviceCell6"
        } else {
            return "DeviceCellPlus"
        }
    }
    
    static func cellHeight() -> CGFloat {
        if (PhoneUtils.kScreenWidth == 320) {
            return 75
        } else if (PhoneUtils.kScreenWidth == 375) {
            return 85
        } else {
            return 90
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
