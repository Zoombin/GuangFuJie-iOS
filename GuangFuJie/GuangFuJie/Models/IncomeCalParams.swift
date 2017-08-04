//
//  IncomeCalParams.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/8/4.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class IncomeCalParams: NSObject {
    var invest_amount: NSNumber?  //投资金额
    var recoverable_liquid_capital: NSNumber?  //可回收流动资金
    var annual_maintenance_cost: NSNumber?  //运维成本
    var installed_subsidy: NSNumber? //装机补贴
    var loan_ratio: NSNumber? //贷款利率
    var years_of_loans: NSNumber? //贷款时间
    var occupied_electric_ratio: NSNumber? //自用电比例
    var electric_price_perional: NSNumber? //自用电价格
    var electricity_subsidy: NSNumber? //用电补贴价格
    var electricity_subsidy_year: NSNumber? //用电补贴年数
    var sparetime_electric_price: NSNumber?   //余电上网价
}
