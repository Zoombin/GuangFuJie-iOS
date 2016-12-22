//
//  CustomTextField.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/7/30.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext();
        context!.setFillColor(UIColor.lightGray.cgColor);
        context!.fill(CGRect(x: 0, y: self.frame.height - 0.5, width: self.frame.width, height: 0.5));
    }

}
