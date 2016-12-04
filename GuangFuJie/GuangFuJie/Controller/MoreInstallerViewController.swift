//
//  MoreInstallerViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/7.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class MoreInstallerViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var yezhuTableView : UITableView!
    var yezhuArray : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安装商列表"
        // Do any additional setup after loading the view.
        initView()
        loadUserList()
    }
    
    func loadUserList() {
        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.userlist(2, province_id: nil, city_id: nil, is_suggest: nil, success: { (userInfos) in
            self.hideHud()
            self.yezhuArray.removeAllObjects()
            if (userInfos.count > 0) {
                self.yezhuArray.addObjectsFromArray(userInfos as [AnyObject])
            }
            self.yezhuTableView.reloadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    let yezhuCellReuseIdentifier = "yezhuCellReuseIdentifier"
    func initView() {
        yezhuTableView = UITableView.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight), style: UITableViewStyle.Plain)
        yezhuTableView.delegate = self
        yezhuTableView.dataSource = self
        yezhuTableView.backgroundColor = Colors.bkgColor
        yezhuTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(yezhuTableView)
        
        yezhuTableView.registerClass(YeZhuCell.self, forCellReuseIdentifier: yezhuCellReuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yezhuArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return YeZhuCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(yezhuCellReuseIdentifier, forIndexPath: indexPath) as! YeZhuCell
        cell.initCell()
//        let userInfo = yezhuArray[indexPath.row] as! InstallInfo
//        cell.titleLabel.text = userInfo.company_name
//        cell.describeLabel.text = userInfo.company_intro
//        var location = ""
//        if ((userInfo.province_label) != nil) {
//            location = location + userInfo.province_label!
//        }
//        if ((userInfo.city_label) != nil) {
//            location = location + userInfo.city_label!
//        }
//        if ((userInfo.address) != nil) {
//            location = location + userInfo.address!
//        }
//        cell.addressLabel.text = location
//        if (userInfo.is_installer == 2) {
//            cell.tagLabel.text = "已认证"
//            cell.tagLabel.textColor = Colors.installColor
//        } else {
//            cell.tagLabel.text = "未认证"
//            cell.tagLabel.textColor = Colors.installRedColor
//        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
