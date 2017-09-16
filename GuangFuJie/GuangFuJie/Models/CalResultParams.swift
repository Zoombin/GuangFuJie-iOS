//
//  CalResultParams.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/9/16.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class CalResultParams: NSObject {
    
    var type: NSNumber?                     //1,2,3 三种类型
    var size: String?                       //面积
    var invest_amount: NSNumber?            //投资金额
    var recoverable_liquid_capital: String? //可回收流动资金
    var annual_maintenance_cost: String?    //年运维成本
    var installed_subsidy: String?        //装机补贴
    var loan_ratio: String?                 //贷款比例
    var years_of_loans: String?             //贷款年数
    var occupied_electric_ratio: String?    //自用电比例
    var electric_price_perional: String?     //自用电电价
    var electricity_subsidy: String?        //用电补贴
    var electricity_subsidy_year: String?   //用电补贴年
    var sparetime_electric_price: String?             //余电上网价
    var wOfPrice: String?                            //每瓦投资金额,默认：8
    var firstYearKwElectric: String?                //首年千瓦日发电,默认：4
}
