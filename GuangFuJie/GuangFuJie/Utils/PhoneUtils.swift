//
//  PhoneUtils.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/6.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class PhoneUtils: NSObject {
    
    // 屏幕Rect
    static let kScreenRect = UIScreen.main.bounds
    // 屏幕大小
    static let kScreenSize = UIScreen.main.bounds.size
    // 屏幕宽度
    static let kScreenWidth = UIScreen.main.bounds.width
    // 屏幕高度
    static let kScreenHeight = UIScreen.main.bounds.height
    
    // 状态栏高度
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    /// app版本
    static var appVersion: String {
        if let infoDictionary = Bundle.main.infoDictionary, let ver = infoDictionary["CFBundleShortVersionString"] as? String {
            return ver
        }
        return "1.0"
    }
    
    //获取系统BuildId
    static func getBuildId() -> String{
        let infoDictionary = Bundle.main.infoDictionary
        let minorVersion : AnyObject? = infoDictionary!["CFBundleVersion"] as AnyObject?
        let buildId = minorVersion as! String
        return buildId
    }
    
    /// app编译版本
    static var appBuildVersion: CGFloat {
        if let infoDictionary = Bundle.main.infoDictionary, let ver = infoDictionary["CFBundleVersion"] as? String {
            return CGFloat((ver as NSString).doubleValue)
        }
        return 1.0
    }
    
    // 获取当前系统语言
    static var systemLanguage: String {
        if let infoDictionary = Bundle.main.infoDictionary, let ver = infoDictionary["AppleLanguages"] as? [String], ver.count > 0 {
            return ver[0]
        }
        return ""
    }
    
    //获取明天时间
    static func getTommorrowDateStr(_ date : Date) -> String{
        let currentDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDateStr = currentDate.timeIntervalSince1970
        let tommorrowDateStr = currentDateStr + 24 * 3600
        let tommorrowDate = Date.init(timeIntervalSince1970: tommorrowDateStr)
        return dateFormatter.string(from: tommorrowDate as Date)
    }
}
