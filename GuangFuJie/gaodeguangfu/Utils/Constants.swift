//
//  Constants.swift
//  SevenThousand
//
//  Created by 颜超 on 16/6/22.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class Constants: NSObject {
    static let umAppKey = "591feb47c62dca65260013c3"
    static let project = "gaodeguangfu"
    static let projectName = "高得光伏"
    static let bannerImages = ["ic_test_ad001", "ic_test_ad002"]
    static let bannerImageWidth: CGFloat = 750
    static let bannerImageHeight: CGFloat = 313
    
    //QA
//    static let httpHost = "https://guangfujie.zoombin.com:3002/api/"
//    static let payKey = "4d6af0de-2542-433e-a361-73ef59805d35"
//    static let paySecret = "3f339c0c-4c11-464b-b8bd-8fad7ab3717c"
//    static let isSandBox = true
    
    //线上
    static let httpHost = "https://guangfujie.zoombin.com:8002/api/"
    static let payKey = "4d6af0de-2542-433e-a361-73ef59805d35"
    static let paySecret = "30e71391-4bca-402b-869e-bc7e118bce6f"
    static let isSandBox = false
    
    //本地
//    static let httpHost = "http://localhost:3002/api/"
//    static let payKey = "4d6af0de-2542-433e-a361-73ef59805d35"
//    static let paySecret = "3f339c0c-4c11-464b-b8bd-8fad7ab3717c"
//    static let isSandBox = true
    
    static let osType = 1 //ios
    static let aeskey = "e41cd1f755f211e6b56b00ff8821fdcf"
    static let baiduMapKey = "pyiRMu7BqXCpMmymllUIhjTPQsvIGCUp"
    
}
