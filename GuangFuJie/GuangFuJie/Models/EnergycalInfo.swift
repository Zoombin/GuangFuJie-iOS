//
//  EnergycalInfo.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/8/3.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class EnergycalInfo: NSObject {
   var build_size: NSNumber? //装机容量
   var build_price: NSNumber? //装机费用
   var electric_firstyear_hours: NSNumber? //首年利用小时数
   var electric_firstyear_dayaverage: NSNumber? //首年日发电量
   var electric_firstyear_total: NSNumber? //首年总发电量
   var electric_25: NSNumber? //25年总发电量
   var reduce_c: NSNumber? //节约煤
   var reduce_co2: NSNumber? //减少二氧化碳
   var reduce_so2: NSNumber? //减少二氧化硫
   var reduce_nox: NSNumber? //减少氮化物排放
   var reduce_smoke: NSNumber? //减少烟雾排行
   var sample_angle: NSNumber? //参考倾角
   var wOfPrice: NSNumber? //每瓦投资金额
   var firstYearKwElectric: NSNumber? //首年每千瓦发电量
}
