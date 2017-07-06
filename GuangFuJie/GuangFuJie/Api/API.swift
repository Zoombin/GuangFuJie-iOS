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

    fileprivate var _manager: AFHTTPSessionManager?

    fileprivate override init() {
         super.init()
        _manager = AFHTTPSessionManager()
        _manager?.responseSerializer = AFHTTPResponseSerializer();
    }

    func post(_ url: String, params: AnyObject?, success: ((_ data: AnyObject?) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        NSLog("====> post发送 ===> \n\(url)  \(params)")
        _manager?.post(url, parameters: params, success: { (operation, data) in
            var dict = try? JSONSerialization.jsonObject(with: (data as! NSData) as Data, options: JSONSerialization.ReadingOptions.allowFragments)
            if (dict == nil && data != nil) {
                //解析失败可能是加密过了...
                let resultStr = String.init(data: (data as! NSData) as Data, encoding: String.Encoding.utf8)
                let decodeStr = resultStr!.aes256Decrypt(withKey: Constants.aeskey)
                let decodeData = decodeStr?.data(using: String.Encoding.utf8)
                dict = try? JSONSerialization.jsonObject(with: decodeData!, options: JSONSerialization.ReadingOptions.allowFragments)
            }
            if (dict == nil) {
                failure?("请求出错，请检查您的网络！")
                return
            }
            if let errorCode = ((dict as! NSDictionary)["error"] as? NSNumber)?.intValue {
                if errorCode == 0 {
                    let data = (dict as! NSDictionary)["data"]
                    NSLog("====> post返回 ===> \(data)")
                    success?(data as AnyObject?)
                } else {
                    failure?((dict as! NSDictionary)["msg"] as? String)
                }
            }
        }, failure: { (operation, error) in
            failure?("请求出错，请检查您的网络！")
        })
    }

    func get(_ url: String, params: AnyObject?, success: ((_ totalCount : NSNumber?, _ msg: String?, _ data: AnyObject?) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        NSLog("====> get发送 ===> \n\(url)  \(params)")
        _manager?.get(url, parameters: params, success: { (operation, data) in
            var dict = try? JSONSerialization.jsonObject(with: (data as! NSData) as Data, options: JSONSerialization.ReadingOptions.allowFragments)
            if (dict == nil && data != nil) {
                //解析失败可能是加密过了...
                let resultStr = String.init(data: (data as! NSData) as Data, encoding: String.Encoding.utf8)
                let decodeStr = resultStr!.aes256Decrypt(withKey: Constants.aeskey)
                let decodeData = decodeStr?.data(using: String.Encoding.utf8)
                dict = try? JSONSerialization.jsonObject(with: decodeData!, options: JSONSerialization.ReadingOptions.allowFragments)
            }
            if (dict == nil) {
                failure?("请求出错，请检查您的网络！")
                return
            }
            if let errorCode = ((dict as! NSDictionary)["error"] as? NSNumber)?.intValue {
                if errorCode == 0 {
                    let data = (dict as! NSDictionary)["data"]
                    var msg = (dict as! NSDictionary)["msg"]
                    if (msg == nil) {
                        msg = "请求成功"
                    }
                    var totalCount = (dict as! NSDictionary)["totalCount"] as? NSNumber
                    if (totalCount == nil) {
                        totalCount = 0
                    }
                    NSLog("====> post返回 ===> \(data)")
                    success?(totalCount, msg as! String?, data as AnyObject?)
                } else {
                    failure?((dict as! NSDictionary)["msg"] as? String)
                }
            }
        }, failure: { (operation, error) in
            failure?("请求出错，请检查您的网络！")
        })
    }
    
    func goodWeGet(_ url: String, params: AnyObject?, success: ((_ data: AnyObject?) -> Void)?, failure: ((_ msg: String?) -> Void)?) {
        NSLog("====> get发送 ===> \n\(url)  \(params)")
        _manager?.get(url, parameters: params, success: { (operation, data) in
            let dict = try? JSONSerialization.jsonObject(with: (data as! NSData) as Data, options: JSONSerialization.ReadingOptions.allowFragments)
            if (dict == nil) {
                failure?("请求出错，请检查您的网络！")
                return
            }
            success?(dict as AnyObject?)
            }, failure: { (operation, error) in
                failure?("请求出错，请检查您的网络！")
        })
    }

    func dataToJsonString(_ object : AnyObject) -> String {
        let dict = NSMutableDictionary.init(dictionary: object as! [String : Any])
        dict["project"] = Constants.project
        print(object)
        var jsonString = ""
        let jsonData = try?JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        if (jsonData != nil) {
            jsonString = String.init(data: jsonData!, encoding: String.Encoding.utf8)!
        }
        return jsonString
    }
}
