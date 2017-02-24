//
//  StringUtils.swift
//  HeTianYu
//
//  Created by 颜超 on 16/6/20.
//  Copyright © 2016年 Zoombin. All rights reserved.
//

import UIKit

class StringUtils: NSObject {
    static func getString(_ str : String?) -> String {
        if(str == nil) {
           return ""
        }
        return str!
    }
    
    static func getNumber(_ num : NSNumber?) -> NSNumber {
        if(num == nil) {
            return 0
        }
        return num!
    }
    
    static func isEmpty(_ str : String) -> Bool{
        return str.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
    }
}
