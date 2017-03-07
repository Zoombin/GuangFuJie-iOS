//
//  AppDelegate.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/5/4.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BMKGeneralDelegate, UIAlertViewDelegate {
    
    var window: UIWindow?
    var mapManager = BMKMapManager()
    var updateUrl = ""
    
    var tabBarController = UITabBarController()
    var normalUpdateTag = 1001 //普通更新
    var focusUpdateTag = 1002  //强制更新
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let ret = mapManager.start(Constants.baiduMapKey, generalDelegate: self)
        if (!ret) {
            print("manager start failed!")
        }
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        
        if (!Constants.isSandBox) {
            MobClick.setCrashReportEnabled(true)
            MobClick.setLogEnabled(true)
            MobClick.setAppVersion(PhoneUtils.appVersion)
            MobClick.start(withAppkey: Constants.umAppKey)
            MobClick.updateOnlineConfig()
        }
        
        UMSocialData.setAppKey(Constants.umAppKey)
        UMSocialWechatHandler.setWXAppId(Constants.wexinAppKey, appSecret: Constants.wexinAppSecret, url: "http://www.umeng.com/social")
        
        //支付
        BeeCloud.initWithAppID(Constants.payKey, andAppSecret: Constants.paySecret, sandbox: Constants.isSandBox)
        BeeCloud.initWeChatPay(Constants.wexinAppKey)
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.9)
        if (UserDefaultManager.showGuide()) {
            showGuide()
        } else {
            initMain()
        }
        return true
    }
    
    func onGetNetworkState(_ iError: Int32) {
        if (0 == iError) {
            print("联网成功")
        } else{
            print(String(format: "onGetNetworkState %d", iError));
        }
    }
    
    func onGetPermissionState(_ iError: Int32) {
        if (0 == iError) {
            print("授权成功")
        } else{
            print(String(format: "onGetPermissionState %d", iError));
        }
    }
    
    func showGuide() {
        let vc = GuideViewController()
        let nav = UINavigationController.init(rootViewController: vc)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    func initMain() {
        //找安装商
        let nav1 = UINavigationController.init(rootViewController: RootInstallerViewController())
        nav1.tabBarItem.title = Texts.tab1
        nav1.tabBarItem.image = UIImage.init(named: "ic_tab_roof")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        nav1.tabBarItem.selectedImage = UIImage.init(named: "ic_tab_roof_hl")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        nav1.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: Colors.lightBule], for: UIControlState.selected)
        
        //找屋顶
        let nav2 = UINavigationController.init(rootViewController: RootYeZhuViewController())
        nav2.tabBarItem.title = Texts.tab2
        nav2.tabBarItem.image = UIImage.init(named: "ic_tab_installer")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        nav2.tabBarItem.selectedImage = UIImage.init(named: "ic_tab_installer_hl")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        nav2.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: Colors.lightBule], for: UIControlState.selected)
        
        //查发电量
        let nav3 = UINavigationController.init(rootViewController: RootElectricViewController())
        nav3.tabBarItem.title = Texts.tab3
        nav3.tabBarItem.image = UIImage.init(named: "ic_tab_electric")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        nav3.tabBarItem.selectedImage = UIImage.init(named: "ic_tab_electric_hl")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        nav3.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: Colors.lightBule], for: UIControlState.selected)
        
        //保险
        let nav4 = UINavigationController.init(rootViewController: RootSafeViewController())
        nav4.tabBarItem.title = Texts.tab4
        nav4.tabBarItem.image = UIImage.init(named: "ic_tab_safe")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        nav4.tabBarItem.selectedImage = UIImage.init(named: "ic_tab_safe_hl")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        nav4.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: Colors.lightBule], for: UIControlState.selected)
        
        //资讯
        let nav5 = UINavigationController.init(rootViewController: RootNewsViewController())
        nav5.tabBarItem.title = Texts.tab5
        nav5.tabBarItem.image = UIImage.init(named: "ic_tab_news")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        nav5.tabBarItem.selectedImage = UIImage.init(named: "ic_tab_news_hl")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        nav5.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: Colors.lightBule], for: UIControlState.selected)
        
        tabBarController.viewControllers = [nav1, nav2, nav3, nav4, nav5]
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }
    
    func refreshUserInfo() {
        if (!UserDefaultManager.isLogin()) {
            return
        }
        API.sharedInstance.getUserInfo({ (userinfo) in
              UserDefaultManager.saveString(UserDefaultManager.USER_INFO, value: userinfo.mj_JSONString())
            }) { (msg) in
                
        }
    }
    
    //检查更新（只做强制升级用）
    func checkAppVersion() {
        API.sharedInstance.appupgrade({ (appModel) in
            if(appModel.is_upgrade!.intValue == 2){
                let urlString = appModel.download_url
                self.updateUrl = urlString!
                let alertView = UIAlertView.init(title: "提示", message: "App有更新，是否去更新？", delegate: self, cancelButtonTitle: "确定")
                alertView.tag = self.focusUpdateTag
                alertView.show()
            } else if (appModel.is_upgrade!.intValue == 1){
                let urlString = appModel.download_url
                self.updateUrl = urlString!
                let alertView = UIAlertView.init(title: "提示", message: "App有更新，是否去更新？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                alertView.tag = self.normalUpdateTag
                alertView.show()
            }
        }) { (msg) in
            print(msg)
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if (alertView.tag == normalUpdateTag) {
            //普通更新
            if (alertView.cancelButtonIndex != buttonIndex) {
                let url = URL(string: updateUrl)
                UIApplication.shared.openURL(url! as URL)
            }
        } else if (alertView.tag == focusUpdateTag) {
            //强制更新
            let url = URL(string: updateUrl)
            UIApplication.shared.openURL(url! as URL)
        }
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        checkAppVersion()
        refreshUserInfo()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //支付------
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        if(!BeeCloud.handleOpen(url as URL!)){
            //handle其他类型的url
        }
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if (!BeeCloud.handleOpen(url as URL!)) {
            //handle其他类型的url
        }
        return true
    }
    
    
}

