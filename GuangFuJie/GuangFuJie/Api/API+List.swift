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
     获得省份列表V2
     
     - parameter success:
     - parameter failure:
     */
    func provincelistV2(_ success: ((_ provinces: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "v2/region/provincelist"
        let params = [
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
     获得某个省份下的城市列表V2
     
     - parameter province_id:
     - parameter success:
     - parameter failure:
     */
    func citylistV2(_ province_id : NSNumber, success: ((_ cities: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "v2/region/citylist"
        let params = [
            "provinceId" : province_id,
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = CityModel.mj_objectArray(withKeyValuesArray: data)
            success?(array!)
        }, failure: failure)
    }
    
    //获得某个城市下的区域列表
    func areaList(_ cityId : NSNumber, success: ((_ cities: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "v2/region/arealist"
        let params = [
            "cityId" : cityId,
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = AreaModel.mj_objectArray(withKeyValuesArray: data)
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
        if (UserDefaultManager.isLogin()) {
            params["user_id"] = getUserId()
        }
        
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
//            "contact_time" : contact_time,    // 适合联系的时间
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
        let params = NSMutableDictionary()
        params["_o"] = 1
        params["id"] = roof_id
        if (UserDefaultManager.isLogin()) {
            params["user_id"] = getUserId()
        }
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
    func insuranceAdd(_ insurance_company_id : NSNumber, type_id : NSNumber, years : String, price : NSNumber, beneficiary_name : String, beneficiary_phone : String, beneficiary_id_no : String, station_address : String, client_contract_img : String, salesType: NSNumber, image: String, address: String, longitude: String, latitude: String, is_nearsea: String, success: ((_ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "insurance/add";
        let params = [
            "user_id": getUserId(),                          //用户id
            "insurance_company_id": insurance_company_id,// 保险公司的id
            "type_id": type_id,                          //保险类型
            "salesType": salesType,                      //套餐id
            "years": years,                              //担保年数
            "price": price,                              //保险的价格
            "beneficiary_name": beneficiary_name,        //受益人姓名
            "beneficiary_phone": beneficiary_phone,      //受益人电话
            "beneficiary_id_no": beneficiary_id_no,      //受益人身份证
            "station_address": station_address,          //电站地址
            "client_contract_img": client_contract_img,  //并网合同图片
            "address": address,
            "longitude": longitude,
            "latitude": latitude,
            "image": image,
            "is_nearsea": is_nearsea,
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
    
    //附近安装商
    func getNearInstallerV1(_ longitude : NSNumber? = nil, latitude : NSNumber? = nil, size : NSNumber? = nil, success: ((_ installerList: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "installer/near_installers"
        let params = [
            "longitude" : longitude,
            "latitude" : latitude,
            "size" : size,
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = InstallInfo.mj_objectArray(withKeyValuesArray: data)
            success?(array!)
        }, failure: failure)
    }
    
    
    //附近安装商
    func getNearInstallerV2(_ province_id : NSNumber? = nil, city_id : NSNumber? = nil, area_id : NSNumber? = nil, success: ((_ installerList: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "installer/getInstallersById"
        let params = [
            "province_id" : province_id,
            "city_id" : city_id,
            "area_id" : area_id,
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = InstallInfo.mj_objectArray(withKeyValuesArray: data)
            success?(array!)
        }, failure: failure)
    }
    
    //安装商推荐
    func installerSuggest(success: ((_ installerList: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "installer/suggest"
        let params = [
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
    
    
    /**
     收藏屋顶
     
     - parameter success:
     - parameter failure:
     */
    func favRoof(_ roof_id: NSNumber, _ success: ((_ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "roof/roof_favor"
        let params = [
            "user_id" : getUserId(),
            "roof_id" : roof_id,
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
     取消收藏屋顶
     
     - parameter success:
     - parameter failure:
     */
    func unFavRoof(_ roof_id: NSNumber, _ success: ((_ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "roof/roof_cancel_favor"
        let params = [
            "user_id" : getUserId(),
            "roof_id" : roof_id,
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
     收藏安装商
     
     - parameter success:
     - parameter failure:
     */
    func favInstaller(_ installer_id: NSNumber, _ success: ((_ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/installer_favor"
        let params = [
            "user_id" : getUserId(),
            "installer_id" : installer_id,
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
     取消收藏安装商
     
     - parameter success:
     - parameter failure:
     */
    func unFavInstaller(_ installer_id: NSNumber, _ success: ((_ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/installer_cancel_favor"
        let params = [
            "user_id" : getUserId(),
            "installer_id" : installer_id,
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
     我收藏的安装商
     
     - parameter success:
     - parameter failure:
     */
    func myFavInstallers(_ success: ((_ totalCount : NSNumber, _ userInfos: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/favor_installer_list"
        let params = NSMutableDictionary()
        params["_o"] = 1
        params["user_id"] = getUserId()
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = InstallInfo.mj_objectArray(withKeyValuesArray: data)
            success?(totalCount!, array!)
        }, failure: failure)
    }
    
    /**
     我收藏的屋顶
     
     - parameter success:
     - parameter failure:
     */
    func myFavRoofs(_ success: ((_ totalCount : NSNumber, _ userInfos: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "roof/favor_roof_list"
        let params = NSMutableDictionary()
        params["_o"] = 1
        params["user_id"] = getUserId()
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = RoofInfo.mj_objectArray(withKeyValuesArray: data)
            success?(totalCount!, array!)
        }, failure: failure)
    }
    
    
    /// 资讯列表
    ///
    /// - Parameters:
    ///   - start:
    ///   - pagesize:
    ///   - success:
    ///   - failure: 
    func newsList(_ start : NSInteger, pagesize : NSInteger, success: ((_ totalCount : NSNumber, _ userInfos: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "news/newsList"
        let params = NSMutableDictionary()
        params["_o"] = 1
        params["start"] = "\(start)"
        params["pagesize"] = "\(pagesize)"
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = NewsInfo.mj_objectArray(withKeyValuesArray: data)
            success?(totalCount!, array!)
        }, failure: failure)
    }
    
    
    /// 搜索安装商
    ///
    /// - Parameters:
    ///   - start:       //开始页数   1 开始
    ///   - pagesize:    //每页个数
    ///   - searchValue: //搜索内容
    ///   - success:
    ///   - failure:
    func searchInstaller(_ start : NSInteger, pagesize : NSInteger, searchValue : String, success: ((_ totalCount : NSNumber, _ userInfos: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "common/searchInstaller"
        let params = NSMutableDictionary()
        params["_o"] = 1
        params["searchValue"] = searchValue
        params["start"] = String(start)
        params["pagesize"] = String(pagesize)
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = InstallInfo.mj_objectArray(withKeyValuesArray: data)
            success?(totalCount!, array!)
        }, failure: failure)
    }
    
    //安装商地图列表
    func installerMapList(success: ((_ totalCount : NSNumber, _ userInfos: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "installer/map"
        let params = NSMutableDictionary()
        params["_o"] = 1
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = InstallerMapInfo.mj_objectArray(withKeyValuesArray: data)
            success?(totalCount!, array!)
        }, failure: failure)
    }
    
    //安装商地图列表V2
    func installerMapListV2(type: String, lat: NSNumber, lng: NSNumber, success: ((_ totalCount : NSNumber, _ userInfos: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "installer/map"
        let params = NSMutableDictionary()
        params["_o"] = 1
        params["type"] = type
        params["lng"] = lng
        params["lat"] = lat
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = InstallerMapInfo.mj_objectArray(withKeyValuesArray: data)
            success?(totalCount!, array!)
        }, failure: failure)
    }
    
    //屋顶地图列表
    func roofMapList(success: ((_ totalCount : NSNumber, _ userInfos: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "roof/map"
        let params = NSMutableDictionary()
        params["_o"] = 1
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = RoofMapInfo.mj_objectArray(withKeyValuesArray: data)
            success?(totalCount!, array!)
        }, failure: failure)
    }
    
    //屋顶地图列表V2
    func roofMapListV2(type: String, lat: NSNumber, lng: NSNumber, success: ((_ totalCount : NSNumber, _ userInfos: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "roof/map"
        let params = NSMutableDictionary()
        params["_o"] = 1
        params["type"] = type // province city area 三选一
        params["lat"] = lat
        params["lng"] = lng
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = RoofMapInfo.mj_objectArray(withKeyValuesArray: data)
            success?(totalCount!, array!)
        }, failure: failure)
    }
    
    //安装商申请
    func installerAdd(licenserUrl: String, companyName: String, companySize: String, companyDesc: String, phone: String, linkMan: String, provinceId: NSNumber, cityId: NSNumber, areaId: NSNumber, addressDetail: String, success: ((_ info: InstallInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "installer/add";
        let params = [
            "userId" : getUserId(), //用户id
            "licenserUrl" : licenserUrl, //证书图片url
            "companyName" : companyName,
            "companySize" : companySize,
            "companyDesc" : companyDesc,
            "phone": phone,
            "linkMan": linkMan,
            "provinceId": provinceId,
            "cityId": cityId,
            "areaId": areaId,
            "addressDetail": addressDetail,
            "_o" : 1
            ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let info = InstallInfo.mj_object(withKeyValues: data)
            success?(info!)
        }, failure: failure)
    }
    
    //加盟商列表
    func franchiseeList(_ start : NSInteger, pagesize : NSInteger, key: String? = nil, provinceId: NSNumber? = nil, cityId: NSNumber? = nil, areaId: NSNumber? = nil, success: ((_ totalCount : NSNumber, _ userInfos: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "franchisee/list"
        let params = NSMutableDictionary()
        params["_o"] = 1
        if (key != nil) {
            params["key"] = key
        }
        if (provinceId != nil) {
            params["provinceId"] = provinceId
        }
        if (cityId != nil) {
            params["cityId"] = cityId
        }
        if (areaId != nil) {
            params["areaId"] = areaId
        }
        params["start"] = String(start)
        params["pageisze"] = String(pagesize)
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = FranchiseeInfo.mj_objectArray(withKeyValuesArray: data)
            success?(totalCount!, array!)
        }, failure: failure)
    }
    
    //加盟商申请
    func franchiseeAdd(businessUrl: String, electricalUrl: String, licenserUrl: String, companyName: String, companySize: String, companyDesc: String, phone: String, linkMan: String, provinceId: NSNumber, cityId: NSNumber, areaId: NSNumber, addressDetail: String, success: ((_ info: FranchiseeInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "installer/add";
        let params = [
            "userId" : getUserId(), //用户id
            "businessUrl" : businessUrl,
            "electricalUrl" : electricalUrl,
            "licenserUrl" : licenserUrl,
            "companyName" : companyName,
            "companySize" : companySize,
            "companyDesc" : companyDesc,
            "phone": phone,
            "linkMan": linkMan,
            "provinceId": provinceId,
            "cityId": cityId,
            "areaId": areaId,
            "addressDetail": addressDetail,
            "_o" : 1
            ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let info = FranchiseeInfo.mj_object(withKeyValues: data)
            success?(info!)
        }, failure: failure)
    }
    
    //地推申请
    func groundAdd(name: String, phone: String, provinceId: NSNumber, cityId: NSNumber, areaId: NSNumber, addressDetail: String, success: ((_ info: GroupInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "installer/add";
        let params = [
            "userId" : getUserId(), //用户id
            "name" : name,
            "phone" : phone,
            "provinceId": provinceId,
            "cityId": cityId,
            "areaId": areaId,
            "addressDetail": addressDetail,
            "_o" : 1
            ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let info = GroupInfo.mj_object(withKeyValues: data)
            success?(info!)
        }, failure: failure)
    }
    
    //业主申请
    func landlordAdd(name: String, phone: String, provinceId: NSNumber, cityId: NSNumber, areaId: NSNumber, addressDetail: String, roofImg: String, success: ((_ info: LandlordInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "installer/add";
        let params = [
            "userId" : getUserId(), //用户id
            "name" : name,
            "phone" : phone,
            "provinceId": provinceId,
            "cityId": cityId,
            "areaId": areaId,
            "addressDetail": addressDetail,
            "roofImg": roofImg,
            "_o" : 1
            ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let info = LandlordInfo.mj_object(withKeyValues: data)
            success?(info!)
        }, failure: failure)
    }
    
    //图文列表
    func articlesList(_ start : NSInteger, pagesize : NSInteger, key: String? = nil, provinceId: NSNumber? = nil, cityId: NSNumber? = nil, areaId: NSNumber? = nil, type: NSNumber? = nil, success: ((_ totalCount : NSNumber, _ userInfos: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "articles/list"
        let params = NSMutableDictionary()
        params["_o"] = 1
        if (key != nil) {
            params["key"] = key
        }
        if (provinceId != nil) {
            params["provinceId"] = provinceId
        }
        if (cityId != nil) {
            params["cityId"] = cityId
        }
        if (areaId != nil) {
            params["areaId"] = areaId
        }
        if (type != nil) {
            params["type"] = type
        }
        params["start"] = String(start)
        params["pageisze"] = String(pagesize)
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = ArticleInfo.mj_objectArray(withKeyValuesArray: data)
            success?(totalCount!, array!)
        }, failure: failure)
    }
    
    //添加地推笔记
    func groundAddnote(_ title: String, phone: String, address: String, msg: String, success: ((_ commonModel: CommonModel) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "booking/add";
        let params = [
            "userId" : getUserId(), // 用户id
            "title": title,
            "phone": phone,
            "address": address,
            "msg": msg,
            "_o" : 1
            ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let commonModel = CommonModel.mj_object(withKeyValues: data)
            success?(commonModel!)
        }, failure: failure)
    }
    
    //地推笔记列表
    func noteList(_ start : NSInteger, pagesize : NSInteger, success: ((_ totalCount : NSNumber, _ userInfos: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "articles/list"
        let params = NSMutableDictionary()
        params["_o"] = 1
        params["userId"] = getUserId()
        params["start"] = String(start)
        params["pageisze"] = String(pagesize)
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = NoteInfo.mj_objectArray(withKeyValuesArray: data)
            success?(totalCount!, array!)
        }, failure: failure)
    }
    
    //获取单一问答详情 (app)
    func useraskItem(_ id: NSNumber, success: ((_ commonModel: AskInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "userask/item";
        let params = [
            "userId" : getUserId(), // 用户id
            "id" : id,
            "_o" : 1
            ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.post(url, params: newParams as AnyObject?, success: { (data) in
            let info = AskInfo.mj_object(withKeyValues: data)
            success?(info!)
        }, failure: failure)
    }
    
    //辐照计算
    func projectcalSunenerge(_ lat: NSNumber, lng: NSNumber, success: ((_ commonModel: ProjectcalInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "projectcal/sunenerge";
        let params = [
            "lat": lat,
            "lng": lng,
            "_o" : 1
            ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let info = ProjectcalInfo.mj_object(withKeyValues: data)
            success?(info!)
        }, failure: failure)
    }
    
    //产能计算
    func projectcalEnergycal(type: NSInteger, size: String, lat: NSNumber, lng: NSNumber, success: ((_ commonModel: EnergycalInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "projectcal/energycal";
        let params = [
            "type": String(type),
            "size": size,
            "lat": lat,
            "lng": lng,
            "_o" : 1
            ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let info = EnergycalInfo.mj_object(withKeyValues: data)
            success?(info!)
        }, failure: failure)
    }
    
    //收益综合报告
    func projectcalIncomecal(type: NSNumber, size: NSNumber, invest_amount: NSNumber, recoverable_liquid_capital: NSNumber, annual_maintenance_cost: NSNumber, installed_subsidy: NSNumber, loan_ratio: NSNumber, years_of_loans: NSNumber, occupied_electric_ratio: NSNumber, lectric_price_perional: NSNumber, electricity_subsidy : NSNumber, electricity_subsidy_year: NSNumber, sparetime_electric_price: NSNumber, success: ((_ commonModel: IncomecalInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "projectcal/incomecal";
        let params = [
            "type": type, //三种类型
            "size": size, //面积
            "invest_amount": invest_amount,  //投资金额
            "recoverable_liquid_capital": recoverable_liquid_capital,  //可回收流动资金
            "annual_maintenance_cost": annual_maintenance_cost, //年运维成本
            "installed_subsidy": installed_subsidy, //装机补贴
            "loan_ratio": loan_ratio,//贷款比例
            "years_of_loans": years_of_loans, //贷款年数
            "occupied_electric_ratio": occupied_electric_ratio, //自用电比例
            "lectric_price_perional": lectric_price_perional, //自用电电价
            "electricity_subsidy": electricity_subsidy, //用电补贴
            "electricity_subsidy_year": electricity_subsidy_year,//用电补贴年
            "sparetime_electric_price": sparetime_electric_price, //余电上网价
            "_o" : 1
            ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let info = IncomecalInfo.mj_object(withKeyValues: data)
            success?(info!)
        }, failure: failure)
    }
    
    //收益计算-发电收益
    func projectcalElecticincomeList(type: NSNumber, size: NSNumber, annual_maintenance_cost: NSNumber, lat: NSNumber, lng: NSNumber, success: ((_ totalCount : NSNumber, _ userInfos: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "projectcal/energycal";
        let params = [
            "type": type,
            "size": size,
            "annual_maintenance_cost": annual_maintenance_cost,
            "lat": lat,
            "lng": lng,
            "_o" : 1
            ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = ElecticIncomeInfo.mj_objectArray(withKeyValuesArray: data)
            success?(totalCount!, array!)
        }, failure: failure)
    }
    
    // 收益计算-还款额度
    func projectcalRepaymentList(invest_amount: NSNumber, invest_year: NSNumber, success: ((_ totalCount : NSNumber, _ userInfos: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "projectcal/repaymentlist";
        let params = [
            "invest_amount": invest_amount, //贷款金额 （前面的界面投资金额乘以贷款百分比）
            "invest_year": invest_amount, //贷款年限
            "_o" : 1
            ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = RepaymentInfo.mj_objectArray(withKeyValuesArray: data)
            success?(totalCount!, array!)
        }, failure: failure)
    }
    
    //收益计算-净收益
    func projectcalNetprofit(annual_maintenance_cost: NSNumber, type: NSNumber, size: NSNumber, lat: NSNumber, lng: NSNumber, success: ((_ totalCount : NSNumber, _ userInfos: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "projectcal/netprofit";
        let params = [
            "annual_maintenance_cost": annual_maintenance_cost,//年运维成本
            "type": type, //三种类型
            "size": size, //面积
            "lat": lat,
            "lng": lng,
            "_o" : 1
            ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = NetprofitInfo.mj_objectArray(withKeyValuesArray: data)
            success?(totalCount!, array!)
        }, failure: failure)
    }
    
    //收益计算-参数获取
    func incomecalParams(lat: NSNumber, lng: NSNumber, province: NSNumber, city: NSNumber, area: NSNumber, type: NSNumber, size: NSNumber, success: ((_ commonModel: IncomeCalParams) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "projectcal/incomecalparams";
        let params = [
            "lat": lat, //纬度
            "lng": lng, //经度
            "province": province,   //省id
            "city": city,   //城市id
            "area": area,   //区域id
            "type": type,   //1,2,3 三种类型
            "size": size,        //面积
            "_o" : 1
            ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let info = IncomeCalParams.mj_object(withKeyValues: data)
            success?(info!)
        }, failure: failure)
    }
    
    //地推人员列表
    func groundList(start: NSInteger, pagesize: NSInteger, success: ((_ totalCount : NSNumber, _ userInfos: NSArray) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "ground/list";
        let params = [
            "start": String(start),
            "pagesize": String(pagesize),
            "_o" : 1
            ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let array = GroupUserInfo.mj_objectArray(withKeyValuesArray: data)
            success?(totalCount!, array!)
        }, failure: failure)
    }
    
    //我的页面
    func userAllCount(success: ((_ commonModel: MyCountInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/allCount";
        let params = [
            "user_id" : getUserId(), // 用户id
            "_o" : 1
            ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let info = MyCountInfo.mj_object(withKeyValues: data)
            success?(info!)
        }, failure: failure)
    }
    
    //根据经纬度获取城市信息
    func getCityFromLatlng(lat: NSNumber, lng: NSNumber, success: ((_ commonModel: LocationInfo) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        let url = Constants.httpHost + "map/getCityfromLatlng";
        let params = [
            "lat": lat,
            "lng": lng,
            "_o" : 1
            ] as [String : Any]
        let jsonStr = self.dataToJsonString(params as AnyObject)
        let newParams = ["edata" : jsonStr.aes256Encrypt(withKey: Constants.aeskey)]
        self.get(url, params: newParams as AnyObject?, success: { (totalCount, msg, data) in
            let info = LocationInfo.mj_object(withKeyValues: data)
            success?(info!)
        }, failure: failure)
    }
    
    
}
