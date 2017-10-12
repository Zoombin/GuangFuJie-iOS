//
//  AppDelegate.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/6.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BMKGeneralDelegate, UIAlertViewDelegate {

    var window: UIWindow?
    var mapManager = BMKMapManager()
    
    var updateUrl = ""
    var normalUpdateTag = 1001 //普通更新
    var focusUpdateTag = 1002  //强制更新

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initSDK()
        return true
    }
    
    func initSDK() {
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
        
        //初始化友盟分享
        UMSocialManager.default().openLog(Constants.isDebug)
        UMSocialManager.default().umSocialAppkey = Constants.umAppKey
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: Constants.wexinAppKey, appSecret: Constants.wexinAppSecret, redirectURL: "http://mobile.umeng.com/social")
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatTimeLine, appKey: Constants.wexinAppKey, appSecret: Constants.wexinAppSecret, redirectURL: "http://mobile.umeng.com/social")
        
        //支付
        BeeCloud.initWithAppID(Constants.payKey, andAppSecret: Constants.paySecret, sandbox: Constants.isSandBox)
        BeeCloud.initWeChatPay(Constants.wexinAppKey)
        
        MQManager.initWithAppkey("36b32361b68d0e9945c01c51a2e2b791") { (clientId, error) in
            if (error != nil) {
                print("美洽 SDK：初始化成功")
            } else {
                print("美洽 SDK：初始化失败")
            }
        }
        
        if (UserDefaultManager.showGuide()) {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "GuideViewController")
            self.window?.rootViewController = vc
        } else {
            initMain()
        }
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
    
    func initMain() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "HomeTabBarController")
        self.window?.rootViewController = vc
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
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

