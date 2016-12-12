//
//  MoreSafeViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/9.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class MoreSafeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var safeTableView : UITableView!
    var safeArray : NSMutableArray = NSMutableArray()
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "购买保险列表"
        // Do any additional setup after loading the view.
        initView()
        
        safeTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.loadUserList))
        safeTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMore))
        
        loadUserList()
    }
    
    func loadMore() {
        currentPage = currentPage + 1
        API.sharedInstance.usersHaveInsuranceList(currentPage, pagesize: 10, success: { (insuranceList) in
            self.safeTableView.mj_footer.endRefreshing()
            if (insuranceList.count > 0) {
                self.safeArray.addObjectsFromArray(insuranceList as [AnyObject])
            }
            if (insuranceList.count < 10) {
                self.safeTableView.mj_footer.hidden = true
            }
            self.safeTableView.reloadData()
        }) { (msg) in
            self.safeTableView.mj_footer.endRefreshing()
            self.showHint(msg)
        }
    }
    
    func loadUserList() {
        currentPage = 0
        self.safeTableView.mj_footer.hidden = false
        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.usersHaveInsuranceList(currentPage, pagesize: 10, success: { (insuranceList) in
            self.safeTableView.mj_header.endRefreshing()
            self.hideHud()
            self.safeArray.removeAllObjects()
            if (insuranceList.count > 0) {
                self.safeArray.addObjectsFromArray(insuranceList as [AnyObject])
            }
            if (insuranceList.count < 10) {
                self.safeTableView.mj_footer.hidden = true
            }
            self.safeTableView.reloadData()
        }) { (msg) in
            self.safeTableView.mj_header.endRefreshing()
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
        cell.setData(userInfo, isSelf: false)
        cell.viewMoreButton.setTitle("我也要投", forState: UIControlState.Normal)
        cell.viewMoreButton.addTarget(self, action: #selector(self.buySafe), forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    func buySafe() {
        if (shouldShowLogin()) {
            return
        }
        let vc = BuySafeViewController()
        self.pushViewController(vc)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}