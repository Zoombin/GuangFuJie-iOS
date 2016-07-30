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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "光伏街"
        // Do any additional setup after loading the view.
        initLeftNavButton()
        initRightNavButton()
        
        initView()
        initLoginView()
    }
    
    /**
     登录页面代理方法--注册
     */
    func registerButtonClicked() {
        loginView.hidden = true
        let registerVC = RegisterViewController.init(nibName: "RegisterViewController", bundle: nil)
        self.pushViewController(registerVC)
    }
    
    /**
     登录页面代理方法--忘记密码
     */
    func forgetPasswordButtonClicked() {
        loginView.hidden = true
        
    }
    
    func initLeftNavButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "user_icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.leftButtonClicked))
    }
    
    func leftButtonClicked() {
        loginView.hidden = false
    }
    
    func initRightNavButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "users_icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.rightButtonClicked))
    }
    
    func rightButtonClicked() {
        
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
            print(i)
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
        
        let earnCalButton = UIButton.init(frame: CGRectMake(0, topView.frame.size.height / 2, bottomButtonWidth, buttonHeigt))
        earnCalButton.setTitle("收益计算", forState: UIControlState.Normal)
        earnCalButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        earnCalButton.setImage(UIImage(named: "money_cal"), forState: UIControlState.Normal)
        earnCalButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        earnCalButton.setTitleColor(Colors.lightGray, forState: UIControlState.Normal)
        earnCalButton.addTarget(self, action: #selector(self.earnCaluateButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        topView.addSubview(earnCalButton)
        
        let contactUsButton = UIButton.init(frame: CGRectMake(bottomButtonWidth, topView.frame.size.height / 2, bottomButtonWidth, buttonHeigt))
        contactUsButton.setTitle("联系我们", forState: UIControlState.Normal)
        contactUsButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        contactUsButton.setImage(UIImage(named: "contact_us"), forState: UIControlState.Normal)
        contactUsButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        contactUsButton.setTitleColor(Colors.lightGray, forState: UIControlState.Normal)
        contactUsButton.addTarget(self, action: #selector(self.contactUsButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        topView.addSubview(contactUsButton)
    }
    
    func earnCaluateButtonClicked() {

    }
    
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
