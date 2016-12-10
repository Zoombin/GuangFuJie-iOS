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
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let ret = mapManager.start(Constants.baiduMapKey, generalDelegate: self)
        if (!ret) {
            print("manager start failed!")
        }
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        
        //支付
        BeeCloud.initWithAppID(Constants.payKey, andAppSecret: Constants.paySecret, sandbox: Constants.isSandBox)
        
        self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        if (UserDefaultManager.showGuide()) {
            showGuide()
        } else {
            initMain()
        }
        return true
    }
    
    func onGetNetworkState(iError: Int32) {
        if (0 == iError) {
            print("联网成功")
        } else{
            print(String(format: "onGetNetworkState %d", iError));
        }
    }
    
    func onGetPermissionState(iError: Int32) {
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
        let nav1 = UINavigationController.init(rootViewController: RootYeZhuViewController())
        let nav2 = UINavigationController.init(rootViewController: RootInstallerViewController())
        let nav3 = UINavigationController.init(rootViewController: RootElectricViewController())
        let nav4 = UINavigationController.init(rootViewController: RootSafeViewController())
        
        tabBarController.viewControllers = [nav1, nav2, nav3, nav4]
        tabBarController.tabBar.hidden = true
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }
    
    //检查更新（只做强制升级用）
    func checkAppVersion() {
        API.sharedInstance.appupgrade({ (appModel) in
            if(appModel.is_upgrade!.integerValue == 2){
                let urlString = appModel.download_url
                self.updateUrl = urlString!
                let alertView = UIAlertView.init(title: "提示", message: "App有更新，是否去更新？", delegate: self, cancelButtonTitle: "确定")
                alertView.tag = self.focusUpdateTag
                alertView.show()
            } else if (appModel.is_upgrade!.integerValue == 1){
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
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (alertView.tag == normalUpdateTag) {
            //普通更新
            if (alertView.cancelButtonIndex != buttonIndex) {
                let url = NSURL(string: updateUrl)
                UIApplication.sharedApplication().openURL(url!)
            }
        } else if (alertView.tag == focusUpdateTag) {
            //强制更新
            let url = NSURL(string: updateUrl)
            UIApplication.sharedApplication().openURL(url!)
        }
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        checkAppVersion()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //支付------
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        if(!BeeCloud.handleOpenUrl(url)){
            //handle其他类型的url
        }
        return true
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if (!BeeCloud.handleOpenUrl(url)) {
            //handle其他类型的url
        }
        return true
    }
    
    
}

