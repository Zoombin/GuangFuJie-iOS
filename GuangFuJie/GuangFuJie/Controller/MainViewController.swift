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
    
    var yezhuView : UIView!
    var loanView : UIView!
    var safeView : UIView!
    
    var topView : UIView!
    
    let offSetY : CGFloat = 10
    let offSetX : CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initLeftNavButton()
        initRightNavButton()
        
        initView()
        initLoginView()
        initAboutUsView()
        
        initYeZhuView()
        initLoanView()
        initSafeView()
    }
    
    func initYeZhuView() {
        yezhuView = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(topView.frame), PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - topView.frame.size.height - 64))
        self.view.addSubview(yezhuView)
        
        let imgWidth = PhoneUtils.kScreenWidth
        let imgHeight = (315 * imgWidth) / 640
        
        let adView = UIImageView.init(frame: CGRectMake(0, offSetY, imgWidth, imgHeight))
        adView.image = UIImage(named: "adbkg")
        yezhuView.addSubview(adView)
    
        let yezhuBottomView = UIView.init(frame: CGRectMake(0, yezhuView.frame.size.height - 50, PhoneUtils.kScreenWidth, 50))
        yezhuBottomView.backgroundColor = UIColor.whiteColor()
        yezhuView.addSubview(yezhuBottomView)
        
        
        let buttonWidth = (PhoneUtils.kScreenWidth - 5 * 3) / 2
        let buttonHeight = yezhuBottomView.frame.size.height - 5 * 2
        
        let installButton = UIButton.init(type: UIButtonType.Custom)
        installButton.frame = CGRectMake(5, 5, buttonWidth, buttonHeight)
        installButton.setTitle("我要安装", forState: UIControlState.Normal)
        installButton.backgroundColor = Colors.installColor
        installButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        installButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge2)
        installButton.addTarget(self, action: #selector(self.wantInstallButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        yezhuBottomView.addSubview(installButton)
    
        let daikuaiButton = UIButton.init(type: UIButtonType.Custom)
        daikuaiButton.frame = CGRectMake(5 * 2 + buttonWidth, 5, buttonWidth, buttonHeight)
        daikuaiButton.setTitle("我要贷款", forState: UIControlState.Normal)
        daikuaiButton.backgroundColor = UIColor.whiteColor()
        daikuaiButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        daikuaiButton.layer.borderWidth = 0.5
        daikuaiButton.layer.borderColor = Colors.installColor.CGColor
        daikuaiButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge2)
        daikuaiButton.addTarget(self, action: #selector(self.wantLoanButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        yezhuBottomView.addSubview(daikuaiButton)
    }
    
    func wantInstallButtonClicked() {
        let vc = InstallViewController(nibName: "InstallViewController", bundle: nil)
        self.pushViewController(vc)
    }
    
    func wantLoanButtonClicked() {
        goToTab(2)
    }
    
    func initLoanView() {
        loanView = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(topView.frame), PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - topView.frame.size.height - 64))
        self.view.addSubview(loanView)
        loanView.hidden = true
    }
    
    func initSafeView() {
        safeView = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(topView.frame), PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - topView.frame.size.height - 64))
        self.view.addSubview(safeView)
        safeView.hidden = true
        
        let scrollView = UIScrollView.init(frame: CGRectMake(0, 0, safeView.frame.size.width, safeView.frame.size.height))
        safeView.addSubview(scrollView)
        
        let imgViewWidth = PhoneUtils.kScreenWidth
        let imgViewHeight = (871 * imgViewWidth) / 640
        
        let safeImgView = UIImageView.init(frame: CGRectMake(0, offSetY, imgViewWidth, imgViewHeight))
        safeImgView.image = UIImage(named: "ic_warranty")
        scrollView.addSubview(safeImgView)
        
        let scale : CGFloat = imgViewWidth / 640
        let nameLabel = UILabel.init(frame: CGRectMake((306 / 999) * imgViewWidth, imgViewHeight * (306 / 999), 100, 22 * scale))
        nameLabel.text = "颜超"
        nameLabel.textColor = UIColor.lightGrayColor()
        nameLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        safeImgView.addSubview(nameLabel)
        
        scrollView.contentSize = CGSizeMake(0, safeImgView.frame.size.height + offSetY)
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
        let offSetX : CGFloat = 10
        let offSetY : CGFloat = 5
        let buttonWidth = (screenWidth - offSetX * 6)  / 5
        let titles = ["业主", "安装商", "贷款", "保险", "质保", "售后"]
        
        topView = UIView.init(frame: CGRectMake(0, 64, screenWidth, 80))
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
        let vc = ContactUsViewController()
        self.pushViewController(vc)
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
        loanView.hidden = true
        
        if (index == 0) {
            yezhuView.hidden = false
        } else if (index == 1) {
            
        } else if (index == 2) {
            loanView.hidden = false
        } else if (index == 3) {
            safeView.hidden = false
        } else if (index == 4) {
            
        }
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
