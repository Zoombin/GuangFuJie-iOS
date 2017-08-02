//
//  FranchiseeInfo.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/8/2.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class FranchiseeInfo: NSObject {
    var id: NSNumber?
    var user_id: NSNumber?
    var project: String?
    var business_url: String? // 营业执照
    var electrical_url: String? // 承装电力设施许可证图片地址
    var license_url: String? // 建筑业企业资质证书url地址
    var company_name: String?
    var company_size: String? // 公司规模 INT
    var company_desc: String?
    var address_detail: String? // 详细地址
    var linkman: String? //联系人
    var phone: String? // 联系方式
    var province_id: NSNumber?
    var city_id: NSNumber?
    var is_pass: NSNumber? // 是否通过审核 0 没有 1 有
    var sort_order: NSNumber? // 优先级
    var created_date: String?
    var update_date: String?
    
//    var user_id: NSNumber?
//    var project: String?
    var identity: NSNumber? // 0 普通用户 1 安装商 2 加盟商 3 地推 4 业主
    var user_name: String?
    var fullname: String?
//    var phone: String?

}
