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
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
        let userInfo = safeArray[indexPath.row] as! InsuranceInfo
        cell.setData(userInfo, isSelf: true)
        cell.viewMoreButton.setTitle("查看详情", forState: UIControlState.Normal)
        cell.viewMoreButton.userInteractionEnabled = false
        cell.payButton.tag = indexPath.row
        cell.payButton.addTarget(self, action: #selector(self.payButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    func payButtonClicked(button : UIButton) {
        let index = button.tag
        let userInfo = safeArray[index] as! InsuranceInfo
        
        let title = "保险类型:" + String(userInfo.size!) + " " + String(userInfo.years!) + "年";
        let currentPrice = NSInteger.init(userInfo.years!) * userInfo.price!.integerValue * 100
        
        self.aliPay(userInfo.insured_sn!, title: title, totalFee: String(currentPrice), type: String(userInfo.type!))
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let userInfo = safeArray[indexPath.row] as! InsuranceInfo
        let vc = SafeDetailViewController()
        vc.insuranceId = userInfo.id
        self.pushViewController(vc)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
