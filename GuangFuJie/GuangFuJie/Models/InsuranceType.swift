//
//  InsuranceType.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/10.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class InsuranceType: NSObject {
   var id: NSNumber?          //保险类型id
   var company_id: NSNumber?  //所属保险公司id
   var size: String?        //电站大小
   var price: NSNumber?       //价格
   var label: String?       //电站大小 描述
   var protect_device: String?
   var price_device: String?
   var protect_steal: String?
   var price_steal: String?
   var price_third_two: String?
   var price_third_five: String?
   var price_third_ten: String?
   var protect_third_two: String?
   var protect_third_five: String?
   var protect_third_ten: String?
   var saleTypes: NSArray?
}
