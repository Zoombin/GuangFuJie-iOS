//
//  AfterSaleInfo.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/8/19.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class AfterSaleInfo: NSObject {
    var id : NSNumber?          // 售后的id
    var requirement : String? // 填写的售后需求
    var status : NSNumber?     // 状态  1:处理中 2:已完成
    var created_date : String?
}
