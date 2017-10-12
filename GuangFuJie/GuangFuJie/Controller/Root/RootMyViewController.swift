//
//  RootMyViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/6.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootMyViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myTableView: UITableView!
    var titles = ["分享光伏街", "技术支持", "关于我们", "系统设置"]
    var imgs = ["ic_my_shareapp", "ic_my_support", "ic_my_about", "ic_my_settings"]
    let times = PhoneUtils.kScreenWidth / 375
    
    var roofCountLabel: UILabel!
    var insuranceCountLabel: UILabel!
    var deviceCountLabel: UILabel!
    var favCountLabel: UILabel!
    
    var loginButton: UIButton!
    var userNameLabel: UILabel!
    var statusButton: UIButton!
    
    //身份  普通人 --> 地推(3)-->  业主(4)  --> 安装商(1)  --> 加盟商(2)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的"
        initView()
        addHeaderView()
        addFootView()
    }
    
    func addHeaderView() {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 243 * times))
        headerView.backgroundColor = self.view.backgroundColor
        myTableView.tableHeaderView = headerView
        
        let topView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 163 * times))
        topView.backgroundColor = Colors.appBlue
        headerView.addSubview(topView)
        
        let avatarImage = UIImageView.init(frame: CGRect(x: 10 * times, y: (163 - 74) / 2 * times, width: 74 * times, height: 74 * times))
        avatarImage.image = UIImage(named: "ic_avatar")
        topView.addSubview(avatarImage)
        
        userNameLabel = UILabel.init(frame: CGRect(x: avatarImage.frame.maxX + 10 * times, y: 57 * times, width: 100 * times, height: 27 * times))
        userNameLabel.textColor = UIColor.white
        userNameLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        topView.addSubview(userNameLabel)
        
        loginButton = UIButton.init(frame: CGRect(x: avatarImage.frame.maxX + 10 * times, y: (163 - 27) * times / 2, width: 100 * times, height: 27 * times))
        loginButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 17))
        loginButton.setTitle("点击登录", for: UIControlState.normal)
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: UIControlEvents.touchUpInside)
        topView.addSubview(loginButton)
        
        statusButton = UIButton.init(frame: CGRect(x: avatarImage.frame.maxX + 10 * times, y: 86 * times, width: 110 * times, height: 27 * times))
        statusButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        statusButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        statusButton.setTitle("申请成为地推", for: UIControlState.normal)
        statusButton.backgroundColor = Colors.applyGreen
        topView.addSubview(statusButton)
        
        let bottomView = UIView.init(frame: CGRect(x: 0, y: topView.frame.maxY, width: PhoneUtils.kScreenWidth, height: 70 * times))
        bottomView.backgroundColor = UIColor.white
        headerView.addSubview(bottomView)
        
        let labelWidth = CGFloat(NSNumber.init(value: Float(PhoneUtils.kScreenWidth / 4)).intValue)
        let labelHeight = 70 * times
        let btnTitles = ["0\n屋顶", "0\n保险", "0\n设备", "0\n收藏"]
        for i in 0..<btnTitles.count {
            let label = UILabel.init(frame: CGRect(x: labelWidth * CGFloat(i), y: 0, width: labelWidth, height: labelHeight))
            label.text = btnTitles[i]
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.textAlignment = NSTextAlignment.center
            label.backgroundColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
            label.tag = i
            bottomView.addSubview(label)
            self.changeLabelColor(label: label)
            YCLineUtils.addRightLine(label, color: Colors.sperateLine, percent: 80)
            
            let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self.menuButtonClicked(gesutre:)))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(gesture)
            
            if (i == 0) {
               roofCountLabel = label
            } else if (i == 1) {
               insuranceCountLabel = label
            } else if (i == 2) {
               deviceCountLabel = label
            } else {
               favCountLabel = label
            }
        }
    }
    
    func addFootView() {
        let logOutButton = UIButton.init(frame: CGRect(x: (PhoneUtils.kScreenWidth - 340 * times) / 2, y: 0, width: 340 * times, height: 43 * times))
        logOutButton.backgroundColor = Colors.appBlue
        logOutButton.setTitle("退出登录", for: UIControlState.normal)
        logOutButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        logOutButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        logOutButton.addTarget(self, action: #selector(self.logOutButtonClicked), for: UIControlEvents.touchUpInside)
        
        let footView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 43 * times))
        footView.addSubview(logOutButton)
        
        myTableView.tableFooterView = footView
    }
    
    func initView() {
        self.automaticallyAdjustsScrollViewInsets = false
        myTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight), style: UITableViewStyle.grouped)
        myTableView.delegate = self
        myTableView.dataSource = self
        self.view.addSubview(myTableView)
        
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellResueIdentifier")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshUserStatus()
    }
    
    func refreshUserStatus() {
        loadMyCount()
        if (UserDefaultManager.isLogin()) {
            loginButton.isHidden = true
            userNameLabel.text = UserDefaultManager.getUser()?.user_name
            userNameLabel.isHidden = false
            statusButton.isHidden = false
            myTableView.tableFooterView?.isHidden = false
        } else {
            loginButton.isHidden = false
            userNameLabel.text = ""
            userNameLabel.isHidden = true
            statusButton.isHidden = true
            myTableView.tableFooterView?.isHidden = true
        }
    }
    
    func loadMyCount() {
        if (UserDefaultManager.isLogin()) {
            API.sharedInstance.userAllCount(success: { (model) in
                self.roofCountLabel.text = "\(model.roofCount!)\n屋顶"
                self.insuranceCountLabel.text = "\(model.insuranceCount!)\n保险"
                self.deviceCountLabel.text = "\(model.deviceCount!)\n设备"
                self.favCountLabel.text = "\(model.favorCount!)\n收藏"
                self.changeAllLabelColor()
            }) { (msg) in
                
            }
        } else {
            roofCountLabel.text = "0\n屋顶"
            insuranceCountLabel.text = "0\n保险"
            deviceCountLabel.text = "0\n设备"
            favCountLabel.text = "0\n收藏"
            self.changeAllLabelColor()
        }
    }
    
    func changeAllLabelColor() {
        self.changeLabelColor(label: roofCountLabel)
        self.changeLabelColor(label: insuranceCountLabel)
        self.changeLabelColor(label: deviceCountLabel)
        self.changeLabelColor(label: favCountLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.tabBarItem.selectedImage = self.tabBarItem.selectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellResueIdentifier", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        cell.imageView?.image = UIImage(named: imgs[indexPath.row])
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.row == 0) {
            //分享光伏街
            shareApp()
        } else if (indexPath.row == 1) {
            //技术支持
            let vc = GFJWebViewController()
            vc.url = "http://www.pvsr.cn"
            vc.title = "技术支持"
            self.pushViewController(vc)
        } else if (indexPath.row == 2) {
            //关于我们
            let vc = GFJWebViewController()
            vc.title = "关于我们"
            vc.urlTag = 0
            self.pushViewController(vc)
        } else if (indexPath.row == 3) {
            //设置
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "SettingsViewController")
            self.pushViewController(vc)
        }
    }
    
    func loginButtonClicked() {
        if (UserDefaultManager.isLogin() == true) {
            return
        }
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        self.pushViewController(sb.instantiateViewController(withIdentifier: "LoginViewController"))
    }
    
    func logOutButtonClicked() {
        let alertView = UIAlertController.init(title: "提示", message: "您确定要登出吗？", preferredStyle: UIAlertControllerStyle.alert)
        let sureAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (action) in
            UserDefaultManager.logOut()
            self.refreshUserStatus()
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
            
        }
        alertView.addAction(sureAction)
        alertView.addAction(cancelAction)
        self.present(alertView, animated: true, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeLabelColor(label: UILabel) {
        let text = NSString.init(string: label.text!)
        let numLength = text.length - 2
        let attrString = NSMutableAttributedString.init(string: label.text!)
        attrString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15)), range: NSMakeRange(0, text.length))
        attrString.addAttribute(NSForegroundColorAttributeName, value: Colors.appBlue, range: NSMakeRange(0, numLength))
        label.attributedText = attrString
    }
    
    func menuButtonClicked(gesutre: UIGestureRecognizer) {
        if (shouldShowLogin()) {
            return
        }
        if (gesutre.view?.tag == 0) {
            showRoofList()
        } else if (gesutre.view?.tag == 1) {
            showInsuranceList()
        } else if (gesutre.view?.tag == 2) {
            showDeviceList()
        } else {
            showFavList()
        }
    }
    
    func showRoofList() {
        
    }
    
    func showInsuranceList() {
        let vc = MyInsuranceListViewController()
        self.pushViewController(vc)
    }
    
    func showDeviceList() {
        let vc = MyDeviceListControllerViewController()
        self.pushViewController(vc)
    }
    
    func showFavList() {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
