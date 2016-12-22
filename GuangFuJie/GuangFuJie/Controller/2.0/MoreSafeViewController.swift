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
                self.safeArray.addObjects(from: insuranceList as [AnyObject])
            }
            if (insuranceList.count < 10) {
                self.safeTableView.mj_footer.isHidden = true
            }
            self.safeTableView.reloadData()
        }) { (msg) in
            self.safeTableView.mj_footer.endRefreshing()
            self.showHint(msg)
        }
    }
    
    func loadUserList() {
        currentPage = 0
        self.safeTableView.mj_footer.isHidden = false
        self.showHud(in: self.view, hint: "加载中...")
        API.sharedInstance.usersHaveInsuranceList(currentPage, pagesize: 10, success: { (insuranceList) in
            self.safeTableView.mj_header.endRefreshing()
            self.hideHud()
            self.safeArray.removeAllObjects()
            if (insuranceList.count > 0) {
                self.safeArray.addObjects(from: insuranceList as [AnyObject])
            }
            if (insuranceList.count < 10) {
                self.safeTableView.mj_footer.isHidden = true
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
        safeTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight), style: UITableViewStyle.plain)
        safeTableView.delegate = self
        safeTableView.dataSource = self
        safeTableView.backgroundColor = Colors.bkgColor
        safeTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(safeTableView)
        
        safeTableView.register(SafeCell.self, forCellReuseIdentifier: safeCellReuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return safeArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SafeCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: safeCellReuseIdentifier, for: indexPath as IndexPath) as! SafeCell
        cell.initCell()
        let userInfo = safeArray[indexPath.row] as! InsuranceInfo
        cell.setData(userInfo, isSelf: false)
        cell.viewMoreButton.setTitle("我也要投", for: UIControlState.normal)
        cell.viewMoreButton.addTarget(self, action: #selector(self.buySafe), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    func buySafe() {
        if (shouldShowLogin()) {
            return
        }
        let vc = BuySafeViewController()
        self.pushViewController(vc)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
}
