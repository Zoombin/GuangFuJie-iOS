//
//  InstallHeaderCell.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/12.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class InstallHeaderCell: UITableViewCell {
    var viewCreated = false
    
    var nickNameLabel: UILabel!
    var noticeButton: UIButton!
    var avatarImageView: UIImageView!
    
    var statusButton: UIButton!
    var tipsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initCell() {
        if (viewCreated) {
            return
        }
        viewCreated = true
        let cellHeight = InstallHeaderCell.cellHeight()
        
        let avatarWidth = cellHeight * 0.6
        let avatarHeight = avatarWidth
        let startX = (PhoneUtils.kScreenWidth - avatarWidth) / 2
        let startY = cellHeight * 0.1
        
        let labelWidth = PhoneUtils.kScreenWidth
        let labelHeight = cellHeight * 0.2
        
        avatarImageView = UIImageView.init(frame: CGRectMake(startX, startY, avatarWidth, avatarHeight))
        avatarImageView.image = UIImage(named: "ic_avstar")
        self.contentView.addSubview(avatarImageView)
        
        nickNameLabel = UILabel.init(frame: CGRectMake(0, avatarHeight + startY, labelWidth, labelHeight))
        nickNameLabel.text = "用户名"
        nickNameLabel.textAlignment = NSTextAlignment.Center
        nickNameLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        self.contentView.addSubview(nickNameLabel)
        
        noticeButton = UIButton.init(type: UIButtonType.Custom)
        noticeButton.frame = CGRectMake((startX - 60) / 2, (cellHeight - 20) / 2, 60, 20)
        noticeButton.backgroundColor = Colors.installColor
        noticeButton.setTitle("通知审核", forState: UIControlState.Normal)
        noticeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        noticeButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        self.contentView.addSubview(noticeButton)
        
        statusButton = UIButton.init(type: UIButtonType.Custom)
        statusButton.frame = CGRectMake(PhoneUtils.kScreenWidth - ((startX - 60) / 2) - 60, (cellHeight - 20) / 2, 60, 20)
        statusButton.setBackgroundImage(UIImage(named: "ic_identity_unauth"), forState: UIControlState.Normal)
        statusButton.setBackgroundImage(UIImage(named: "ic_identity_auth"), forState: UIControlState.Selected)
        self.contentView.addSubview(statusButton)
        
        tipsLabel = UILabel.init(frame: CGRectMake(0, CGRectGetMaxY(noticeButton.frame), startX, 20))
        tipsLabel.text = "已提交资料，通知客服审核"
        tipsLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall3)
        tipsLabel.textAlignment = NSTextAlignment.Center
        self.contentView.addSubview(tipsLabel)
        
        let user = UserDefaultManager.getUser()!
        if (user.is_installer?.integerValue == 2) {
            statusButton.selected = true
            noticeButton.hidden = true
            tipsLabel.hidden = true
        } else {
            statusButton.selected = false
            noticeButton.hidden = false
            tipsLabel.hidden = false
        }
        nickNameLabel.text = user.user_name
        
    }
    
    static func cellHeight() -> CGFloat {
        if (PhoneUtils.kScreenWidth == 320) {
            return 90
        } else if (PhoneUtils.kScreenWidth == 375) {
            return 100
        } else {
            return 110
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
