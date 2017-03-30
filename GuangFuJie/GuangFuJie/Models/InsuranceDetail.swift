//
//  InsuranceDetail.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/8.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class InsuranceDetail: NSObject {
    var id:  NSNumber?                  //保险id
    var user_id: NSNumber?              //用户id
    var insured_sn: String?             //保单号
    var insurance_company_id: NSNumber? //保险公司的id
    var type_id: NSNumber?              //保险类型id
    var size: String?                   //保险类型名称 如3KW
    var years: NSNumber?                //担保年数
    var price: NSNumber?                //保险的价格
    var beneficiary_name: String?       //受益人姓名
    var beneficiary_phone: String?      //受益人电话
    var beneficiary_id_no: String?      //受益人身份证
    var station_address: String?        //电站地址
    var insured_price: NSNumber?        //保额
    var insured_from: String?           //开始日期
    var insured_end: String?            //结束日期
    var order_status: NSNumber?         //状态：1-未受理  2-已完成
    var server_contract_img: String?    //后台传的合同图片
    var client_contract_img: String?    //并网合同图片
    var type : String?
    var label : String?
}
