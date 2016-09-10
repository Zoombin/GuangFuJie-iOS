//
//  PhoneUtils.swift
//  Muslim
//
//  Created by LSD on 15/10/30.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class PhoneUtils: NSObject {

    // 屏幕Rect
    static let kScreenRect = UIScreen.mainScreen().bounds
    // 屏幕大小
    static let kScreenSize = UIScreen.mainScreen().bounds.size
    // 屏幕宽度
    static let kScreenWidth = UIScreen.mainScreen().bounds.width
    // 屏幕高度
    static let kScreenHeight = UIScreen.mainScreen().bounds.height

    // 状态栏高度
    static var statusBarHeight: CGFloat {
        return UIApplication.sharedApplication().statusBarFrame.height
    }

    /// app版本
    static var appVersion: String {
        if let infoDictionary = NSBundle.mainBundle().infoDictionary, ver = infoDictionary["CFBundleShortVersionString"] as? String {
            return ver
        }
        return "1.0"
    }
    
    //获取系统BuildId
    static func getBuildId() ->Int{
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        let minorVersion : AnyObject? = infoDictionary! ["CFBundleVersion"]
        let buildId = minorVersion!.integerValue
        return buildId
    }

    /// app编译版本
    static var appBuildVersion: CGFloat {
        if let infoDictionary = NSBundle.mainBundle().infoDictionary, ver = infoDictionary["CFBundleVersion"] as? String {
            return CGFloat((ver as NSString).doubleValue)
        }
        return 1.0
    }

    // 获取当前系统语言
    static var systemLanguage: String {
        if let infoDictionary = NSBundle.mainBundle().infoDictionary, ver = infoDictionary["AppleLanguages"] as? [String] where ver.count > 0 {
            return ver[0]
        }
        return ""
    }
    
    //获取明天时间
    static func getTommorrowDateStr(date : NSDate) -> String{
        let currentDate = date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDateStr = currentDate.timeIntervalSince1970
        let tommorrowDateStr = currentDateStr + 24 * 3600
        let tommorrowDate = NSDate.init(timeIntervalSince1970: tommorrowDateStr)
        return dateFormatter.stringFromDate(tommorrowDate)
    }
}
