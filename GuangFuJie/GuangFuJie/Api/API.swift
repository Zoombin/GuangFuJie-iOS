//
//  API.swift
//  SevenThousand
//
//  Created by 颜超 on 16/6/22.
//  Copyright © 2016年 颜超. All rights reserved.
//


import UIKit

class API: NSObject {

    static let sharedInstance = API()

    private var _manager: AFHTTPSessionManager?

    private override init() {
         super.init()
        _manager = AFHTTPSessionManager()
        _manager?.responseSerializer = AFHTTPResponseSerializer();
    }

    func post(url: String, params: AnyObject?, success: ((data: AnyObject?) -> Void)?, failure: ((msg: String?) -> Void)?) {
        NSLog("====> post发送 ===> \n\(url)  \(params)")
        _manager?.POST(url, parameters: params, success: { (operation, data) in
            var dict = try? NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments)
            if (dict == nil && data != nil) {
                //解析失败可能是加密过了...
                let resultStr = String.init(data: data as! NSData, encoding: NSUTF8StringEncoding)
                let decodeStr = resultStr!.AES256DecryptWithKey(Constants.aeskey)
                let decodeData = decodeStr.dataUsingEncoding(NSUTF8StringEncoding)
                dict = try? NSJSONSerialization.JSONObjectWithData(decodeData!, options: NSJSONReadingOptions.AllowFragments)
            }
            if (dict == nil) {
                failure?(msg: "请求出错，请检查您的网络！")
                return
            }
            if let errorCode = dict?.objectForKey("error")?.integerValue {
                if errorCode == 0 {
                    let data = dict?.objectForKey("data")
                    NSLog("====> post返回 ===> \(data)")
                    success?(data: data)
                } else {
                    failure?(msg: dict?.objectForKey("msg") as? String)
                }
            }
            }, failure: { (operation, error) in
                failure?(msg: "请求出错，请检查您的网络！")
        })
    }

    func get(url: String, params: AnyObject?, success: ((msg: String?, data: AnyObject?) -> Void)?, failure: ((msg: String?) -> Void)?) {
        NSLog("====> get发送 ===> \n\(url)  \(params)")
        _manager?.GET(url, parameters: params, success: { (operation, data) in
            var dict = try? NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments)
            if (dict == nil && data != nil) {
                //解析失败可能是加密过了...
                let resultStr = String.init(data: data as! NSData, encoding: NSUTF8StringEncoding)
                let decodeStr = resultStr!.AES256DecryptWithKey(Constants.aeskey)
                let decodeData = decodeStr.dataUsingEncoding(NSUTF8StringEncoding)
                dict = try? NSJSONSerialization.JSONObjectWithData(decodeData!, options: NSJSONReadingOptions.AllowFragments)
            }
            if (dict == nil) {
                failure?(msg: "请求出错，请检查您的网络！")
                return
            }
            if let errorCode = dict?.objectForKey("error")?.integerValue {
                if errorCode == 0 {
                    let data = dict?.objectForKey("data")
                    var msg = dict?.objectForKey("msg") as? String
                    if (msg == nil) {
                        msg = "请求成功"
                    }
                    NSLog("====> get返回 ===> \(data)")
                    success?(msg: msg, data: data)
                } else {
                    failure?(msg: dict?.objectForKey("msg") as? String)
                }
            }
            }, failure: { (operation, error) in
                failure?(msg: "请求出错，请检查您的网络！")
        })
    }
    
    func goodWeGet(url: String, params: AnyObject?, success: ((data: AnyObject?) -> Void)?, failure: ((msg: String?) -> Void)?) {
        NSLog("====> get发送 ===> \n\(url)  \(params)")
        _manager?.GET(url, parameters: params, success: { (operation, data) in
            var dict = try? NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.AllowFragments)
            if (dict == nil) {
                failure?(msg: "请求出错，请检查您的网络！")
                return
            }
            success?(data: dict)
            }, failure: { (operation, error) in
                failure?(msg: "请求出错，请检查您的网络！")
        })
    }

    func dataToJsonString(object : AnyObject) -> String{
        var jsonString = ""
        let jsonData = try?NSJSONSerialization.dataWithJSONObject(object, options: NSJSONWritingOptions.PrettyPrinted)
        if (jsonData != nil) {
            jsonString = String.init(data: jsonData!, encoding: NSUTF8StringEncoding)!
        }
        return jsonString
    }
}
