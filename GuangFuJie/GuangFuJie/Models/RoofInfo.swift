//
//  RoofInfo.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/8/19.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class RoofInfo: NSObject {
    var id : NSNumber?             // 屋顶资源id
    var user_id : NSNumber?        // 用户id
    var fullname : String?       // 发布人姓名
    var province_id : NSNumber?    // 省份id
    var province_label : String?  // 省份label
    var city_id : NSNumber?         // 城市id
    var city_label : String?      // 城市label
    var address : String?         // 详细地址
    var area_size : NSNumber?       // 屋顶面积
    var area_image : String?      // 屋顶图片url
    var type : NSNumber?           // 屋顶类型( 1:平面 2:斜面)
    var contact_time : String?   // 适合联系的时间
    var price : NSNumber?           // 预计出租的价格 int
    var status : NSNumber?         // 1:未处理 2:已接单 3:已完成
    var created_date : String?   // 发布的时间
    var is_expire : NSNumber?      // 是否过期 0:未过期  1:已过期
    var longitude : NSNumber?
    var latitude : NSNumber?
}
