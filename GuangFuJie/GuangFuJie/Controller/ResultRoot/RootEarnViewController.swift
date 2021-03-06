//
//  RootEarnViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/30.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootEarnViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var resultTableView: UITableView!
    var results = NSMutableArray()
    var params: CalResultParams!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        addTopHeaderView()
        
        loadData()
    }
    
    func addTopHeaderView() {
        let times = PhoneUtils.kScreenWidth / 375
        let titles = ["月", "现金流入(元)", "现金流出(元)", "累计净现(元)"]
        let titleWidth = PhoneUtils.kScreenWidth / CGFloat(titles.count)
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 50 * times))
        for i in 0..<titles.count {
            let label = UILabel.init(frame: CGRect(x: titleWidth * CGFloat(i), y: 0, width: titleWidth, height: headerView.frame.size.height))
            label.text = titles[i]
            label.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
            label.backgroundColor = i % 2 == 0 ? Colors.lightBlue : Colors.lightYellow
            label.textAlignment = NSTextAlignment.center
            headerView.addSubview(label)
        }
        resultTableView.tableHeaderView = headerView
    }
    
    func initView() {
        self.navigationItem.title = "净收益"
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "生成截图", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.screenShot))
    }
    
    func screenShot() {
        let image = YCPhoneUtils.screenShot(view: self.view)
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.showHint("截图成功")
    }
    
    func loadData() {
        self.showHud(in: self.view, hint: "加载中...")
        API.sharedInstance.projectcalNetprofit(type: params.type!, size: params.size!, invest_amount: params.invest_amount!, recoverable_liquid_capital: params.recoverable_liquid_capital!, annual_maintenance_cost: params.annual_maintenance_cost!, installed_subsidy: params.installed_subsidy!, loan_ratio: params.loan_value!, years_of_loans: params.years_of_loans!, occupied_electric_ratio: params.occupied_electric_ratio!, electric_price_perional: params.electric_price_perional!, electricity_subsidy: params.electricity_subsidy!, electricity_subsidy_year: params.electricity_subsidy_year!, sparetime_electric_price: params.sparetime_electric_price!, wOfPrice: params.wOfPrice!, firstYearKwElectric: params.firstYearKwElectric!, build_size: YCStringUtils.getString(params.build_size), success: { (totalCount, array) in
            self.hideHud()
            self.results.addObjects(from: array as! [Any])
            self.resultTableView.reloadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
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
        let info = results[indexPath.row] as! NetprofitInfo
        cell.firstLabel.text = info.month!
        cell.secondLabel.text = info.monthEarn!
        cell.thirdLabel.text = info.monthPay!
        cell.fourthLabel.text = info.netProfit!
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

