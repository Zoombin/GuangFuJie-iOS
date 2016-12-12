//
//  InstallInfo.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/8/19.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class InstallInfo: NSObject {
    var user_id : NSNumber?     // 用户id
    var user_name : String?  // 登录名
    var fullname : String?    // 姓名
    var device_id : NSNumber?   // 设备id
    var repair_status : NSNumber?   // 维修的状态  0: 没有申请 1:已申请
    var is_installer : NSNumber?    // 安装商状态: 0: 普通用户 1:已申请 2:已审核
    var license_url : String?     // 安装商的营业执照图片url
    var province_id : NSNumber?    // 安装商 省份id
    var province_label : String?  // 安装商 省份label
    var city_label : String?     // 安装商 城市label
    var address : String?        // 安装商 详细地址
    var contact_info : String?   // 安装商 联系方式
    var company_name : String?   // 安装商 公司名称
    var company_size : String?   // 安装商 公司规模
    var company_intro : String?   // 安装商 公司简介
    var created_date  : String?  // 用户创建时间
    var installer_date : String? // 申请成为安装商的时间
    var logo : String?
    
}
