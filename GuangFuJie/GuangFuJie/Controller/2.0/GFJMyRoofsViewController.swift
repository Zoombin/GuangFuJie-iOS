//
//  GFJMyRoofsViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/10.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class GFJMyRoofsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var installTableView : UITableView!
    var installerArray : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的屋顶"
        // Do any additional setup after loading the view.
        initView()
        loadInstallerList()
    }
    
    //MARK: 安装商列表
    func loadInstallerList() {
        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.getRoofList(0, pagesize: 10, status: 1, province_id: nil, city_id: nil, isSelf : 1, success: { (userInfos) in
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
            cell.nameLabel.text = userInfo.fullname! + " " + "屋顶出租"
        }
        if ((userInfo.created_date) != nil) {
            cell.timeLabel.text = userInfo.created_date!
        }
        if (userInfo.area_image != nil) {
            cell.avatarImageView.setImageWithURL(NSURL.init(string: userInfo.area_image!)!)
        } else {
            cell.avatarImageView.image = UIImage(named: "ic_avatar_yezhu")
        }
        var type = "屋顶类型:"
        var size = "屋顶面积:"
        var price = "屋顶租金:"
        if (userInfo.area_size != nil) {
            size = size + String(format: "%.2f", userInfo.area_size!.floatValue) + "㎡"
        }
        if (userInfo.type != nil) {
            type = type + (userInfo.type == 2 ? "斜面" : "平面")
        }
        if (userInfo.price != nil) {
            price = price + String(userInfo.price!) + "元/㎡"
        }
        cell.roofTypeLabel.text = type
        cell.roofSizeLabel.text = size
        cell.roofPriceLabel.text = price
        
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
        cell.viewMoreButton.setTitle("查找安装商", forState: UIControlState.Normal)
        cell.viewMoreButton.addTarget(self, action: #selector(self.viewInstallerList), forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    func viewInstallerList() {
        let vc = MoreInstallerViewController()
        self.pushViewController(vc)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let userInfo = installerArray[indexPath.row] as! RoofInfo
        let vc = InstallBuyViewController()
        vc.isSelf = true
        vc.roofId = userInfo.id!
        self.pushViewController(vc)
    }

}
