//
//  UserDefaultManager.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/6.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class UserDefaultManager: NSObject {
    static let USER_INFO = "userInfo"
    static let APP_VERSION = "appVersion"
    static let USER_LOCATION = "currentLocation"
    
    static let userDefault : UserDefaults = UserDefaults.standard
    
    /**保存String数据*/
    static func saveString(_ key :String,value :String){
        userDefault.set(value, forKey: key as String)
        userDefault.synchronize()
    }
    
    /**获取保存的String数据*/
    static func getString(_ key :String) -> String{
        if(userDefault.object(forKey: key as String) != nil) {
            let value : String = userDefault.object(forKey: key as String) as! String
            return value
        }else{
            return "";
        }
    }
    
    static func getUser() -> UserInfo? {
        if (isLogin()) {
            let userStr = getString(UserDefaultManager.USER_INFO)
            let user = UserInfo.mj_object(withKeyValues: userStr)
            return user
        }
        return nil
    }
    
    static func getLocation() -> LocationInfo? {
        let locationStr = getString(UserDefaultManager.USER_LOCATION)
        if (locationStr == "") {
            return nil
        } else {
            let locationInfo = LocationInfo.mj_object(withKeyValues: locationStr)
            return locationInfo
        }
    }
    
    static func clearUserData() {
        userDefault.removeObject(forKey: USER_INFO)
    }
    
    static func clearLocationData() {
        userDefault.removeObject(forKey: USER_LOCATION)
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
