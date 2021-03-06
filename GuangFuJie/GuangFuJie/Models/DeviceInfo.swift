//
//  DeviceInfo.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/8/2.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class DeviceInfo: NSObject {

    var id : NSNumber?
    var device_id : NSNumber?
    var energy_day : NSNumber?
    var energy_all : NSNumber?
    var device_power : NSNumber?
    var runtime : NSNumber?
    var errorcode1 : String?
    var errorcode2 : String?
    var createdate : String?
    var updatedate : String?
    var status : NSNumber?
    
    var money_day : NSNumber?    //日收益
    var coal_day : NSNumber?        //日减排煤
    var plant_day : NSNumber?       // 日种植
    var money_all : NSNumber?     //总收益
    var coal_all : NSNumber?        //总减排煤
    var plant_all : NSNumber?     // 总种植
    
//    id
//    device_id       // 设备id
//    energy_day      // 日发电量
//    energy_all      // 总发电量
//    device_power    // 设备的功率
//    runtime         // 运行时间（小时）
//    errorcode1
//    errorcode2
//    createdate      // 创建时间
//    updatedate
}
