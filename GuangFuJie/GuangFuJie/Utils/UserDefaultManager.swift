//
//  UserDefaultManager.swift
//  SecurityManager
//
//  Created by 颜超 on 16/3/14.
//  Copyright © 2016年 Yc. All rights reserved.
//

import UIKit

class UserDefaultManager: NSObject {
    static let USER_INFO = "userInfo"
    static let APP_VERSION = "appVersion"
    
    static let userDefault : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    /**保存String数据*/
    static func saveString(key :NSString,value :NSString){
        userDefault.setObject(value, forKey: key as String)
        userDefault.synchronize()
    }
    
    /**获取保存的String数据*/
    static func getString(key :NSString) -> String{
        if(userDefault.objectForKey(key as String) != nil) {
            let value : String = userDefault.objectForKey(key as String) as! String
            return value
        }else{
            return "";
        }
    }
    
    static func getUser() -> UserInfo? {
        if (isLogin()) {
            let userStr = getString(UserDefaultManager.USER_INFO)
            let user = UserInfo.mj_objectWithKeyValues(userStr)
            return user
        }
        return nil
    }
    
    static func clearUserData() {
       userDefault.removeObjectForKey(USER_INFO)
    }
    
    static func logOut() {
        clearUserData()
    }
    
    static func showGuide() -> Bool{
        let version = getString(APP_VERSION)
        if (version != PhoneUtils.appVersion) {
            saveString(APP_VERSION, value: PhoneUtils.appVersion)
            return true
        }
        return false
    }
    
    static func isLogin() -> Bool {
        let userStr = getString(USER_INFO)
        if (userStr == "") {
            return false
        }
        return true
    }
}
