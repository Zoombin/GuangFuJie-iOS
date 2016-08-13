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
    
    /**
     银行列表
     
     - parameter success:
     - parameter failure:
     */
    func bankList(success: ((bankInfo: BankInfo) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "bank/list";
        let params = [
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.post(url, params: newParams, success: { (data) in
            let bankInfo = BankInfo.mj_objectWithKeyValues(data)
            success?(bankInfo : bankInfo)
            }, failure: failure)
    }
    
    /**
     填写贷款资料
     
     - parameter bank_id:
     - parameter fullname:
     - parameter phone:
     - parameter id_no:
     - parameter id_image1:
     - parameter id_image2:
     - parameter province_id:
     - parameter city_id:
     - parameter address:
     - parameter family_images:
     - parameter success:
     - parameter failure:
     */
    func loanInfoAdd(bank_id : NSNumber,fullname : String, phone : String, id_no : String, id_image1 : String, id_image2 : String, province_id : NSNumber, city_id : NSNumber, address : String, family_images : String, success: ((commonModel: CommonModel) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "booking/add";
        let params = [
            "user_id" : getUserId(),        // 用户id
            "bank_id" : bank_id,         // 银行id
            "fullname" : fullname,        // 姓名
            "phone" : phone,          // 手机号
            "id_no" : id_no,           // 身份证号
            "id_image1" : id_image1,       // 身份证正面图片url
            "id_image2" : id_image2,       // 身份证反面图片url
            "province_id" : province_id,     // 电站所在的省份id
            "city_id" : city_id,         // 电站所在的城市id
            "address" : address,         // 电站所在的详细地址
            "family_images" : family_images,   // 家庭电站图片, 多个用逗号隔开
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
