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
        addTopHeaderView()
        
        loadData()
    }
    
    func addTopHeaderView() {
        let times = PhoneUtils.kScreenWidth / 375
        let titles = ["月", "还款(元/月)", "利息(元)", "剩余还款(元)"]
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
    
    func loadData() {
        self.showHud(in: self.view, hint: "加载中...")
        let investAmount = NSString.init(string: params.loan_value!).floatValue
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
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "生成截图", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.screenShot))
    }
    
    func screenShot() {
        let image = YCPhoneUtils.screenShot(view: self.view)
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.showHint("截图成功")
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
        cell.firstLabel.text = String(format: "%.0f", info.month!.floatValue)
        cell.secondLabel.text = String(format: "%.0f", info.monthPay!.floatValue)
        cell.thirdLabel.text = String(format: "%.0f", info.interest!.floatValue)
        cell.fourthLabel.text = String(format: "%.0f", info.total_money!.floatValue)
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

