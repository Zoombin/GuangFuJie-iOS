//
//  MySafeListViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/9.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class MySafeListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var safeTableView : UITableView!
    var safeArray : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的保险列表"
        // Do any additional setup after loading the view.
        initView()
        loadUserList()
    }
    
    func loadUserList() {
        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.myInsuranceList({ (insuranceList) in
            self.hideHud()
            self.safeArray.removeAllObjects()
            if (insuranceList.count > 0) {
                self.safeArray.addObjectsFromArray(insuranceList as [AnyObject])
            }
            self.safeTableView.reloadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    let safeCellReuseIdentifier = "safeCellReuseIdentifier"
    func initView() {
        safeTableView = UITableView.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight), style: UITableViewStyle.Plain)
        safeTableView.delegate = self
        safeTableView.dataSource = self
        safeTableView.backgroundColor = Colors.bkgColor
        safeTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(safeTableView)
        
        safeTableView.registerClass(SafeCell.self, forCellReuseIdentifier: safeCellReuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return safeArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SafeCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(safeCellReuseIdentifier, forIndexPath: indexPath) as! SafeCell
        cell.initCell()
        let userInfo = safeArray[indexPath.row] as! InsuranceDetail
        cell.titleLabel.text = "已购买保险"
        if ((userInfo.insured_from) != nil) {
            cell.timeLabel.text = userInfo.insured_from!
        }
        var type = ""
        if (userInfo.size != nil) {
            type = type + "类型:" + userInfo.size! + ","
        }
        if (userInfo.years != nil) {
            type = type + "年限:" + String(userInfo.years!) + "年,"
        }
        if (userInfo.price != nil) {
            type = type + "价格￥:" + String(userInfo.price!) + "元,"
        }
        if (userInfo.insured_price != nil) {
            let size = NSString.init(string: userInfo.size!)
            size.stringByReplacingOccurrencesOfString("KW", withString: "")
            let sizeFloat : CGFloat = CGFloat(size.floatValue)
            
            let baoe1 : CGFloat = sizeFloat * 0.7
            let baoe2 : CGFloat = sizeFloat * 0.7
            let baoe3 : CGFloat = 2.0
            let total : CGFloat = baoe1 + baoe2 + baoe3
            let baoe = String(format: "%.1f万/年", total)
            type = type + "保额:" + baoe
        }
        cell.describeLabel.text = type
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let userInfo = safeArray[indexPath.row] as! InsuranceDetail
        let vc = SafeDetailViewController()
        vc.insuranceId = userInfo.id
        self.pushViewController(vc)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
