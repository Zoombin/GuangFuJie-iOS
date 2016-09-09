//
//  MoreSafeViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/9.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class MoreSafeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var safeTableView : UITableView!
    var safeArray : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "已购买保险用户"
        // Do any additional setup after loading the view.
        initView()
        loadUserList()
    }
    
    func loadUserList() {
        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.usersHaveInsuranceList({ (insuranceList) in
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
        let userInfo = safeArray[indexPath.row] as! InsuranceInfo
        var name = ""
        if (userInfo.beneficiary_name != nil) {
            name = name + userInfo.beneficiary_name!
        }
        name = name + "已购买保险"
        cell.titleLabel.text = name
        if ((userInfo.insured_from) != nil) {
            cell.timeLabel.text = userInfo.insured_from!
        }
        var type = ""
        if (userInfo.size != nil) {
            type = type + "购买类型:" + userInfo.size!
        }
        if (userInfo.years != nil) {
            type = type + "购买年限:" + String(userInfo.years!)
        }
        if (userInfo.price != nil) {
            type = type + "价格:" + String(userInfo.price!)
        }
        if (userInfo.insured_price != nil) {
            type = type + "保额:" + String(userInfo.insured_price!)
        }
        cell.describeLabel.text = type
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
