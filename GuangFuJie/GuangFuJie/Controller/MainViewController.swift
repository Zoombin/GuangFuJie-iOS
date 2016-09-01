//
//  MainViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/7/30.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController, LoginViewDelegate, UITableViewDelegate, UITableViewDataSource {
    var buttons = NSMutableArray()
    var loginView : LoginView!
    var aboutUsView : ABoutUsView!
    
    var yezhuView : UIView!
    var installView : UIView!
    
    var topView : UIView!
    
    let offSetY : CGFloat = 10
    let offSetX : CGFloat = 10
    
    let YEZHU_TABLEVIEW_TAG = 10001
    let INSTALLER_TABLEVIEW_TAG = 10002
    
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
        
        goToTab(0)
    }
    
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
        
        let tableViewHeight = CGRectGetMinY(yezhuBottomView.frame)
        yezhuTableView = UITableView.init(frame: CGRectMake(0, 0, yezhuView.frame.size.width, tableViewHeight), style: UITableViewStyle.Plain)
        yezhuTableView.delegate = self
        yezhuTableView.dataSource = self
        yezhuTableView.backgroundColor = Colors.bkgColor
        yezhuTableView.tag = YEZHU_TABLEVIEW_TAG
        yezhuTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        yezhuView.addSubview(yezhuTableView)
        
        yezhuTableView.registerClass(YeZhuCell.self, forCellReuseIdentifier: yezhuCellReuseIdentifier)
    }
    
    func calRoomButtonClicked() {
        
    }
    
    func soldRoomButtonClicked() {
        
    }
    
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
        installerButton.addTarget(self, action: #selector(self.calRoomButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
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
        
    }
    
    func initAboutUsView() {
        let nibs = NSBundle.mainBundle().loadNibNamed("ABoutUsView", owner: nil, options: nil)
        aboutUsView = nibs.first as! ABoutUsView
        aboutUsView.frame = UIScreen.mainScreen().bounds
        aboutUsView.addUnderLine()
        aboutUsView.hidden = true
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window!.addSubview(aboutUsView)
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
        
        if (index == 0) { //业主
            yezhuView.hidden = false
            loadUserList()
        } else if (index == 1) { //安装商
            installView.hidden = false
            loadInstallerList()
        } else if (index == 2) { //发电量
            
        } else if (index == 3) { //保险
            
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
