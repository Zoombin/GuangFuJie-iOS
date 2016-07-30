//
//  ABoutUsView.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/7/30.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class ABoutUsView: UIView {
    @IBOutlet weak var label1 : UILabel?
    @IBOutlet weak var label2 : UILabel?
    @IBOutlet weak var label3 : UILabel?
    @IBOutlet weak var label4 : UILabel?

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func bkgButtonClicked(sender : UIButton) {
        self.hidden = true
    }
    
    func addUnderLine() {
        let attribtDic = [NSUnderlineStyleAttributeName : (NSUnderlineStyle.StyleSingle.rawValue)]
        let attribtStr1 = NSMutableAttributedString.init(string: "关于我们", attributes: attribtDic)
        label1?.attributedText = attribtStr1
        let attribtStr2 = NSMutableAttributedString.init(string: "电话: 400-6229-666", attributes: attribtDic)
        label2?.attributedText = attribtStr2
        let attribtStr3 = NSMutableAttributedString.init(string: "网站: www.pvsr.cn", attributes: attribtDic)
        label3?.attributedText = attribtStr3
        let attribtStr4 = NSMutableAttributedString.init(string: "公司地址: 江苏省苏州市工业园区独墅湖仁爱路一号", attributes: attribtDic)
        label4?.attributedText = attribtStr4
    }
}
