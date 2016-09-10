//
//  ApplyForOrderViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/10.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class ApplyForOrderViewController: BaseViewController {

    var insuranceType : InsuranceType!
    var years : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "申请购买"
        // Do any additional setup after loading the view.
        initView()
    }

    func initView() {
        let button = UIButton.init(type: UIButtonType.Custom)
        button.frame = CGRectMake(0, 200, 100, 100)
        button.setTitle("立即购买", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.submitOrder), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    func submitOrder() {
        self.showHudInView(self.view, hint: "提交中...")
        API.sharedInstance.insuranceAdd(insuranceType.company_id!, type_id: insuranceType.id!, years: years, price: insuranceType.price!, beneficiary_name: "1", beneficiary_phone: "1", beneficiary_id_no: "1", station_address: "1", client_contract_img: "1", success: { (commonModel) in
                self.hideHud()
                self.aliPay(commonModel.order_sn!, title: self.insuranceType.size!, totalFee: String(self.insuranceType.price!.intValue * 100), type: commonModel.type!)
            }) { (msg) in
                self.hideHud()
                self.showHint(msg)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
