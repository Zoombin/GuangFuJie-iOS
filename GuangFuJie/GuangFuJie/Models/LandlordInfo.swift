//
//  LandlordInfo.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/8/3.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class LandlordInfo: NSObject {
    var user_id: NSNumber?
    var project: String?
    var identity: NSNumber? // 0 普通用户 1 安装商 2 加盟商 3 地推 4 业主
    var user_name: String?
    var fullname: String?
    var phone: String?
}
