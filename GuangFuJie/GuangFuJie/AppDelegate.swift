//
//  AppDelegate.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/5/4.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BMKGeneralDelegate {

    var window: UIWindow?
    var mapManager = BMKMapManager()

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
        let mainVC = MainViewController.init(nibName: "MainViewController", bundle: nil)
        let nav = UINavigationController.init(rootViewController: mainVC)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
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

