//
//  PaoPaoView.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/11/7.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

protocol PaoPaoViewDelegate : NSObjectProtocol {
    func paopaoViewClick(cor: CLLocationCoordinate2D)
}

class PaoPaoView: UIView {
    var delegate: PaoPaoViewDelegate?
    var titleLabel: UILabel!
    var describeLabel: UILabel!
    var cor: CLLocationCoordinate2D!
    
    func initView() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 6
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        
        let labelHeight = self.frame.size.height / 2
        titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: labelHeight))
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        titleLabel.textAlignment = NSTextAlignment.center
        self.addSubview(titleLabel)
        
        describeLabel = UILabel.init(frame: CGRect(x: 0, y: titleLabel.frame.maxY, width: self.frame.size.width, height: labelHeight))
        describeLabel.textColor = UIColor.black
        describeLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        describeLabel.textAlignment = NSTextAlignment.center
        self.addSubview(describeLabel)
        
        let paopaoButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.height))
        paopaoButton.addTarget(self, action: #selector(paopaoButtonClicked), for: UIControlEvents.touchUpInside)
        self.addSubview(paopaoButton)
    }
    
    func paopaoButtonClicked() {
        if (self.delegate != nil) {
            self.delegate?.paopaoViewClick(cor: cor)
        }
    }

}
