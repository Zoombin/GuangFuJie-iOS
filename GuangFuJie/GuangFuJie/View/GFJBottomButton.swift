//
//  GFJBottomButton.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/22.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class GFJBottomButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 6.0
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
