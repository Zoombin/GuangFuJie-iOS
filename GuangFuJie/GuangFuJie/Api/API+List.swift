//
//  API+List.swift
//  SevenThousand
//
//  Created by gejw on 16/7/8.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

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
    func qnToken(_ key : String, success: ((_ qnInfo: QNInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "qiniu/uptoken"
        let params = [
            "key" : key,
            "_o" : 1
        ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let qnInfo = QNInfo.mj_object(withKeyValues: data)
            success?(qnInfo!)
            }, failure: failure)
    }
    
    //七牛上传文件
    func uploadData(_ data : Data, key : String, token : String, success : @escaping (QNResultInfo) -> Void) {
        let upManager = QNUploadManager()
        upManager?.put(data, key: key, token: token, complete: { (info, key, resp) in
            let resultInfo = QNResultInfo()
            resultInfo.info = info
            resultInfo.key = key
            resultInfo.resp = resp as NSDictionary?
            success(resultInfo)
        }, option: nil)
    }
    
    /**
     登录
     
     - parameter user_name:
     - parameter captcha:
     - parameter success:
     - parameter failure:
     */
    func login(_ user_name: String, captcha : String, success: ((_ userinfo: UserInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/login"
        let params = [
            "user_name" : user_name,
            "captcha" : captcha,
            "_o" : 1
        ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
                let userInfo = UserInfo.mj_object(withKeyValues: data)
                success?(userInfo!)
            }, failure: failure)
    }

    /**
     获取设备信息
     
     - parameter device_id:
     - parameter success:
     - parameter failure:
     */
    func deviceInfo(_ device_id: String, success: ((_ deviceInfo: DeviceInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "device/info"
        let params = [
            "device_id" : device_id,
            "_o" : 1
        ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let deviceInfo = DeviceInfo.mj_object(withKeyValues: data)
            success?(deviceInfo!)
            }, failure: failure)
    }
    
    /**
     刷新token
     
     - parameter success:
     - parameter failure:
     */
    func refreshUserToken(_ success: ((_ userInfo: UserInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "token/refresh"
        let params = [
            "user_id" : getUserId(),
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let userInfo = UserInfo.mj_object(withKeyValues: data)
            success?(userInfo!)
            }, failure: failure)
    }
    
    /**
     获得省份列表
     
     - parameter success:
     - parameter failure:
     */
    func provincelist(_ success: ((_ provinces: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "region/provincelist"
        let params = [
            "user_id" : getUserId(),
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = ProvinceModel.mj_objectArray(withKeyValuesArray: data)
            success?(array!)
            }, failure: failure)
    }
    
    /**
     获得某个省份下的城市列表
     
     - parameter province_id:
     - parameter success:
     - parameter failure:
     */
    func citylist(_ province_id : NSNumber, success: ((_ cities: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "region/citylist"
        let params = [
            "user_id" : getUserId(),
            "province_id" : province_id,
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = CityModel.mj_objectArray(withKeyValuesArray: data)
            success?(array!)
            }, failure: failure)
    }
    
    /**
     app强制升级
     
     - parameter success:
     - parameter failure: 
     */
    func appupgrade(_ success: ((_ appModel: AppModel) -> Void)?, failure: ((_ msg: String?) -> Void)?){
        let url = Constants.httpHost + "app/upgrade";
        let params = [
            "device_type" : Constants.osType,
            "version" : PhoneUtils.getBuildId(),
            "_o" : 1
        ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let appModel = AppModel.mj_object(withKeyValues: data)
            success?(appModel!)
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
    func bookingAdd(_ province_id : NSNumber, city_id : NSNumber, area_size : NSNumber, is_loan : NSInteger, success: ((_ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "booking/add";
        let params = [
            "user_id" : getUserId(), // 用户id
            "province_id" : province_id, // 预约时的省份id
            "city_id" : city_id, // 预约时的城市id
            "area_size" : area_size, // 屋顶面积
            "is_loan" : is_loan, // 是否需要贷款 int 0:不需要 1需要
            "_o" : 1
        ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let commonModel = CommonModel.mj_object(withKeyValues: data)
            success?(commonModel!)
            }, failure: failure)
    }
    
    /**
     银行列表
     
     - parameter success:
     - parameter failure:
     */
    func bankList(_ success: ((_ bankInfo: BankInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "bank/list";
        let params = [
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let bankInfo = BankInfo.mj_object(withKeyValues: data)
            success?(bankInfo!)
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
    func loanInfoAdd(_ bank_id : NSNumber,fullname : String, phone : String, id_no : String, id_image1 : String, id_image2 : String, province_id : NSNumber, city_id : NSNumber, address : String, family_images : String, success: ((_ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "booking/add";
        let params = [
            "user_id" : getUserId(),        // 用户id
            "bank_id" : bank_id,         // 银行id
            "fullname" : fullname,        // 姓名
            "phone" : phone,          // 手机号
            "id_no" : id_no,           // 身份证号
            "id_image1" : id_image1,       // 身份证正面图片url
            "id_image2" : id_image2,       //0 身份证反面图片url
            "province_id" : province_id,     // 电站所在的省份id
            "city_id" : city_id,         // 电站所在的城市id
            "address" : address,         // 电站所在的详细地址
            "family_images" : family_images,   // 家庭电站图片, 多个用逗号隔开
            "_o" : 1
        ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let commonModel = CommonModel.mj_object(withKeyValues: data)
            success?(commonModel!)
            }, failure: failure)
    }
    
    
    //查询预约的进度
    //绑定设备
    //保险列表
    //用户提交保险订单
    
    /**
     申请售后
     
     - parameter requirement:
     - parameter success:
     - parameter failure:
     */
    func aftersaleAdd(_ requirement : String, success: ((_ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "aftersale/add";
        let params = [
            "user_id" : getUserId(), // 用户id
            "requirement" : requirement,     // 售后需求
            "_o" : 1
        ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let commonModel = CommonModel.mj_object(withKeyValues: data)
            success?(commonModel!)
            }, failure: failure)
    }
    
    /**
     我申请的售后列表
     
     - parameter success:
     - parameter failure:
     */
    func aftersaleList(_ success: ((_ afterSales: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "aftersale/list"
        let params = [
            "user_id" : getUserId(),        // 用户id
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = AfterSaleInfo.mj_objectArray(withKeyValuesArray: data)
            success?(array!)
            }, failure: failure)
    }
    
    /**
     申请维修
     
     - parameter roof_id:
     - parameter success:
     - parameter failure: 
     */
    func userRepair(_ roof_id : NSNumber, success: ((_ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/repair";
        let params = [
            "user_id" : getUserId(), // 用户id
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let commonModel = CommonModel.mj_object(withKeyValues: data)
            success?(commonModel!)
            }, failure: failure)
    }
    
    /**
     用户列表/安装商列表
     
     - parameter type:  // 1: 普通用户 2: 安装商 (如果不传,默认为1)
     - parameter province_id:  // 若有此参数, 则返回当前省份下的安装商
     - parameter city_id:   // 若有此参数, 则返回当前城市下的安装商
     - parameter is_suggest: // 若此参数为1 && type为2, 则返回推荐的安装商   1/0
     - parameter success:
     - parameter failure:
     */
    func userlist(_ start : NSInteger, pagesize : NSInteger, type : NSNumber? = nil, province_id : NSNumber? = nil, city_id : NSNumber? = nil, is_suggest : NSNumber? = nil, is_auth : NSNumber? = nil, installer_id : NSNumber? = nil, success: ((_ totalCount : NSNumber, _ userInfos: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/list"
        let params = NSMutableDictionary()
        params["_o"] = 1
        if (type != nil) {
            params["type"] = type
        }
        if (province_id != nil) {
            params["province_id"] = province_id
        }
        if (city_id != nil) {
            params["city_id"] = city_id
        }
        if (is_suggest != nil) {
            params["is_suggest"] = is_suggest
        }
        if (is_auth != nil) {
            params["is_auth"] = String(describing: is_auth!)
        }
        if (installer_id != nil) {
            params["installer_id"] = installer_id
        }
        params["START"] = String(start)
        params["PAGESIZE"] = String(pagesize)
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = InstallInfo.mj_objectArray(withKeyValuesArray: data)
            success?(totalCount!, array!)
            }, failure: failure)
    }
    
    /**
     安装商详情
     
     - parameter installer_id:
     - parameter success:
     - parameter failure:      
     */
    func installerDetail(_ installer_id : NSNumber, success: ((_ installerDetail: InstallInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/list"
        let params = NSMutableDictionary()
        params["_o"] = 1
        params["installer_id"] = installer_id
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let installerDetail = InstallInfo.mj_object(withKeyValues: data)
            success?(installerDetail!)
            }, failure: failure)
    }
    
    /**
     我的安装商
     
     - parameter success:
     - parameter failure:
     */
    func myInstallerList(_ success: ((_ userInfos: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/my_installer_list"
        let params = NSMutableDictionary()
        params["_o"] = 1
        params["user_id"] = getUserId()
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = InstallInfo.mj_objectArray(withKeyValuesArray: data)
            success?(array!)
            }, failure: failure)
    }
    
    /**
     计算发电量收益
     
     - parameter type:
     - parameter area_size:
     - parameter province_id:
     - parameter city_id:
     - parameter success:
     - parameter failure:
     */
    func caluateElectric(_ type : String, area_size : String, province_id : NSNumber, city_id : NSNumber,polygon : String, success: ((_ electricInfo: ElectricInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "common/calc"
        var params = [
            "type" : type,                 // 1: 屋顶面积  2: 室内面积
            "area_size" : area_size,       // 屋顶面积  m2
            "province_id" : province_id,   // 省份id
            "city_id" : city_id,           // 城市id
            "_o" : 1
        ] as [String : Any]
        if (!polygon.isEmpty) {
            params["polygon"] = polygon
            params.removeValue(forKey: "area_size")
        }
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        print(newParams)
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let electricInfo = ElectricInfo.mj_object(withKeyValues: data)
            success?(electricInfo!)
            }, failure: failure)
    }
    
    /**
     计算收益保存信息
     
     - parameter phone:
     - parameter fullname:
     - parameter type:
     - parameter province_id:
     - parameter city_id:
     - parameter area_size:
     - parameter success:
     - parameter failure:     
     */
    func caluateSave(_ phone : String, fullname : String, type : NSNumber, province_id : NSNumber, city_id : NSNumber, area_size : String,  success: ((_ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "calc/add"
        let params = [
            "phone" : phone,          // 手机号
            "fullname" : fullname,       // 姓名
            "type" : type,           // 1: 屋顶面积  2: 室内面积
            "province_id" : province_id,     // 预约时的省份id
            "city_id" : city_id,         // 预约时的城市id
            "area_size" : area_size,      // 屋顶面积
            "_o" : 1
        ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let commonModel = CommonModel.mj_object(withKeyValues: data)
            success?(commonModel!)
            }, failure: failure)
    }
    
    /**
     申请成为安装商
     
     - parameter fullname:
     - parameter license_url:
     - parameter province_id:
     - parameter city_id:
     - parameter address:
     - parameter contact_info:
     - parameter company_name:
     - parameter company_size:
     - parameter company_intro:
     - parameter success:
     - parameter failure:
     */
    func becomeInstaller(_ fullname : String, license_url : String, province_id : NSNumber, city_id : NSNumber, address : String, contact_info : String, company_name : String, company_size : String, company_intro : String,  success: ((_ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/installer"
        let params = [
            "user_id" : getUserId(),        // 用户id
            "fullname" : fullname,       // 姓名
            "license_url" : license_url,    // 营业执照(图片url)
            "province_id" : province_id,    // 省份id
            "city_id" : city_id,        // 城市id
            "address" : address,        // 详细地址
            "contact_info" : contact_info,   // 联系方式
            "company_name" : company_name,   // 公司名称
            "company_size" : company_size,   // 规模(安装工人人数)
            "company_intro" : company_intro,  // 公司简介
            "_o" : 1
        ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let commonModel = CommonModel.mj_object(withKeyValues: data)
            success?(commonModel!)
            }, failure: failure)
    }
    
    /**
     发布屋顶资源
     
     - parameter fullname:
     - parameter province_id:
     - parameter city_id:
     - parameter address:
     - parameter area_size:
     - parameter area_image:
     - parameter type:
     - parameter contact_time:
     - parameter price:
     - parameter success:
     - parameter failure:
     */
    func roofAdd(_ fullname : String, province_id : NSNumber, city_id : NSNumber, address : String, area_size : String, area_image : String, type : NSNumber, contact_time : String, price : String, phone : String, success: ((_ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "roof/add";
        let params = [
            "user_id" : getUserId(),         // 用户id
            "fullname" : fullname,       // 发布人姓名
            "province_id" : province_id,     // 省份id
            "city_id" : city_id,        // 城市id
            "address" : address,         // 详细地址
            "area_size" : area_size,       // 屋顶面积
            "area_image" : area_image,      // 屋顶图片url
            "type" : type,            // 屋顶类型( 1:平面 2:斜面)
            "contact_time" : contact_time,    // 适合联系的时间
            "price" : price,           // 预计出租的价格 int
            "phone" : phone,           // 联系电话
            "_o" : 1
        ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let commonModel = CommonModel.mj_object(withKeyValues: data)
            success?(commonModel!)
            }, failure: failure)
    }
    
    /**
     屋顶资源列表
     
     - parameter status: // 若有此参数, 则返回相应状态的列表  1:未处理 2:已接单 3:已完成
     - parameter province_id:
     - parameter city_id:
     - parameter success:
     - parameter failure:
     */
    func getRoofList(_ start : NSInteger, pagesize : NSInteger, status : NSNumber? = nil, province_id : NSNumber? = nil, city_id : NSNumber? = nil, is_suggest : NSNumber? = nil, isSelf : NSNumber? = nil, min_area_size : String? = nil, max_area_size : String? = nil, type : NSNumber? = nil, success: ((_ roofInfos: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "roof/list"
        let params = NSMutableDictionary()
        params["_o"] = 1
        if (min_area_size != nil) {
            params["min_area_size"] = min_area_size
        }
        if (max_area_size != nil) {
            params["max_area_size"] = max_area_size
        }
        if (type != nil && type != 0) {
            params["type"] = String(describing: type!)
        }
        if (status != nil) {
            params["status"] = status
        }
        if (province_id != nil) {
            params["province_id"] = province_id
        }
        if (city_id != nil) {
            params["city_id"] = city_id
        }
        if (is_suggest != nil) {
            params["is_suggest"] = is_suggest
        }
        if (isSelf != nil) {
            params["user_id"] = getUserId()
        }
        params["START"] = String(start)
        params["PAGESIZE"] = String(pagesize)
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = RoofInfo.mj_objectArray(withKeyValuesArray: data)
            success?(array!)
            }, failure: failure)
    }
    
    /**
     安装商接单
     
     - parameter roof_id:
     - parameter success:
     - parameter failure:
     */
    func orderRoof(_ roof_id : NSNumber, success: ((_ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "roof/order";
        let params = [
            "user_id" : getUserId(), // 用户id
            "roof_id" : roof_id, // 预约时的省份id
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let commonModel = CommonModel.mj_object(withKeyValues: data)
            success?(commonModel!)
            }, failure: failure)
    }
    
    /**
     屋顶资源详情
     
     - parameter roof_id:
     - parameter success:
     - parameter failure:
     */
    func getRoofInfo(_ roof_id : NSNumber, success: ((_ roofInfo: RoofInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "roof/info"
        let params = [
            "id" : roof_id,
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let roofInfo = RoofInfo.mj_object(withKeyValues: data)
            success?(roofInfo!)
            }, failure: failure)
    }
    
    /**
     绑定设备
     
     - parameter device_id:
     - parameter device_type: 0易事特 1固德威
     - parameter success:
     - parameter failure:
     */
    func bindDevice(_ device_id : String,device_type : NSNumber, success: ((_ userInfo: UserInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/binddevice"
        let params = [
            "user_id" : getUserId(),
            "device_id" : device_id,
            "device_type" : String(describing: device_type),
            "_o" : 1
        ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let userinfo = UserInfo.mj_object(withKeyValues: data)
            success?(userinfo!)
            }, failure: failure)
    }
    
    /**
     购买过保险的公司列表
     - parameter success:
     - parameter failure: 
     */
    func usersHaveInsuranceList(_ start : NSInteger, pagesize : NSInteger,is_suggest : NSNumber? = nil, success: ((_ insuranceList: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "insurance/users_have_insurance_list"
        let params = NSMutableDictionary()
        params["_o"] = 1
        params["START"] = String(start)
        params["PAGESIZE"] = String(pagesize)
        if (is_suggest != nil) {
            params["is_suggest"] = is_suggest!
        } else {
            params["is_suggest"] = 0
        }
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = InsuranceInfo.mj_objectArray(withKeyValuesArray: data)
            success?(array!)
            }, failure: failure)
    }
    
    /**
     我的保险列表
     
     - parameter success:
     - parameter failure:
     */
    func myInsuranceList(_ success: ((_ insuranceList: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "insurance/insurance_mine"
        let params = NSMutableDictionary()
        params["_o"] = 1
        params["user_id"] = getUserId()
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = InsuranceInfo.mj_objectArray(withKeyValuesArray: data)
            success?(array!)
            }, failure: failure)
    }
    
    /**
     保险详情
     
     - parameter id:
     - parameter success:
     - parameter failure:
     */
    func insuranceDetail(_ id : NSNumber, success: ((_ insuranceInfo: InsuranceDetail) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "insurance/insurance_mine"
        let params = [
            "_o" : 1,
            "user_id" : getUserId(),
            "id" : id
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let insuranceInfo = InsuranceDetail.mj_object(withKeyValues: data)
            success?(insuranceInfo!)
            }, failure: failure)
    }
    
    /**
     保险类型及总购买数
     
     - parameter success:
     - parameter failure:
     */
    func insuranceType(_ success: ((_ typeList : NSArray, _ totalCount : NSNumber) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "insurance/insurance_type"
        let params = [
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = InsuranceType.mj_objectArray(withKeyValuesArray: data!["inscure"]!)
//                .mj_objectArray(datawithKeyValuesArray:data!["inscure"] as! AnyObject)
            let count = data!["totalCount"] as! NSNumber
            success?(array!, count)
            }, failure: failure)
    }
    
    /**
     用户提交保险订单
     
     - parameter insurance_company_id:
     - parameter type_id:
     - parameter years:
     - parameter price:
     - parameter beneficiary_name:
     - parameter beneficiary_phone:
     - parameter beneficiary_id_no:
     - parameter station_address:
     - parameter client_contract_img:
     - parameter success:
     - parameter failure:              
     */
    func insuranceAdd(_ insurance_company_id : NSNumber, type_id : NSNumber, years : String, price : NSNumber, beneficiary_name : String, beneficiary_phone : String, beneficiary_id_no : String, station_address : String, client_contract_img : String, success: ((_ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "insurance/add";
        let params = [
            "user_id": getUserId(),                          //用户id
            "insurance_company_id": insurance_company_id,// 保险公司的id
            "type_id": type_id,                          //保险类型
            "years": years,                              //担保年数
            "price": price,                              //保险的价格
            "beneficiary_name": beneficiary_name,        //受益人姓名
            "beneficiary_phone": beneficiary_phone,      //受益人电话
            "beneficiary_id_no": beneficiary_id_no,      //受益人身份证
            "station_address": station_address,          //电站地址
            "client_contract_img": client_contract_img,  //并网合同图片
            "_o" : 1
        ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let commonModel = CommonModel.mj_object(withKeyValues: data)
            success?(commonModel!)
            }, failure: failure)
    }
    
    /**
     年发电量
     
     - parameter device_id:
     - parameter year:
     - parameter success:
     - parameter failure:
     */
    func getEnergyStatistic(_ device_id : String, year : String, success: ((_ powerGraphInfos: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "device/energy_statistic"
        let params = [
            "_o" : 1,
            "device_id" : device_id,
            "year" : year
        ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = PowerGraphInfo.mj_objectArray(withKeyValuesArray: data)
            success?(array!)
            }, failure: failure)
    }
    
    /**
     获取验证码
     
     - parameter phoneNum:
     - parameter success:
     - parameter failure:
     */
    func userCaptcha(_ phoneNum : String, success: ((_ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/captcha";
        let params = [
            "user_name" : phoneNum,
            "_o" : 1
        ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let commonModel = CommonModel.mj_object(withKeyValues: data)
            success?(commonModel!)
            }, failure: failure)
    }
    
    /**
     获取固德威发电量
     
     - parameter snNumber:
     - parameter success:
     - parameter failure:
     */
    func bindGoodwe(_ snNumber : String, success: ((_ inventerModel: GetInventerMode) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = "http://www.goodwe-power.com/mobile/GetInventerDetail"
        let params = [
            "inventerSN" : snNumber,
        ]
        self.goodWeGet(url, params: params as AnyObject?, success: { (data) in
            let model = GetInventerMode.mj_object(withKeyValues: data)
            success?(model!)
            }, failure: failure)
    }
    
    /**
     点击申请安装商时判断是否已申请过
     
     - parameter success:
     - parameter failure:
     */
    func checkIsInstaller(_ success: ((_ msg: String, _ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/if_installer";
        let params = [
            "user_id" : getUserId(),
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let commonModel = CommonModel.mj_object(withKeyValues: data)
            success?(msg!, commonModel!)
            }, failure: failure)
    }
    
    /**
     获取通用属性
     
     - parameter type:
     - parameter success:
     - parameter failure:
     */
    func getContent(_ type : String, success: ((_ msg: String, _ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "content/get_content"
        let params = [
            "type" : type,
            "_o" : 1
        ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let commonModel = CommonModel.mj_object(withKeyValues: data)
            success?(msg!, commonModel!)
            }, failure: failure)
    }
    
    /**
     申请预约查修
     
     - parameter book_date: 预约时间
     - parameter phone:     手机号
     - parameter comments:  备注
     - parameter device_id: 设备id
     - parameter success:
     - parameter failure:
     */
    func bookRepair(_ book_date: String, phone: String, comments: String, device_id: String, success: ((_ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "repair/book_repair"
        let params = [
            "book_date" : book_date,
            "phone" : phone,
            "comments" : comments,
            "device_id" : device_id,
            "user_id" : getUserId(),
            "_o" : 1
        ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let commonModel = CommonModel.mj_object(withKeyValues: data)
            success?(commonModel!)
            }, failure: failure)
    }
    
    /**
     附近屋顶
     
     - parameter lat:
     - parameter lng:
     - parameter success:
     - parameter failure: 
     */
    func getNearRoof(_ lat : Double, lng : Double, success: ((_ roofList: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "roof/nearby_roofs"
        let params = [
            "latitude" : lat,
            "longitude" : lng,
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = RoofInfo.mj_objectArray(withKeyValuesArray: data)
            success?(array!)
            }, failure: failure)
    }
    
    /**
     附近安装商
     
     - parameter lat:
     - parameter lng:
     - parameter success:
     - parameter failure:
     */
    func getNearInstaller(_ lat : Double, lng : Double, success: ((_ roofList: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/nearby_installers"
        let params = [
            "latitude" : lat,
            "longitude" : lng,
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = InstallInfo.mj_objectArray(withKeyValuesArray: data)
            success?(array!)
        }, failure: failure)
    }
    
    /**
     用户绑定的设备列表
     
     - parameter success:
     - parameter failure:
     */
    func getUserDeviceList(_ success: ((_ deviceList: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "device/device_list"
        let params = [
            "user_id" : getUserId(),
//            "device_type" : 0,
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = DeviceListInfo.mj_objectArray(withKeyValuesArray: data)
            success?(array!)
            }, failure: failure)
    }
    
    /**
     解绑设备
     
     - parameter device_id:
     - parameter success:
     - parameter failure:
     */
    func unBindDevice(_ device_id: String, success: ((_ commomModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/unbinddevice"
        let params = [
            "user_id" : getUserId(),
            "device_id" : device_id,
            "_o" : 1
        ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let commonModel = CommonModel.mj_object(withKeyValues: data)
            success?(commonModel!)
            }, failure: failure)
    }

    /**
     用户信息
     
     - parameter success:
     - parameter failure: 
     */
    func getUserInfo(_ success: ((_ userinfo: UserInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/get_userinfo"
        let params = [
            "user_id" : getUserId(),
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let userInfo = UserInfo.mj_object(withKeyValues: data)
            success?(userInfo!)
            }, failure: failure)
    }
    
    /**
     认证提醒
     
     - parameter success:
     - parameter failure:
     */
    func remindAuth(_ success: ((_ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/remind_auth"
        let params = [
            "user_id" : getUserId(),
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let commonModel = CommonModel.mj_object(withKeyValues: data)
            success?(commonModel!)
            }, failure: failure)
    }
}
