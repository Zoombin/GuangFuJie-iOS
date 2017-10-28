//
//  BrandCell.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/10/28.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class BrandCell: UITableViewCell {

    var viewCreated = false
    var bkgImageView : UIImageView!
    
    func initCell() {
        if (viewCreated) {
            return
        }
        viewCreated = true
        
        let times = YCPhoneUtils.screenWidth / 375
        bkgImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: YCPhoneUtils.screenWidth, height: 150 * times))
        self.contentView.addSubview(bkgImageView)
    }
    
    static func cellHeight() -> CGFloat {
        let times = YCPhoneUtils.screenWidth / 375
        return 150 * times
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
