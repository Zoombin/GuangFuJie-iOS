//
//  RootComViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/30.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootComViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var resultTableView: UITableView!
    
    var params: CalResultParams!
    var titles = ["项目地点", "年辐射量", "屋顶面积", "装机容量", "投资金额", "年运维成本", "首年发电量", "25年总发电量", "首年收益", "25年总收益", "收益率", "回报周期"]
    var results = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
        loadComReport()
    }
    
    func initView() {
        self.navigationItem.title = "综合收益"
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "生成截图", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.screenShot))
    }
    
    func screenShot() {
        let image = YCPhoneUtils.screenShot(view: self.view)
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.showHint("截图成功")
    }
    
    func loadComReport() {
        self.showHud(in: self.view, hint: "加载中...")
        API.sharedInstance.projectcalIncomecal(type: params.type!, size: params.size!, invest_amount: params.invest_amount!, recoverable_liquid_capital: params.recoverable_liquid_capital!, annual_maintenance_cost: params.annual_maintenance_cost!, installed_subsidy: params.installed_subsidy!, loan_ratio: params.loan_ratio!, years_of_loans: params.years_of_loans!, occupied_electric_ratio: params.occupied_electric_ratio!, electric_price_perional: params.electric_price_perional!, electricity_subsidy: params.electricity_subsidy!, electricity_subsidy_year: params.electricity_subsidy_year!, sparetime_electric_price: params.sparetime_electric_price!, wOfPrice: params.wOfPrice!, firstYearKwElectric: params.firstYearKwElectric!, success: { (calInfo) in
            self.hideHud()
            self.inputValue(result: calInfo)
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    func inputValue(result: IncomecalInfo) {
        results.addObjects(from: [params.address!,
                                  result.energy_year! + " 度/平方米",
                                  result.size! + " 平方米",
                                  result.build_size! + " 千瓦",
                                  result.invest_amount! + " 元",
                                  result.annual_maintenance_cost! + " 元",
                                  result.electric_firstyear_total! + " 度",
                                  result.electric_25! + " 度",
                                  result.income_firstyear! + " 元",
                                  result.income_25! + " 元",
                                  result.income_rate! + " %",
                                  result.income_date! + " 年"])
        resultTableView.reloadData()
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
        let cellIdentifier = "ResultCell\((indexPath.row+1)%2 == 0 ? "1" : "2")"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        cell?.textLabel?.text = titles[indexPath.row]
        cell?.detailTextLabel?.text = results[indexPath.row] as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

