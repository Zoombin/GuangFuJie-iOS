//
//  DiTuiApplyViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/11/2.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class DiTuiHomeV2ViewController: BaseViewController {
    var loginButton: UIButton!
    var userNameLabel: UILabel!
    var statusButton: UIButton!
    
    var dituiButton: UIButton!
    var yezhuButton: UIButton!
    var anzhuangButton: UIButton!
    var jiamengButton: UIButton!
    
    var contentScrollView: UIScrollView!
    
    let times = YCPhoneUtils.screenWidth / 375
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        addHeaderView()
    }
    
    func initView() {
        contentScrollView = UIScrollView.init(frame: CGRect(x: 0, y: self.navigationBarAndStatusBarHeight(), width: YCPhoneUtils.screenWidth, height: YCPhoneUtils.screenHeight - self.navigationBarAndStatusBarHeight()))
        self.view.addSubview(contentScrollView)
    }
    
    func addHeaderView() {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 163 * times))
        headerView.backgroundColor = self.view.backgroundColor
        contentScrollView.addSubview(headerView)
        
        let topView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 163 * times))
        topView.backgroundColor = Colors.appBlue
        headerView.addSubview(topView)
        
        let imgs = ["ic_my_role_jiamengshang", "ic_my_role_anzhuangshang", "ic_my_role_yezhu", "ic_my_role_ditui"]
        let titles = ["加盟商", "安装商", "业主", "地推"]
        for i in 0..<imgs.count {
            let button = UIButton.init(type: UIButtonType.custom)
            button.frame = CGRect(x: PhoneUtils.kScreenWidth - 70 * times, y: CGFloat(i) * 28 * times, width: 70 * times, height: 28 * times)
            button.setBackgroundImage(UIImage(named: imgs[i]), for: UIControlState.normal)
            button.setTitle(titles[i], for: UIControlState.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
            button.setTitleColor(UIColor.white, for: UIControlState.normal)
            button.isHidden = true
            headerView.addSubview(button)
            
            if (i == 0) {
                jiamengButton = button
            } else if (i == 1) {
                anzhuangButton = button
            } else if (i == 2) {
                yezhuButton = button
            } else {
                dituiButton = button
            }
        }
        
        let avatarImage = UIImageView.init(frame: CGRect(x: 10 * times, y: (163 - 74) / 2 * times, width: 74 * times, height: 74 * times))
        avatarImage.image = UIImage(named: "ic_avatar")
        topView.addSubview(avatarImage)
        
        userNameLabel = UILabel.init(frame: CGRect(x: avatarImage.frame.maxX + 10 * times, y: 57 * times, width: 100 * times, height: 27 * times))
        userNameLabel.textColor = UIColor.white
        userNameLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        userNameLabel.isHidden = true
        topView.addSubview(userNameLabel)
        
        loginButton = UIButton.init(frame: CGRect(x: avatarImage.frame.maxX + 10 * times, y: (163 - 27) * times / 2, width: 100 * times, height: 27 * times))
        loginButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 17))
        loginButton.setTitle("点击登录", for: UIControlState.normal)
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: UIControlEvents.touchUpInside)
        loginButton.isHidden = true
        topView.addSubview(loginButton)
        
        statusButton = UIButton.init(frame: CGRect(x: avatarImage.frame.maxX + 10 * times, y: 86 * times, width: 110 * times, height: 27 * times))
        statusButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        statusButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        statusButton.setTitle("申请成为地推", for: UIControlState.normal)
        statusButton.addTarget(self, action: #selector(self.statusButtonClicked), for: UIControlEvents.touchUpInside)
        statusButton.backgroundColor = Colors.applyGreen
        statusButton.isHidden = true
        topView.addSubview(statusButton)
    }
    
    func statusButtonClicked() {
        let role = YCStringUtils.getNumber(UserDefaultManager.getUser()!.identity)
        if (role == 0) {
            //普通人
            print("申请地推")
            applyDiTui()
        } else if (role == 3) {
            //地推
            print("申请业主")
            applyYeZhu()
        } else if (role == 4) {
            //业主
            print("申请安装商")
            applyAnZhuang()
        } else if (role == 1) {
            //安装商
            print("申请加盟商")
            applyJiaMeng()
        }
    }
    
    func loginButtonClicked() {
        if (UserDefaultManager.isLogin() == true) {
            return
        }
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        self.pushViewController(sb.instantiateViewController(withIdentifier: "LoginViewController"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshUserInfo()
    }
    
    func refreshUserInfo() {
        if (!UserDefaultManager.isLogin()) {
            self.refreshUserStatus()
            return
        }
        API.sharedInstance.getUserInfo({ (userinfo) in
            UserDefaultManager.saveString(UserDefaultManager.USER_INFO, value: userinfo.mj_JSONString())
            self.refreshUserStatus()
        }) { (msg) in
            
        }
    }
    
    func refreshUserStatus() {
        resetRolesBtn()
        if (UserDefaultManager.isLogin()) {
            loginButton.isHidden = true
            userNameLabel.text = UserDefaultManager.getUser()?.user_name
            userNameLabel.isHidden = false
            statusButton.isHidden = false
            //身份  普通人 --> 地推(3)-->  业主(4)  --> 安装商(1)  --> 加盟商(2)
            let role = YCStringUtils.getNumber(UserDefaultManager.getUser()!.identity)
            userNameLabel.frame = CGRect(x: userNameLabel.frame.origin.x, y: 57 * times, width: userNameLabel.frame.size.width, height: userNameLabel.frame.size.height)
            if (role == 0) {
                //普通人
                statusButton.setTitle("申请成为地推", for: UIControlState.normal)
            } else if (role == 3) {
                //地推
                statusButton.setTitle("申请成为业主", for: UIControlState.normal)
            } else if (role == 4) {
                //业主
                statusButton.setTitle("申请成为安装商", for: UIControlState.normal)
            } else if (role == 1) {
                //安装商
                statusButton.setTitle("申请成为加盟商", for: UIControlState.normal)
            } else if (role == 2) {
                //加盟商
                statusButton.isHidden = true
                userNameLabel.frame = CGRect(x: userNameLabel.frame.origin.x, y: (163 * times - userNameLabel.frame.size.height) / 2, width: userNameLabel.frame.size.width, height: userNameLabel.frame.size.height)
            }
        } else {
            loginButton.isHidden = false
            userNameLabel.text = ""
            userNameLabel.isHidden = true
            statusButton.isHidden = true
        }
    }
    
    func resetRolesBtn() {
        dituiButton.isHidden = true
        yezhuButton.isHidden = true
        anzhuangButton.isHidden = true
        jiamengButton.isHidden = true
        if (!UserDefaultManager.isLogin()) {
            return
        }
        let role = YCStringUtils.getNumber(UserDefaultManager.getUser()!.identity)
        if (role == 0) {
            //普通人
        } else if (role == 3) {
            //地推
            dituiButton.isHidden = false
            dituiButton.frame = CGRect(x: dituiButton.frame.minX, y: (163 * times - dituiButton.frame.height) / 2, width: dituiButton.frame.width, height: dituiButton.frame.height)
        } else if (role == 4) {
            //业主
            dituiButton.isHidden = false
            yezhuButton.isHidden = false
            yezhuButton.frame = CGRect(x: dituiButton.frame.minX, y: (163 * times - dituiButton.frame.height * 2) / 2, width: dituiButton.frame.width, height: dituiButton.frame.height)
            dituiButton.frame = CGRect(x: dituiButton.frame.minX, y: yezhuButton.frame.maxY, width: dituiButton.frame.width, height: dituiButton.frame.height)
        } else if (role == 1) {
            //安装商
            dituiButton.isHidden = false
            yezhuButton.isHidden = false
            anzhuangButton.isHidden = false
            anzhuangButton.frame = CGRect(x: dituiButton.frame.minX, y: (163 * times - dituiButton.frame.height * 3) / 2, width: dituiButton.frame.width, height: dituiButton.frame.height)
            yezhuButton.frame = CGRect(x: dituiButton.frame.minX, y: anzhuangButton.frame.maxY, width: dituiButton.frame.width, height: dituiButton.frame.height)
            dituiButton.frame = CGRect(x: dituiButton.frame.minX, y: yezhuButton.frame.maxY, width: dituiButton.frame.width, height: dituiButton.frame.height)
        } else if (role == 2) {
            //加盟商
            dituiButton.isHidden = false
            yezhuButton.isHidden = false
            anzhuangButton.isHidden = false
            jiamengButton.isHidden = false
            jiamengButton.frame = CGRect(x: dituiButton.frame.minX, y: (163 * times - dituiButton.frame.height * 4) / 2, width: dituiButton.frame.width, height: dituiButton.frame.height)
            anzhuangButton.frame = CGRect(x: dituiButton.frame.minX, y: jiamengButton.frame.maxY, width: dituiButton.frame.width, height: dituiButton.frame.height)
            yezhuButton.frame = CGRect(x: dituiButton.frame.minX, y: anzhuangButton.frame.maxY, width: dituiButton.frame.width, height: dituiButton.frame.height)
            dituiButton.frame = CGRect(x: dituiButton.frame.minX, y: yezhuButton.frame.maxY, width: dituiButton.frame.width, height: dituiButton.frame.height)
        }
    }
}
