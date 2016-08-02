//
//  API+List.swift
//  SevenThousand
//
//  Created by gejw on 16/7/8.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit
import MJExtension

extension API {
    static func getUserId() -> NSNumber{
        let user = UserDefaultManager.getUser()
        if(user != nil){
            return (user?.user_id)!
        }else{
            return 0
        }
    }
    
    //获取七牛Token
    func qnToken(key : String, success: ((qnInfo: QNInfo) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "qiniu/uptoken"
        let params = [
            "key" : key,
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.post(url, params: newParams, success: { (data) in
            let qnInfo = QNInfo.mj_objectWithKeyValues(data)
            success?(qnInfo : qnInfo)
            }, failure: failure)
    }
    
    //七牛上传文件
    static func uploadData(data : NSData, key : String, token : String, result : (info : QNResponseInfo?, key : String?, resp : NSDictionary?) -> Void) {
        let upManager = QNUploadManager()
        upManager.putData(data, key: key, token: token, complete: { (info, key, resp) in
            result(info: info, key: key, resp: resp)
            }, option: nil)
    }
    
    /**
     登录
     
     - parameter user_name:
     - parameter captcha:
     - parameter success:
     - parameter failure:
     */
    func login(user_name: String, captcha : String, success: ((userinfo: UserInfo) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/login"
        let params = [
            "user_name" : user_name,
            "captcha" : captcha,
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.post(url, params: newParams, success: { (data) in
                let userInfo = UserInfo.mj_objectWithKeyValues(data)
                success?(userinfo : userInfo)
            }, failure: failure)
    }

    /**
     获取设备信息
     
     - parameter device_id:
     - parameter success:
     - parameter failure:
     */
    func deviceInfo(device_id: String, success: ((deviceInfo: DeviceInfo) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "device/info"
        let params = [
            "device_id" : device_id,
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.post(url, params: newParams, success: { (data) in
            let deviceInfo = DeviceInfo.mj_objectWithKeyValues(data)
            success?(deviceInfo : deviceInfo)
            }, failure: failure)
    }
    
    /**
     刷新token
     
     - parameter success:
     - parameter failure:
     */
    func refreshUserToken(success: ((userInfo: UserInfo) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "token/refresh"
        let params = [
            "user_id" : "1",
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.post(url, params: newParams, success: { (data) in
            let userInfo = UserInfo.mj_objectWithKeyValues(data)
            success?(userInfo : userInfo)
            }, failure: failure)
    }
    
    /**
     获得省份列表
     
     - parameter success:
     - parameter failure:
     */
    func provincelist(success: ((provinces: NSArray) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "region/provincelist"
        let params = [
            "user_id" : "1",
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.post(url, params: newParams, success: { (data) in
            let array = ProvinceInfo.mj_objectArrayWithKeyValuesArray(data)
            success?(provinces: array)
            }, failure: failure)
    }
    
    /**
     获得某个省份下的城市列表
     
     - parameter success:
     - parameter failure:
     */
    func citylist(success: ((cities: NSArray) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "region/citylist"
        let params = [
            "user_id" : "1",
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.post(url, params: newParams, success: { (data) in
            let array = CityInfo.mj_objectArrayWithKeyValuesArray(data)
            success?(cities: array)
            }, failure: failure)
    }
    
    
    
}
