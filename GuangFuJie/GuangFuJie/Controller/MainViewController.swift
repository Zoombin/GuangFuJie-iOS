//
//  MainViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/7/30.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController, LoginViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    var buttons = NSMutableArray()
    var loginView : LoginView!
    var aboutUsView : ABoutUsView!
    
    var yezhuView : UIView!
    var installView : UIView!
    
    var statusButton : UIButton!
    var statusLabel : UILabel!
    var checkMarkButton : UIButton!
    var gonglvLabel : UILabel!
    var fadianLabel : UILabel!
    var todayElectricLabel : UILabel!
    var totalElectricLabel : UILabel!
    var todayMoneyLabel : UILabel!
    var totalMoneyLabel : UILabel!
    var todayjianpaiLabel : UILabel!
    var totaljianpaiLabel : UILabel!
    var todayplantLabel : UILabel!
    var totalplantLabel : UILabel!
    
    var electricView : UIView!
    
    var bindView : UIView!
    var deviceTextField : UITextField!
    var safeView : UIView!
    
    var topView : UIView!
    
    let offSetY : CGFloat = 10
    let offSetX : CGFloat = 10
    
    let YEZHU_TABLEVIEW_TAG = 10001
    let INSTALLER_TABLEVIEW_TAG = 10002
    
    let YEZHU_SCROLLVIEW_TAG = 1001
    let INSTALLER_SCROLLVIEW_TAG = 1002
    var yezhuPageControl : UIPageControl!
    var installerPageControl : UIPageControl!
    
    var yezhuTableView : UITableView!
    var installTableView : UITableView!
    
    //业主列表数组
    var yezhuArray : NSMutableArray = NSMutableArray()
    
    //安装商数组
    var installerArray : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initLeftNavButton()
        initRightNavButton()
        
        initView()
        initLoginView()
        initAboutUsView()
        
        initYeZhuView()
        initInstallerView()
        initElectricView()
        initSafeView()
        initBindView()
        
        goToTab(0)
    }
    
    //MARK: 保险
    func initSafeView() {
        safeView = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(topView.frame), PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - topView.frame.size.height - 64))
        self.view.addSubview(safeView)
    }
    
    func initBindView() {
        bindView = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(topView.frame), PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - topView.frame.size.height - 64))
        self.view.addSubview(bindView)
        
        let bindViewBottomView = UIView.init(frame: CGRectMake(0, bindView.frame.size.height - 50, PhoneUtils.kScreenWidth, 50))
        bindViewBottomView.backgroundColor = UIColor.whiteColor()
        bindView.addSubview(bindViewBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = bindViewBottomView.frame.size.height - 5 * 2
        
        let width = PhoneUtils.kScreenWidth * 0.6
        let height = (397 * width) / 309
        let deviceBkgImageView = UIImageView.init(frame: CGRectMake((PhoneUtils.kScreenWidth - width) / 2, 0, width, height))
        deviceBkgImageView.image = UIImage(named: "ic_device_temp")
        bindView.addSubview(deviceBkgImageView)
        
        deviceTextField = UITextField.init(frame: CGRectMake((PhoneUtils.kScreenWidth - buttonWidth) / 2, CGRectGetMaxY(deviceBkgImageView.frame) + 8, buttonWidth, buttonHeight))
        deviceTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        deviceTextField.layer.borderWidth = 0.5
        bindView.addSubview(deviceTextField)
        
        let bindButton = UIButton.init(type: UIButtonType.Custom)
        bindButton.frame = CGRectMake(5, 5, buttonWidth, buttonHeight)
        bindButton.setTitle("绑定设备", forState: UIControlState.Normal)
        bindButton.backgroundColor = Colors.installColor
        bindButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        bindButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge2)
        bindButton.addTarget(self, action: #selector(self.bindButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        bindViewBottomView.addSubview(bindButton)
    }
    
    func bindButtonClicked() {
        deviceTextField.resignFirstResponder()
        if (!UserDefaultManager.isLogin()) {
            self.showHint("请登录!")
            return
        }
        let deviceId = deviceTextField.text
        if (deviceId!.isEmpty) {
            self.showHint("请输入设备号")
            return
        }
        self.showHudInView(self.view, hint: "绑定中...")
        API.sharedInstance.bindDevice(deviceTextField.text!, success: { (userInfo) in
                self.hideHud()
                self.showHint("绑定成功!")
                UserDefaultManager.saveString(UserDefaultManager.USER_INFO, value: userInfo.mj_JSONString())
            }) { (msg) in
                self.hideHud()
                self.showHint(msg)
        }
    }
    
    //MARK: 发电量
    func initElectricView() {
        electricView = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(topView.frame), PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - topView.frame.size.height - 64))
        electricView.backgroundColor = Colors.bkgGray
        self.view.addSubview(electricView)
        
        let dir : CGFloat = 8
        
        let bkgView = UIView.init(frame: CGRectMake(0, dir, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight * 0.2))
        bkgView.backgroundColor = UIColor.whiteColor()
        electricView.addSubview(bkgView)
        
        let height = bkgView.frame.size.height / 2
        
        statusButton = UIButton.init(type: UIButtonType.Custom)
        statusButton.frame = CGRectMake(dir, height * 0.25, height * 0.5, height * 0.5)
        statusButton.setImage(UIImage(named: "ic_right"), forState: UIControlState.Normal)
        statusButton.setImage(UIImage(named: "ic_error"), forState: UIControlState.Disabled)
        bkgView.addSubview(statusButton)
        
        statusLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(statusButton.frame) + offSetX, height * 0.25, 140, height * 0.5))
        statusLabel.text = ""
        statusLabel.textColor = Colors.installColor
        statusLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        bkgView.addSubview(statusLabel)
        
        checkMarkButton = UIButton.init(type: UIButtonType.Custom)
        checkMarkButton.frame = CGRectMake(CGRectGetMaxX(statusLabel.frame) + offSetX, height * 0.25, height * 0.5, height * 0.5)
        checkMarkButton.setImage(UIImage(named: "ic_ok"), forState: UIControlState.Normal)
        checkMarkButton.setImage(UIImage(named: "ic_no"), forState: UIControlState.Disabled)
        bkgView.addSubview(checkMarkButton)
        
        //功率
        let buttonWidth = PhoneUtils.kScreenWidth / 4
        let gonglvButton = UIButton.init(type: UIButtonType.Custom)
        gonglvButton.frame = CGRectMake(0,CGRectGetMaxY(checkMarkButton.frame) + height * 0.1, buttonWidth, height * 0.8)
        gonglvButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        gonglvButton.setTitle("功率:", forState: UIControlState.Normal)
        gonglvButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        gonglvButton.setImage(UIImage(named: "ic_h_power"), forState: UIControlState.Normal)
        bkgView.addSubview(gonglvButton)
        
        gonglvLabel = UILabel.init(frame:CGRectMake(CGRectGetMaxX(gonglvButton.frame),CGRectGetMaxY(checkMarkButton.frame) + height * 0.1, buttonWidth, height * 0.8))
        gonglvLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        gonglvLabel.text = ""
        gonglvLabel.textColor = UIColor.blackColor()
        bkgView.addSubview(gonglvLabel)
        
        //发电
        let fadianButton = UIButton.init(type: UIButtonType.Custom)
        fadianButton.frame = CGRectMake(PhoneUtils.kScreenWidth / 2, CGRectGetMaxY(checkMarkButton.frame) + height * 0.1, buttonWidth, height * 0.8)
        fadianButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        fadianButton.setTitle("发电:", forState: UIControlState.Normal)
        fadianButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        fadianButton.setImage(UIImage(named: "ic_h_days"), forState: UIControlState.Normal)
        bkgView.addSubview(fadianButton)
        
        fadianLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(fadianButton.frame), CGRectGetMaxY(checkMarkButton.frame) + height * 0.1, buttonWidth, height * 0.8))
        fadianLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        fadianLabel.text = ""
        fadianLabel.textColor = UIColor.blackColor()
        bkgView.addSubview(fadianLabel)
        
        //今日发电
        let todayElectricButton = UIButton.init(type: UIButtonType.Custom)
        todayElectricButton.frame = CGRectMake(0,CGRectGetMaxY(bkgView.frame) + height * 0.1, buttonWidth, height * 0.8)
        todayElectricButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        todayElectricButton.setTitle("今日发电:", forState: UIControlState.Normal)
        todayElectricButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        todayElectricButton.setImage(UIImage(named: "ic_h_powerday"), forState: UIControlState.Normal)
        electricView.addSubview(todayElectricButton)
        
        todayElectricLabel = UILabel.init(frame:CGRectMake(CGRectGetMaxX(todayElectricButton.frame), CGRectGetMaxY(bkgView.frame) + height * 0.1, buttonWidth, height * 0.8))
        todayElectricLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        todayElectricLabel.text = ""
        todayElectricLabel.textColor = UIColor.blackColor()
        electricView.addSubview(todayElectricLabel)
        
        //累计发电
        let totalElectricButton = UIButton.init(type: UIButtonType.Custom)
        totalElectricButton.frame = CGRectMake(PhoneUtils.kScreenWidth / 2, CGRectGetMaxY(bkgView.frame) + height * 0.1, buttonWidth, height * 0.8)
        totalElectricButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        totalElectricButton.setTitle("累计发电:", forState: UIControlState.Normal)
        totalElectricButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        electricView.addSubview(totalElectricButton)
        
        totalElectricLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(totalElectricButton.frame), CGRectGetMaxY(bkgView.frame) + height * 0.1, buttonWidth, height * 0.8))
        totalElectricLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        totalElectricLabel.text = ""
        totalElectricLabel.textColor = UIColor.blackColor()
        electricView.addSubview(totalElectricLabel)
        
        //今日收益
        let todayMoneyButton = UIButton.init(type: UIButtonType.Custom)
        todayMoneyButton.frame = CGRectMake(0, CGRectGetMaxY(bkgView.frame) + height * 0.9, buttonWidth, height * 0.8)
        todayMoneyButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        todayMoneyButton.setTitle("今日收益:", forState: UIControlState.Normal)
        todayMoneyButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        todayMoneyButton.setImage(UIImage(named: "ic_h_dayincome"), forState: UIControlState.Normal)
        electricView.addSubview(todayMoneyButton)
        
        todayMoneyLabel = UILabel.init(frame:CGRectMake(CGRectGetMaxX(todayMoneyButton.frame),CGRectGetMaxY(bkgView.frame) + height * 0.9, buttonWidth, height * 0.8))
        todayMoneyLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        todayMoneyLabel.text = ""
        todayMoneyLabel.textColor = UIColor.blackColor()
        electricView.addSubview(todayMoneyLabel)
        
        //累计收益
        let totalMoneyButton = UIButton.init(type: UIButtonType.Custom)
        totalMoneyButton.frame = CGRectMake(PhoneUtils.kScreenWidth / 2, CGRectGetMaxY(bkgView.frame) + height * 0.9, buttonWidth, height * 0.8)
        totalMoneyButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        totalMoneyButton.setTitle("累计收益:", forState: UIControlState.Normal)
        totalMoneyButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        electricView.addSubview(totalMoneyButton)
        
        totalMoneyLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(totalMoneyButton.frame), CGRectGetMaxY(bkgView.frame) + height * 0.9, buttonWidth, height * 0.8))
        totalMoneyLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        totalMoneyLabel.text = ""
        totalMoneyLabel.textColor = UIColor.blackColor()
        electricView.addSubview(totalMoneyLabel)
        
        //今日减排
        let todayjianpaiButton = UIButton.init(type: UIButtonType.Custom)
        todayjianpaiButton.frame = CGRectMake(0, CGRectGetMaxY(bkgView.frame) + height * 1.8, buttonWidth, height * 0.8)
        todayjianpaiButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        todayjianpaiButton.setTitle("今日减排:", forState: UIControlState.Normal)
        todayjianpaiButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        todayjianpaiButton.setImage(UIImage(named: "ic_reduce"), forState: UIControlState.Normal)
        electricView.addSubview(todayjianpaiButton)
        
        todayjianpaiLabel = UILabel.init(frame:CGRectMake(CGRectGetMaxX(todayjianpaiButton.frame),CGRectGetMaxY(bkgView.frame) + height * 1.8, buttonWidth, height * 0.8))
        todayjianpaiLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        todayjianpaiLabel.text = ""
        todayjianpaiLabel.textColor = UIColor.blackColor()
        electricView.addSubview(todayjianpaiLabel)
        
        //累计减排
        let totaljianpaiButton = UIButton.init(type: UIButtonType.Custom)
        totaljianpaiButton.frame = CGRectMake(PhoneUtils.kScreenWidth / 2, CGRectGetMaxY(bkgView.frame) + height * 1.8, buttonWidth, height * 0.8)
        totaljianpaiButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        totaljianpaiButton.setTitle("累计减排:", forState: UIControlState.Normal)
        totaljianpaiButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        electricView.addSubview(totaljianpaiButton)
        
        totaljianpaiLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(totaljianpaiButton.frame), CGRectGetMaxY(bkgView.frame) + height * 1.8, buttonWidth, height * 0.8))
        totaljianpaiLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        totaljianpaiLabel.text = ""
        totaljianpaiLabel.textColor = UIColor.blackColor()
        electricView.addSubview(totaljianpaiLabel)
        
        //今日种植
        let todayPlantButton = UIButton.init(type: UIButtonType.Custom)
        todayPlantButton.frame = CGRectMake(0, CGRectGetMaxY(bkgView.frame) + height * 2.7, buttonWidth, height * 0.8)
        todayPlantButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        todayPlantButton.setTitle("今日种植:", forState: UIControlState.Normal)
        todayPlantButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        todayPlantButton.setImage(UIImage(named: "ic_grow"), forState: UIControlState.Normal)
        electricView.addSubview(todayPlantButton)
        
        todayplantLabel = UILabel.init(frame:CGRectMake(CGRectGetMaxX(todayPlantButton.frame),CGRectGetMaxY(bkgView.frame) + height * 2.7, buttonWidth, height * 0.8))
        todayplantLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        todayplantLabel.text = ""
        todayplantLabel.textColor = UIColor.blackColor()
        electricView.addSubview(todayplantLabel)
        
        //累计种植
        let totalPlantButton = UIButton.init(type: UIButtonType.Custom)
        totalPlantButton.frame = CGRectMake(PhoneUtils.kScreenWidth / 2, CGRectGetMaxY(bkgView.frame) + height * 2.7, buttonWidth, height * 0.8)
        totalPlantButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        totalPlantButton.setTitle("累计种植:", forState: UIControlState.Normal)
        totalPlantButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        electricView.addSubview(totalPlantButton)
        
        totalplantLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(totalPlantButton.frame), CGRectGetMaxY(bkgView.frame) + height * 2.7, buttonWidth, height * 0.8))
        totalplantLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        totalplantLabel.text = ""
        totalplantLabel.textColor = UIColor.blackColor()
        electricView.addSubview(totalplantLabel)
        
        let viewDetailButton = UIButton.init(type: UIButtonType.Custom)
        viewDetailButton.frame = CGRectMake(0, electricView.frame.size.height - PhoneUtils.kScreenHeight * 0.08, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight * 0.08)
        viewDetailButton.setTitle("查看发电曲线图 >>", forState: UIControlState.Normal)
        viewDetailButton.backgroundColor = UIColor.whiteColor()
        viewDetailButton.addTarget(self, action: #selector(self.viewDetailButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        viewDetailButton.setTitleColor(Colors.lightGray, forState: UIControlState.Normal)
        viewDetailButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        electricView.addSubview(viewDetailButton)
    }
    
    func getDeviceInfo() {
        if (UserDefaultManager.isLogin()) {
            let user = UserDefaultManager.getUser()
            if (user?.device_id != nil) {
                self.showHudInView(self.view, hint: "加载中...")
                API.sharedInstance.deviceInfo(user!.device_id!, success: { (deviceInfo) in
                    self.hideHud()
                    self.loadDeviceInfo(deviceInfo)
                    }, failure: { (msg) in
                        self.hideHud()
                        self.showHint(msg)
                })
            }
        }
    }
    
    func loadDeviceInfo(deviceInfo : DeviceInfo) {
        let errorCode1 = NSString.init(string: deviceInfo.errorcode1!)
        let errorCode2 = NSString.init(string: deviceInfo.errorcode2!)
        if (errorCode1.containsString("0000") && errorCode2.containsString("0000")) {
            statusButton.enabled = true
            statusLabel.text = "运行状态 正常"
            statusLabel.textColor = Colors.installColor
            checkMarkButton.enabled = true
        } else {
            statusButton.enabled = false
            statusLabel.text = "运行状态 异常(报修)"
            statusLabel.textColor = Colors.installRedColor
            checkMarkButton.enabled = false
        }
        
        gonglvLabel.text = String(format: "%@kw", deviceInfo.device_power!)
        fadianLabel.text = String(format: "%@天", deviceInfo.runtime!)
        if (deviceInfo.energy_day == nil || deviceInfo.energy_all == nil) {
            return
        }
        todayElectricLabel.text = String(format: "%@kw", deviceInfo.energy_day!)
        totalElectricLabel.text = String(format: "%@kw", deviceInfo.energy_all!)
        todayMoneyLabel.text = String(format: "%.2f元", deviceInfo.energy_day!.floatValue * 3)
        totalMoneyLabel.text = String(format: "%.2f元", deviceInfo.energy_all!.floatValue * 3)
        todayjianpaiLabel.text = String(format: "%.2f吨", deviceInfo.energy_day!.floatValue * 0.272 / 1000)
        totaljianpaiLabel.text = String(format: "%.2f吨", deviceInfo.energy_all!.floatValue * 0.272 / 1000)
        todayplantLabel.text = String(format: "%.2f棵", deviceInfo.energy_day!.floatValue * 0.272 / 100)
        totalplantLabel.text = String(format: "%.2f棵", deviceInfo.energy_all!.floatValue * 0.272 / 100)
    }
    
    //MARK: 查看发电曲线图
    func viewDetailButtonClicked() {
        let vc = ElectricPicViewController()
        self.pushViewController(vc)
    }
    
    //MARK: 业主
    let yezhuCellReuseIdentifier = "yezhuCellReuseIdentifier"
    func initYeZhuView() {
        yezhuView = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(topView.frame), PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - topView.frame.size.height - 64))
        self.view.addSubview(yezhuView)
        
        let yezhuBottomView = UIView.init(frame: CGRectMake(0, yezhuView.frame.size.height - 50, PhoneUtils.kScreenWidth, 50))
        yezhuBottomView.backgroundColor = UIColor.whiteColor()
        yezhuView.addSubview(yezhuBottomView)
        
        let buttonWidth = (PhoneUtils.kScreenWidth - 5 * 3) / 2
        let buttonHeight = yezhuBottomView.frame.size.height - 5 * 2
        
        let calRoomButton = UIButton.init(type: UIButtonType.Custom)
        calRoomButton.frame = CGRectMake(5, 5, buttonWidth, buttonHeight)
        calRoomButton.setTitle("屋顶评估", forState: UIControlState.Normal)
        calRoomButton.backgroundColor = Colors.installColor
        calRoomButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        calRoomButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge2)
        calRoomButton.addTarget(self, action: #selector(self.calRoomButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        yezhuBottomView.addSubview(calRoomButton)
        
        let soldRoomButton = UIButton.init(type: UIButtonType.Custom)
        soldRoomButton.frame = CGRectMake(5 * 2 + buttonWidth, 5, buttonWidth, buttonHeight)
        soldRoomButton.setTitle("屋顶出租", forState: UIControlState.Normal)
        soldRoomButton.backgroundColor = UIColor.whiteColor()
        soldRoomButton.addTarget(self, action: #selector(self.soldRoomButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        soldRoomButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        soldRoomButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge2)
        soldRoomButton.layer.borderColor = Colors.installColor.CGColor
        soldRoomButton.layer.borderWidth = 0.5
        yezhuBottomView.addSubview(soldRoomButton)
        
        let offSetY : CGFloat = 8
        let scrollViewWidth = PhoneUtils.kScreenWidth
        let scrollViewHeight = offSetY + (520 * scrollViewWidth) / 750
        
        let footerView = UIView.init(frame: CGRectMake(0, 0, scrollViewWidth, scrollViewHeight))
        
        let scrollView = UIScrollView.init(frame: CGRectMake(0, 0, scrollViewWidth, scrollViewHeight))
        let images = ["ic_test_ad001", "ic_test_ad002", "ic_test_ad003", "ic_test_ad004"]
        
        scrollView.contentSize = CGSizeMake(scrollViewWidth * CGFloat(images.count), 0)
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        scrollView.tag = YEZHU_SCROLLVIEW_TAG
        footerView.addSubview(scrollView)
        
        for i in 0..<images.count {
            let imageView = UIImageView.init(frame: CGRectMake(CGFloat(i) * scrollViewWidth, offSetY, scrollViewWidth, scrollViewHeight))
            imageView.image = UIImage(named: images[i])
            scrollView.addSubview(imageView)
        }
        
        yezhuPageControl = UIPageControl.init(frame: CGRectMake(0, footerView.frame.size.height - 20, scrollView.frame.size.width, 20))
        yezhuPageControl.numberOfPages = images.count
        footerView.addSubview(yezhuPageControl)
        
        
        let tableViewHeight = CGRectGetMinY(yezhuBottomView.frame)
        yezhuTableView = UITableView.init(frame: CGRectMake(0, 0, yezhuView.frame.size.width, tableViewHeight), style: UITableViewStyle.Plain)
        yezhuTableView.delegate = self
        yezhuTableView.dataSource = self
        yezhuTableView.backgroundColor = Colors.bkgColor
        yezhuTableView.tag = YEZHU_TABLEVIEW_TAG
        yezhuTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        yezhuView.addSubview(yezhuTableView)
        
        yezhuTableView.tableFooterView = footerView
        
        yezhuTableView.registerClass(YeZhuCell.self, forCellReuseIdentifier: yezhuCellReuseIdentifier)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        if (scrollView.tag == YEZHU_SCROLLVIEW_TAG) {
            yezhuPageControl.currentPage = Int(page)
        } else {
            page
        }
        
    }
    
    func calRoomButtonClicked() {
        let vc = RoofPriceViewController()
        self.pushViewController(vc)
    }
    
    func soldRoomButtonClicked() {
        let vc = LeaseViewController()
        self.pushViewController(vc)
    }
    
    //MARK: 安装商
    let installerCellReuseIdentifier = "installerCellReuseIdentifier"
    func initInstallerView() {
        installView = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(topView.frame), PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - topView.frame.size.height - 64))
        self.view.addSubview(installView)
        
        let installViewBottomView = UIView.init(frame: CGRectMake(0, yezhuView.frame.size.height - 50, PhoneUtils.kScreenWidth, 50))
        installViewBottomView.backgroundColor = UIColor.whiteColor()
        installView.addSubview(installViewBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = installViewBottomView.frame.size.height - 5 * 2
        
        let installerButton = UIButton.init(type: UIButtonType.Custom)
        installerButton.frame = CGRectMake(5, 5, buttonWidth, buttonHeight)
        installerButton.setTitle("申请成为安装商", forState: UIControlState.Normal)
        installerButton.backgroundColor = Colors.installColor
        installerButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        installerButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge2)
        installerButton.addTarget(self, action: #selector(self.wantToBeInstaller), forControlEvents: UIControlEvents.TouchUpInside)
        installViewBottomView.addSubview(installerButton)
        
        let tableViewHeight = CGRectGetMinY(installViewBottomView.frame)
        installTableView = UITableView.init(frame: CGRectMake(0, 0, yezhuView.frame.size.width, tableViewHeight), style: UITableViewStyle.Plain)
        installTableView.delegate = self
        installTableView.dataSource = self
        installTableView.backgroundColor = Colors.bkgColor
        installTableView.tag = INSTALLER_TABLEVIEW_TAG
        installTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        installView.addSubview(installTableView)
        
        installTableView.registerClass(InstallerCell.self, forCellReuseIdentifier: installerCellReuseIdentifier)
    }
    
    func wantToBeInstaller() {
        let vc = ToBeInstallerViewController(nibName: "ToBeInstallerViewController", bundle: nil)
        self.pushViewController(vc)
    }
    
    //MARK: 关于页面
    func initAboutUsView() {
        let nibs = NSBundle.mainBundle().loadNibNamed("ABoutUsView", owner: nil, options: nil)
        aboutUsView = nibs.first as! ABoutUsView
        aboutUsView.frame = UIScreen.mainScreen().bounds
        aboutUsView.addUnderLine()
        aboutUsView.hidden = true
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window!.addSubview(aboutUsView)
    }
    
    //MARK: 业主列表
    func loadUserList() {
        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.userlist(2, province_id: nil, city_id: nil, is_suggest: 1, success: { (userInfos) in
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
    
    //MARK: 安装商列表
    func loadInstallerList() {
        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.getRoofList(1, province_id: nil, city_id: nil, success: { (userInfos) in
            self.hideHud()
            self.installerArray.removeAllObjects()
            if (userInfos.count > 0) {
                self.installerArray.addObject(userInfos.firstObject!)
            }
            self.installTableView.reloadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    /**
     登录页面代理方法--获取验证码
     */
    func getCodeButtonClicked() {
        loginView.hiddenAllKeyBoard()
        loginView.hidden = true
    }
    
    /**
     登录页面代理方法--登录按钮
     
     - parameter phone
     - parameter code
     */
    func loginButtonClicked(phone: String, code: String) {
        if (phone.isEmpty) {
            self.showHint("请输入手机号!")
            return
        }
        if (code.isEmpty) {
            self.showHint("请输入验证码!")
            return
        }
        loginView.hiddenAllKeyBoard()
        self.showHudInView(self.view, hint: "登录中...")
        API.sharedInstance.login(phone, captcha: code, success: { (userinfo) in
            self.hideHud()
            self.showHint("登录成功!")
            self.loginView.hidden = true
            UserDefaultManager.saveString(UserDefaultManager.USER_INFO, value: userinfo.mj_JSONString())
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    func initLeftNavButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "user_icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.leftButtonClicked))
    }
    
    func leftButtonClicked() {
        if (UserDefaultManager.isLogin()) {
            UserDefaultManager.logOut()
            self.showHint("登出成功!")
            return
        }
        loginView.hidden = false
    }
    
    func initRightNavButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "users_icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.rightButtonClicked))
    }
    
    func rightButtonClicked() {
        aboutUsView.hidden = false
    }
    
    //MARK: 登录页面
    func initLoginView() {
        loginView = LoginView(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight))
        loginView.initView()
        loginView.delegate = self
        loginView.hidden = true
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window!.addSubview(loginView)
    }
    
    func initView() {
        let topImageView = UIImageView.init(frame: CGRectMake(0, 0, 40, 40))
        topImageView.image = UIImage.init(named: "ic_home_logo")
        self.navigationItem.titleView = topImageView
        
        let screenWidth = PhoneUtils.kScreenWidth
        let buttonHeigt : CGFloat = 30
        let offSetX : CGFloat = 20
        let offSetY : CGFloat = 15
        let titles = ["业主", "安装商", "发电量", "保险"]
        let buttonWidth = (screenWidth - offSetX * CGFloat(titles.count + 1))  / CGFloat(titles.count)
        
        topView = UIView.init(frame: CGRectMake(0, 64, screenWidth, 60))
        topView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(topView)
        
        for i in 0..<titles.count {
            let startX : CGFloat = CGFloat(i) * buttonWidth + (CGFloat(i) + 1) * offSetX;
            let button = UIButton.init(frame: CGRectMake(startX, offSetY, buttonWidth, buttonHeigt))
            button.setTitle(titles[i], forState: UIControlState.Normal)
            button.setTitleColor(Colors.lightGray, forState: UIControlState.Normal)
            button.setTitleColor(Colors.lightBule, forState: UIControlState.Selected)
            button.layer.cornerRadius = 6
            button.layer.borderColor = Colors.clearColor.CGColor
            button.layer.borderWidth = 0.5
            button.layer.masksToBounds = true
            button.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
            button.tag = i
            button.addTarget(self, action: #selector(self.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            topView.addSubview(button)
            if (i == 0) {
                button.layer.borderColor = Colors.borderWithGray.CGColor
                button.selected = true
            }
            buttons.addObject(button)
        }
    }
    
    func buttonClicked(sender : UIButton) {
        goToTab(sender.tag)
    }
    
    //MARK: tab跳转
    func goToTab(index : NSInteger) {
        for i in 0..<buttons.count {
            let button = buttons[i] as! UIButton
            button.selected = false
            button.layer.borderColor = Colors.clearColor.CGColor
        }
        let sender = buttons[index] as! UIButton
        sender.selected = true
        sender.layer.borderColor = Colors.borderWithGray.CGColor
        
        yezhuView.hidden = true
        installView.hidden = true
        electricView.hidden = true
        safeView.hidden = true
        bindView.hidden = true
        
        if (index == 0) { //业主
            yezhuView.hidden = false
            loadUserList()
        } else if (index == 1) { //安装商
            installView.hidden = false
            loadInstallerList()
        } else if (index == 2) { //发电量
            if (UserDefaultManager.isLogin()) {
                if (UserDefaultManager.getUser()?.device_id != nil) {
                    electricView.hidden = false
                    getDeviceInfo()
                } else {
                    bindView.hidden = false
                }
            } else {
                bindView.hidden = false
            }
        } else if (index == 3) { //保险
            safeView.hidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.tag == YEZHU_TABLEVIEW_TAG) {
            return yezhuArray.count
        } else {
            return installerArray.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (tableView.tag == YEZHU_TABLEVIEW_TAG) {
            return YeZhuCell.cellHeight()
        } else {
            return InstallerCell.cellHeight()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView.tag == YEZHU_TABLEVIEW_TAG) {
            let cell = tableView.dequeueReusableCellWithIdentifier(yezhuCellReuseIdentifier, forIndexPath: indexPath) as! YeZhuCell
            cell.initCell()
            let userInfo = yezhuArray[indexPath.row] as! InstallInfo
            cell.titleLabel.text = userInfo.company_name
            cell.describeLabel.text = userInfo.company_intro
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
            var contract = ""
            if ((userInfo.fullname) != nil) {
                contract = contract + userInfo.fullname!
            }
            if ((userInfo.user_name) != nil) {
                contract = contract + " " + userInfo.user_name!
            }
            cell.contractLabel.text = contract
            if (userInfo.is_installer == 2) {
                cell.tagLabel.text = "已认证"
                cell.tagLabel.textColor = Colors.installColor
            } else {
                cell.tagLabel.text = "未认证"
                cell.tagLabel.textColor = Colors.installRedColor
            }
            return cell
        } else {
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
                describeInfo = describeInfo + "屋顶面积:" + String(userInfo.area_size!) + "㎡"
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
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
