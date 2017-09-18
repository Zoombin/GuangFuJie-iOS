//
//  RootPayViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/30.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootPayViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var resultTableView: UITableView!
    var results = NSMutableArray()
    var params: CalResultParams!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        loadData()
    }
    
    func loadData() {
        self.showHud(in: self.view, hint: "加载中...")
        let investAmount = NSString.init(string: params.loan_ratio!).floatValue * params.invest_amount!.floatValue / 100
        if (investAmount == 0) {
            self.hideHud()
            return
        }
        API.sharedInstance.projectcalRepaymentList(invest_amount: NSNumber.init(value: investAmount), invest_year: params.years_of_loans!, success: { (count, array) in
            self.hideHud()
            self.results.addObjects(from: array as! [Any])
            self.resultTableView.reloadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    func initView() {
        self.navigationItem.title = "还款额度"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 1))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CalResultCommonCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CalResultCommonCell
        let info = results[indexPath.row] as! RepaymentInfo
        cell.firstLabel.text = info.month
        cell.secondLabel.text = info.monthPay
        cell.thirdLabel.text = info.total_money
        cell.fourthLabel.text = info.interest
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

