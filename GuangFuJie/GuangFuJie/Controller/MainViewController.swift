//
//  MainViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/7/30.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController, LoginViewDelegate {
    var buttons = NSMutableArray()
    var loginView : LoginView!
    var aboutUsView : ABoutUsView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "光伏街"
        // Do any additional setup after loading the view.
        initLeftNavButton()
        initRightNavButton()
        
        initView()
        initLoginView()
        initAboutUsView()
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
    
    /**
     登录页面代理方法--获取验证码
     */
    func getCodeButtonClicked() {
        loginView.hiddenAllKeyBoard()
        loginView.hidden = true
        let vc = InstallViewController.init(nibName: "InstallViewController", bundle: nil)
        self.pushViewController(vc)
    }
    
    /**
     登录页面代理方法--登录按钮
     
     - parameter phone
     - parameter code
     */
    func loginButtonClicked(phone: String, code: String) {
        if (phone.isEmpty) {
            self.showHint("请输入账号!")
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
        let screenWidth = PhoneUtils.kScreenWidth
        let buttonHeigt : CGFloat = 30
        let offSetX : CGFloat = 10
        let offSetY : CGFloat = 5
        let buttonWidth = (screenWidth - offSetX * 6)  / 5
        let titles = ["业主", "贷款", "保险", "质保", "售后"]
        
        let topView = UIView.init(frame: CGRectMake(0, 64, screenWidth, 80))
        topView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(topView)
        
        for i in 0..<titles.count {
            let button = UIButton.init(frame: CGRectMake(CGFloat(i) * buttonWidth + (CGFloat(i) + 1) * offSetX, offSetY, buttonWidth, buttonHeigt))
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
        
        let bottomButtonWidth = screenWidth / 4
        
        let earnCalButton = UIButton.init(frame: CGRectMake(0, offSetY + topView.frame.size.height / 2, bottomButtonWidth, buttonHeigt))
        earnCalButton.setTitle("收益计算", forState: UIControlState.Normal)
        earnCalButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        earnCalButton.setImage(UIImage(named: "money_cal"), forState: UIControlState.Normal)
        earnCalButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        earnCalButton.setTitleColor(Colors.lightGray, forState: UIControlState.Normal)
        earnCalButton.addTarget(self, action: #selector(self.earnCaluateButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        topView.addSubview(earnCalButton)
        
        let contactUsButton = UIButton.init(frame: CGRectMake(bottomButtonWidth, offSetY + topView.frame.size.height / 2, bottomButtonWidth, buttonHeigt))
        contactUsButton.setTitle("联系我们", forState: UIControlState.Normal)
        contactUsButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        contactUsButton.setImage(UIImage(named: "contact_us"), forState: UIControlState.Normal)
        contactUsButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        contactUsButton.setTitleColor(Colors.lightGray, forState: UIControlState.Normal)
        contactUsButton.addTarget(self, action: #selector(self.contactUsButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        topView.addSubview(contactUsButton)
    }
    
    /**
     收益计算按钮
     */
    func earnCaluateButtonClicked() {
        let earnCalVC = EarnCalViewController.init(nibName: "EarnCalViewController", bundle: nil)
        self.pushViewController(earnCalVC)
    }
    
    /**
     联系我们按钮
     */
    func contactUsButtonClicked() {
        
    }
    
    func buttonClicked(sender : UIButton) {
        for i in 0..<buttons.count {
            let button = buttons[i] as! UIButton
            button.selected = false
            button.layer.borderColor = Colors.clearColor.CGColor
        }
        sender.selected = true
        sender.layer.borderColor = Colors.borderWithGray.CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
