//
//  QuestionInfo.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/9/13.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class QuestionInfo: NSObject {
    var id: NSNumber?
    var question: String?  //问题标题
    var answer: String?  //回答
    var user_id: NSNumber?  // 用户id
    var type_id: NSNumber?  //类型
    var is_answered: NSNumber? // 1已回答 0未回答
    var created_date: String?
    var update_date: String?
}
