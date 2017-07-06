//
//  DeviceListInfo.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/11.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class DeviceListInfo: NSObject {
   var device_id: String?
   var device_type: NSNumber?  //设备类型(0:易事特  1:固德威  2:古瑞瓦特 3:开合山亿）
   var energy_all: NSNumber?  //发电量
   var status: NSNumber?   //1:在线，正常运行  2 在线，故障     3：离线
}
