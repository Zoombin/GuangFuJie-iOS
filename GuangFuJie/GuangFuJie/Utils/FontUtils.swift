//
//  FontUtils.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/6.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class FontUtils: NSObject {
    //字体大小的偏移量
    static func getFontSize(size: CGFloat) -> CGFloat {
        if (PhoneUtils.kScreenWidth == 320) {
            return size - 2
        } else if (PhoneUtils.kScreenWidth == 375) {
            return size
        } else {
            return size + 2
        }
    }
}


