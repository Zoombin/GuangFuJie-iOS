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
    
    var noDataView : UIView!
    
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
        addNoDataButton()
    }
    
    func addNoDataButton() {
        let startX = (PhoneUtils.kScreenWidth - 160) / 2
        noDataView = UIView.init(frame: CGRect(x: startX, y:50, width: 160, height: 20))
        noDataView.backgroundColor = UIColor.clear
        deviceTableView.addSubview(noDataView)
        
        let noDeviceLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 90, height: 20))
        noDeviceLabel.text = "暂无绑定设备"
        noDeviceLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        noDataView.addSubview(noDeviceLabel)
        
        let noDeviceButton = UIButton.init(type: UIButtonType.custom)
        noDeviceButton.setTitle("点击绑定", for: UIControlState.normal)
        noDeviceButton.setTitleColor(Colors.installColor, for: UIControlState.normal)
        noDeviceButton.frame = CGRect(x: noDeviceLabel.frame.maxX, y: 0, width: 70, height: 20)
        noDeviceButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        noDeviceButton.addTarget(self, action: #selector(self.deviceButtonClicked), for: UIControlEvents.touchUpInside)
        noDataView.addSubview(noDeviceButton)
        
        noDataView.isHidden = true
    }
    
    override func userDidLogin() {
        loadData()
    }
    
    func loadData() {
        if (!UserDefaultManager.isLogin()) {
            self.devicesArray.removeAllObjects()
            self.deviceTableView.reloadData()
            if (self.devicesArray.count == 0) {
                self.noDataView.isHidden = false
            }
            return
        }
//        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.getUserDeviceList({ (deviceList) in
            self.hideHud()
            self.devicesArray.removeAllObjects()
            if (deviceList.count > 0) {
                self.noDataView.isHidden = true
                self.devicesArray.addObjects(from: deviceList as [AnyObject])
            }
            self.deviceTableView.reloadData()
            if (self.devicesArray.count == 0) {
                self.noDataView.isHidden = false
            }
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("发电量")
        loadData()
    }
    
    //MARK: 业主
    let deviceCellReuseIdentifier = "deviceCellReuseIdentifier"
    func initDeviceList() {
        deviceTableView = UITableView.init(frame: CGRect(x: 0, y: 64 + topMenuView.frame.size.height, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - 64 - topMenuView.frame.size.height - 50), style: UITableViewStyle.plain)
        deviceTableView.delegate = self
        deviceTableView.dataSource = self
        deviceTableView.backgroundColor = Colors.bkgColor
        deviceTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(deviceTableView)
        
        deviceTableView.register(UINib(nibName: DeviceCell.getNidName(), bundle: nil), forCellReuseIdentifier: "DeviceCell")
    
        let deviceBottomView = UIView.init(frame: CGRect(x: 0, y: deviceTableView.frame.maxY, width: PhoneUtils.kScreenWidth, height: 50))
        deviceBottomView.backgroundColor = UIColor.white
        self.view.addSubview(deviceBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = deviceBottomView.frame.size.height - 5 * 2
        
        let bindButton = UIButton.init(type: UIButtonType.custom)
        bindButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        bindButton.setTitle("绑定设备", for: UIControlState.normal)
        bindButton.backgroundColor = Colors.installColor
        bindButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        bindButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        bindButton.addTarget(self, action: #selector(self.deviceButtonClicked), for: UIControlEvents.touchUpInside)
        deviceBottomView.addSubview(bindButton)
    }
    
    func deviceButtonClicked() {
        if (shouldShowLogin()) {
            return
        }
        let vc = BindDeviceViewController()
        self.pushViewController(vc)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devicesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath as IndexPath) as! DeviceCell
        let device = devicesArray[indexPath.row] as! DeviceListInfo
        cell.setData(device)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DeviceCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let device = devicesArray[indexPath.row] as! DeviceListInfo
        let vc = DeviceDetailViewController()
        vc.device_id = device.device_id!
        self.pushViewController(vc)
    }
    
}
