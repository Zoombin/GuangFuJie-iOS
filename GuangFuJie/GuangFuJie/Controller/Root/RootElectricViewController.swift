//
//  RootElectricViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/3.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

//发电量
class RootElectricViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var devicesArray = NSMutableArray()
    var deviceTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        //MARK: 如果是root的话必须初始化这三个
        showTopMenu(self.tabBarController!.selectedIndex)
        initRightNavButton()
        initLeftNavButton()
        initLoginView()
        initDeviceList()
    }
    
    override func userDidLogin() {
        loadData()
    }
    
    func loadData() {
        if (!UserDefaultManager.isLogin()) {
            self.devicesArray.removeAllObjects()
            self.deviceTableView.reloadData()
            return
        }
        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.getUserDeviceList({ (deviceList) in
            self.hideHud()
            self.devicesArray.removeAllObjects()
            if (deviceList.count > 0) {
                self.devicesArray.addObjectsFromArray(deviceList as [AnyObject])
            }
            self.deviceTableView.reloadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("发电量")
        loadData()
    }
    
    //MARK: 业主
    let deviceCellReuseIdentifier = "deviceCellReuseIdentifier"
    func initDeviceList() {
        deviceTableView = UITableView.init(frame: CGRectMake(0, 64 + topMenuView.frame.size.height, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - 64 - topMenuView.frame.size.height - 50), style: UITableViewStyle.Plain)
        deviceTableView.delegate = self
        deviceTableView.dataSource = self
        deviceTableView.backgroundColor = Colors.bkgColor
        deviceTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(deviceTableView)
        
        deviceTableView.registerNib(UINib(nibName: DeviceCell.getNidName(), bundle: nil), forCellReuseIdentifier: "DeviceCell")
    
        let deviceBottomView = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(deviceTableView.frame), PhoneUtils.kScreenWidth, 50))
        deviceBottomView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(deviceBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = deviceBottomView.frame.size.height - 5 * 2
        
        let bindButton = UIButton.init(type: UIButtonType.Custom)
        bindButton.frame = CGRectMake(5, 5, buttonWidth, buttonHeight)
        bindButton.setTitle("绑定设备", forState: UIControlState.Normal)
        bindButton.backgroundColor = Colors.installColor
        bindButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        bindButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge2)
        bindButton.addTarget(self, action: #selector(self.deviceButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        deviceBottomView.addSubview(bindButton)
    }
    
    func deviceButtonClicked() {
        if (shouldShowLogin()) {
            return
        }
        let vc = BindDeviceViewController()
        self.pushViewController(vc)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devicesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DeviceCell", forIndexPath: indexPath) as! DeviceCell
        
        let device = devicesArray[indexPath.row] as! DeviceListInfo
        cell.setData(device)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return DeviceCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let device = devicesArray[indexPath.row] as! DeviceListInfo
        let vc = DeviceDetailViewController()
        vc.device_id = device.device_id!
        self.pushViewController(vc)
    }
    
}
