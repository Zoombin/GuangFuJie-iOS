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
    func getUserId() -> NSNumber{
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
    func uploadData(data : NSData, key : String, token : String, result : (info : QNResponseInfo?, key : String?, resp : NSDictionary?) -> Void) {
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
            "user_id" : getUserId(),
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
            "user_id" : getUserId(),
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
            "user_id" : getUserId(),
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.post(url, params: newParams, success: { (data) in
            let array = CityInfo.mj_objectArrayWithKeyValuesArray(data)
            success?(cities: array)
            }, failure: failure)
    }
    
    /**
     app强制升级
     
     - parameter success:
     - parameter failure: 
     */
    func appupgrade(success: ((appModel: AppModel) -> Void)?, failure: ((msg: String?) -> Void)?){
        let url = Constants.httpHost + "app/upgrade";
        let params = [
            "device_type" : Constants.osType,
            "version" : PhoneUtils.getBuildId(),
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.post(url, params: newParams, success: { (data) in
            let appModel = AppModel.mj_objectWithKeyValues(data)
            success?(appModel : appModel)
            }, failure: failure)
    }
    
    /**
     预约安装
     
     - parameter province_id:
     - parameter city_id:
     - parameter area_size:
     - parameter is_loan:
     - parameter success:
     - parameter failure:
     */
    func bookingAdd(province_id : NSNumber, city_id : NSNumber, area_size : NSNumber, is_loan : NSInteger, success: ((commonModel: CommonModel) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "booking/add";
        let params = [
            "user_id" : getUserId(), // 用户id
            "province_id" : province_id, // 预约时的省份id
            "city_id" : city_id, // 预约时的城市id
            "area_size" : area_size, // 屋顶面积
            "is_loan" : is_loan, // 是否需要贷款 int 0:不需要 1需要
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.post(url, params: newParams, success: { (data) in
            let commonModel = CommonModel.mj_objectWithKeyValues(data)
            success?(commonModel : commonModel)
            }, failure: failure)
    }
    
}
