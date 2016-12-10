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
    func qnToken(key : String, success: ((qnInfo: QNInfo) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "qiniu/uptoken"
        let params = [
            "key" : key,
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.get(url, params: newParams, success: { (msg, data) in
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
        self.get(url, params: newParams, success: { (msg, data) in
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
        self.get(url, params: newParams, success: { (msg, data) in
            let array = ProvinceModel.mj_objectArrayWithKeyValuesArray(data)
            success?(provinces: array)
            }, failure: failure)
    }
    
    /**
     获得某个省份下的城市列表
     
     - parameter province_id:
     - parameter success:
     - parameter failure:
     */
    func citylist(province_id : NSNumber, success: ((cities: NSArray) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "region/citylist"
        let params = [
            "user_id" : getUserId(),
            "province_id" : province_id,
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.get(url, params: newParams, success: { (msg, data) in
            let array = CityModel.mj_objectArrayWithKeyValuesArray(data)
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
        self.get(url, params: newParams, success: { (msg, data) in
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
            "id_image2" : id_image2,       //0 身份证反面图片url
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
    func aftersaleAdd(requirement : String, success: ((commonModel: CommonModel) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "aftersale/add";
        let params = [
            "user_id" : getUserId(), // 用户id
            "requirement" : requirement,     // 售后需求
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
     我申请的售后列表
     
     - parameter success:
     - parameter failure:
     */
    func aftersaleList(success: ((afterSales: NSArray) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "aftersale/list"
        let params = [
            "user_id" : getUserId(),        // 用户id
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.get(url, params: newParams, success: { (msg, data) in
            let array = AfterSaleInfo.mj_objectArrayWithKeyValuesArray(data)
            success?(afterSales : array)
            }, failure: failure)
    }
    
    /**
     申请维修
     
     - parameter roof_id:
     - parameter success:
     - parameter failure: 
     */
    func userRepair(roof_id : NSNumber, success: ((commonModel: CommonModel) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/repair";
        let params = [
            "user_id" : getUserId(), // 用户id
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
     用户列表/安装商列表
     
     - parameter type:  // 1: 普通用户 2: 安装商 (如果不传,默认为1)
     - parameter province_id:  // 若有此参数, 则返回当前省份下的安装商
     - parameter city_id:   // 若有此参数, 则返回当前城市下的安装商
     - parameter is_suggest: // 若此参数为1 && type为2, 则返回推荐的安装商   1/0
     - parameter success:
     - parameter failure:
     */
    func userlist(type : NSNumber? = nil, province_id : NSNumber? = nil, city_id : NSNumber? = nil, is_suggest : NSNumber? = nil, success: ((userInfos: NSArray) -> Void)?, failure: ((msg: String?) -> Void)?) {
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
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.get(url, params: newParams, success: { (msg, data) in
            let array = InstallInfo.mj_objectArrayWithKeyValuesArray(data)
            success?(userInfos: array)
            }, failure: failure)
    }
    
    /**
     我的安装商
     
     - parameter success:
     - parameter failure:
     */
    func myInstallerList(success: ((userInfos: NSArray) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/my_installer_list"
        let params = NSMutableDictionary()
        params["_o"] = 1
        params["user_id"] = getUserId()
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.get(url, params: newParams, success: { (msg, data) in
            let array = InstallInfo.mj_objectArrayWithKeyValuesArray(data)
            success?(userInfos: array)
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
    func caluateElectric(type : String, area_size : String, province_id : NSNumber, city_id : NSNumber,polygon : String, success: ((electricInfo: ElectricInfo) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "common/calc"
        var params = [
            "type" : type,                 // 1: 屋顶面积  2: 室内面积
            "area_size" : area_size,       // 屋顶面积  m2
            "province_id" : province_id,   // 省份id
            "city_id" : city_id,           // 城市id
            "_o" : 1
        ]
        if (!polygon.isEmpty) {
            params["polygon"] = polygon
            params.removeValueForKey("area_size")
        }
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        print(newParams)
        self.get(url, params: newParams, success: { (msg, data) in
            let electricInfo = ElectricInfo.mj_objectWithKeyValues(data)
            success?(electricInfo : electricInfo)
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
    func caluateSave(phone : String, fullname : String, type : NSNumber, province_id : NSNumber, city_id : NSNumber, area_size : String,  success: ((commonModel: CommonModel) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "calc/add"
        let params = [
            "phone" : phone,          // 手机号
            "fullname" : fullname,       // 姓名
            "type" : type,           // 1: 屋顶面积  2: 室内面积
            "province_id" : province_id,     // 预约时的省份id
            "city_id" : city_id,         // 预约时的城市id
            "area_size" : area_size,      // 屋顶面积
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
    func becomeInstaller(fullname : String, license_url : String, province_id : NSNumber, city_id : NSNumber, address : String, contact_info : String, company_name : String, company_size : String, company_intro : String,  success: ((commonModel: CommonModel) -> Void)?, failure: ((msg: String?) -> Void)?) {
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
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.post(url, params: newParams, success: { (data) in
            let commonModel = CommonModel.mj_objectWithKeyValues(data)
            success?(commonModel : commonModel)
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
    func roofAdd(fullname : String, province_id : NSNumber, city_id : NSNumber, address : String, area_size : String, area_image : String, type : NSNumber, contact_time : String, price : String, phone : String, success: ((commonModel: CommonModel) -> Void)?, failure: ((msg: String?) -> Void)?) {
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
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.post(url, params: newParams, success: { (data) in
            let commonModel = CommonModel.mj_objectWithKeyValues(data)
            success?(commonModel : commonModel)
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
    func getRoofList(status : NSNumber? = nil, province_id : NSNumber? = nil, city_id : NSNumber? = nil, is_suggest : NSNumber? = nil, isSelf : NSNumber? = nil, success: ((roofInfos: NSArray) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "roof/list"
        let params = NSMutableDictionary()
        params["_o"] = 1
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
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.get(url, params: newParams, success: { (msg, data) in
            let array = RoofInfo.mj_objectArrayWithKeyValuesArray(data)
            success?(roofInfos: array)
            }, failure: failure)
    }
    
    /**
     安装商接单
     
     - parameter roof_id:
     - parameter success:
     - parameter failure:
     */
    func orderRoof(roof_id : NSNumber, success: ((commonModel: CommonModel) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "roof/order";
        let params = [
            "user_id" : getUserId(), // 用户id
            "roof_id" : roof_id, // 预约时的省份id
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
     屋顶资源详情
     
     - parameter roof_id:
     - parameter success:
     - parameter failure:
     */
    func getRoofInfo(roof_id : NSNumber, success: ((roofInfo: RoofInfo) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "roof/info"
        let params = [
            "id" : roof_id,
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.get(url, params: newParams, success: { (msg, data) in
            let roofInfo = RoofInfo.mj_objectWithKeyValues(data)
            success?(roofInfo : roofInfo)
            }, failure: failure)
    }
    
    /**
     绑定设备
     
     - parameter device_id:
     - parameter device_type: 0易事特 1固德威
     - parameter success:
     - parameter failure:
     */
    func bindDevice(device_id : String,device_type : NSNumber, success: ((userInfo: UserInfo) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/binddevice"
        let params = [
            "user_id" : getUserId(),
            "device_id" : device_id,
            "device_type" : String(device_type),
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.post(url, params: newParams, success: { (data) in
            let userinfo = UserInfo.mj_objectWithKeyValues(data)
            success?(userInfo : userinfo)
            }, failure: failure)
    }
    
    /**
     购买过保险的公司列表
     - parameter success:
     - parameter failure: 
     */
    func usersHaveInsuranceList(start : NSInteger, pagesize : NSInteger,is_suggest : NSNumber? = nil, success: ((insuranceList: NSArray) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "insurance/users_have_insurance_list"
        let params = NSMutableDictionary()
        params["_o"] = 1
        params["START"] = start
        params["PAGESIZE"] = pagesize
        if (is_suggest != nil) {
            params["is_suggest"] = is_suggest!
        }
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.get(url, params: newParams, success: { (msg, data) in
            let array = InsuranceInfo.mj_objectArrayWithKeyValuesArray(data)
            success?(insuranceList : array)
            }, failure: failure)
    }
    
    /**
     我的保险列表
     
     - parameter success:
     - parameter failure:
     */
    func myInsuranceList(success: ((insuranceList: NSArray) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "insurance/insurance_mine"
        let params = NSMutableDictionary()
        params["_o"] = 1
        params["user_id"] = getUserId()
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.get(url, params: newParams, success: { (msg, data) in
            let array = InsuranceInfo.mj_objectArrayWithKeyValuesArray(data)
            success?(insuranceList : array)
            }, failure: failure)
    }
    
    /**
     保险详情
     
     - parameter id:
     - parameter success:
     - parameter failure:
     */
    func insuranceDetail(id : NSNumber, success: ((insuranceInfo: InsuranceDetail) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "insurance/insurance_mine"
        let params = [
            "_o" : 1,
            "user_id" : getUserId(),
            "id" : id
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.get(url, params: newParams, success: { (msg, data) in
            let insuranceInfo = InsuranceDetail.mj_objectWithKeyValues(data)
            success?(insuranceInfo : insuranceInfo)
            }, failure: failure)
    }
    
    /**
     保险类型及总购买数
     
     - parameter success:
     - parameter failure:
     */
    func insuranceType(success: ((typeList : NSArray, totalCount : NSNumber) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "insurance/insurance_type"
        let params = [
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.get(url, params: newParams, success: { (msg, data) in
            print(data)
            let array = InsuranceType.mj_objectArrayWithKeyValuesArray(data!["inscure"])
            let totalCount = data!["totalCount"] as! NSNumber
            success?(typeList : array, totalCount : totalCount)
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
    func insuranceAdd(insurance_company_id : NSNumber, type_id : NSNumber, years : String, price : NSNumber, beneficiary_name : String, beneficiary_phone : String, beneficiary_id_no : String, station_address : String, client_contract_img : String, success: ((commonModel: CommonModel) -> Void)?, failure: ((msg: String?) -> Void)?) {
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
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.post(url, params: newParams, success: { (data) in
            let commonModel = CommonModel.mj_objectWithKeyValues(data)
            success?(commonModel : commonModel)
            }, failure: failure)
    }
    
    /**
     年发电量
     
     - parameter device_id:
     - parameter year:
     - parameter success:
     - parameter failure:
     */
    func getEnergyStatistic(device_id : String, year : String, success: ((powerGraphInfos: NSArray) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "device/energy_statistic"
        let params = [
            "_o" : 1,
            "device_id" : device_id,
            "year" : year
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.get(url, params: newParams, success: { (msg, data) in
            let array = PowerGraphInfo.mj_objectArrayWithKeyValuesArray(data)
            success?(powerGraphInfos : array)
            }, failure: failure)
    }
    
    /**
     获取验证码
     
     - parameter phoneNum:
     - parameter success:
     - parameter failure:
     */
    func userCaptcha(phoneNum : String, success: ((commonModel: CommonModel) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/captcha";
        let params = [
            "user_name" : phoneNum,
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.get(url, params: newParams, success: { (msg, data) in
            let commonModel = CommonModel.mj_objectWithKeyValues(data)
            success?(commonModel : commonModel)
            }, failure: failure)
    }
    
    /**
     获取固德威发电量
     
     - parameter snNumber:
     - parameter success:
     - parameter failure:
     */
    func bindGoodwe(snNumber : String, success: ((inventerModel: GetInventerMode) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = "http://www.goodwe-power.com/mobile/GetInventerDetail"
        let params = [
            "inventerSN" : snNumber,
        ]
        self.goodWeGet(url, params: params, success: { (data) in
            let model = GetInventerMode.mj_objectWithKeyValues(data)
            success?(inventerModel : model)
            }, failure: failure)
    }
    
    /**
     点击申请安装商时判断是否已申请过
     
     - parameter success:
     - parameter failure:
     */
    func checkIsInstaller(success: ((msg: String, commonModel: CommonModel) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "user/if_installer";
        let params = [
            "user_id" : getUserId(),
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.get(url, params: newParams, success: { (msg, data) in
            let commonModel = CommonModel.mj_objectWithKeyValues(data)
            success?(msg: msg!, commonModel : commonModel)
            }, failure: failure)
    }
    
    /**
     获取通用属性
     
     - parameter type:
     - parameter success:
     - parameter failure:
     */
    func getContent(type : String, success: ((msg: String, commonModel: CommonModel) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "content/get_content"
        let params = [
            "type" : type,
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.get(url, params: newParams, success: { (msg, data) in
            let commonModel = CommonModel.mj_objectWithKeyValues(data)
            success?(msg: msg!, commonModel : commonModel)
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
    func bookRepair(book_date: String, phone: String, comments: String, device_id: String, success: ((commonModel: CommonModel) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "repair/book_repair"
        let params = [
            "book_date" : book_date,
            "phone" : phone,
            "comments" : comments,
            "device_id" : device_id,
            "user_id" : getUserId(),
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
     附近屋顶
     
     - parameter lat:
     - parameter lng:
     - parameter success:
     - parameter failure: 
     */
    func getNearRoof(lat : Double, lng : Double, success: ((roofList: NSArray) -> Void)?, failure: ((msg: String?) -> Void)?) {
        let url = Constants.httpHost + "roof/nearby_roofs"
        let params = [
            "latitude" : lat,
            "longitude" : lng,
            "_o" : 1
        ]
        let jsonStr = self.dataToJsonString(params)
        let newParams = ["edata" : jsonStr.AES256EncryptWithKey(Constants.aeskey)]
        self.get(url, params: newParams, success: { (msg, data) in
            let array = RoofInfo.mj_objectArrayWithKeyValuesArray(data)
            success?(roofList: array)
            }, failure: failure)
    }

}
