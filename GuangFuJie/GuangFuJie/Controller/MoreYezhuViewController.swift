//
//  MoreYezhuViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/7.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class MoreYezhuViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var installTableView : UITableView!
    var installerArray : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "业主出租"
        // Do any additional setup after loading the view.
        initView()
        loadInstallerList()
    }
    
    //MARK: 安装商列表
    func loadInstallerList() {
        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.getRoofList(1, province_id: nil, city_id: nil, success: { (userInfos) in
            self.hideHud()
            self.installerArray.removeAllObjects()
            if (userInfos.count > 0) {
                self.installerArray.addObjectsFromArray(userInfos as [AnyObject])
            }
            self.installTableView.reloadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    let installerCellReuseIdentifier = "installerCellReuseIdentifier"
    func initView() {
        installTableView = UITableView.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight), style: UITableViewStyle.Plain)
        installTableView.delegate = self
        installTableView.dataSource = self
        installTableView.backgroundColor = Colors.bkgColor
        installTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(installTableView)
        
        installTableView.registerClass(InstallerCell.self, forCellReuseIdentifier: installerCellReuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return installerArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return InstallerCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(installerCellReuseIdentifier, forIndexPath: indexPath) as! InstallerCell
        cell.initCell()
        let userInfo = installerArray[indexPath.row] as! RoofInfo
        if ((userInfo.fullname) != nil) {
            cell.titleLabel.text = userInfo.fullname! + " " + "屋顶出租"
        }
        if ((userInfo.created_date) != nil) {
            cell.timeLabel.text = userInfo.created_date!
        }
        var describeInfo = ""
        if (userInfo.area_size != nil) {
            describeInfo = describeInfo + "屋顶面积:" + String(format: "%.2f", userInfo.area_size!.floatValue) + "㎡"
        }
        if (userInfo.type != nil) {
            describeInfo = describeInfo + "," + (userInfo.type == 2 ? "斜面" : "平面") + ","
        }
        if (userInfo.price != nil) {
            describeInfo = describeInfo + String(userInfo.price!) + "元/㎡"
        }
        cell.describeLabel.text = describeInfo
        var location = ""
        if ((userInfo.province_label) != nil) {
            location = location + userInfo.province_label!
        }
        if ((userInfo.city_label) != nil) {
            location = location + userInfo.city_label!
        }
        if ((userInfo.address) != nil) {
            location = location + userInfo.address!
        }
        cell.addressLabel.text = location
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
