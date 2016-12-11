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
        self.statusButton.userInteractionEnabled = false
        self.snButton.userInteractionEnabled = false
    }
    
    func setData(device: DeviceListInfo) {
        var imageName = ""
        if (device.device_type?.integerValue == 0) {
            imageName = "ic_devitem_yst"
        } else if (device.device_type?.integerValue == 1) {
            imageName = "ic_devitem_gdw"
        } else if (device.device_type?.integerValue == 2) {
            imageName = "ic_devitem_grwt"
        } else if (device.device_type?.integerValue == 3) {
            imageName = "ic_devitem_khkj"
        }
        self.deviceImageView.image = UIImage(named: imageName)
        if (device.status?.integerValue == 1) {
            self.statusButton.selected = false
            self.statusButton.enabled = true
        } else if (device.status?.integerValue == 2) {
            self.statusButton.selected = false
            self.statusButton.enabled = false
        } else if (device.status?.integerValue == 3) {
            self.statusButton.selected = true
            self.statusButton.enabled = true
        }
        
        var energy_all = "0kw"
        if (device.energy_all != nil) {
            energy_all = device.energy_all! + "kw"
        }
        self.powerLabel.text = energy_all
        
        var deviceid = ""
        if (device.device_id != nil) {
            deviceid = device.device_id!
        }
        self.snButton.setTitle(deviceid, forState: UIControlState.Normal)
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

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
