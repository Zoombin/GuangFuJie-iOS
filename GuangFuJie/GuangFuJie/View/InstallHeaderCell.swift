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
        
        avatarImageView = UIImageView.init(frame: CGRect(x: startX, y: startY, width: avatarWidth, height: avatarHeight))
        avatarImageView.image = UIImage(named: "ic_avstar")
        self.contentView.addSubview(avatarImageView)
        
        nickNameLabel = UILabel.init(frame: CGRect(x: 0, y: avatarHeight + startY, width: labelWidth, height: labelHeight))
        nickNameLabel.text = "用户名"
        nickNameLabel.textAlignment = NSTextAlignment.center
        nickNameLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        self.contentView.addSubview(nickNameLabel)
        
        noticeButton = UIButton.init(type: UIButtonType.custom)
        noticeButton.frame = CGRect(x: (startX - 60) / 2, y: (cellHeight - 20) / 2, width: 60, height: 20)
        noticeButton.backgroundColor = Colors.installColor
        noticeButton.setTitle("通知审核", for: UIControlState.normal)
        noticeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        noticeButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        self.contentView.addSubview(noticeButton)
        
        statusButton = UIButton.init(type: UIButtonType.custom)
        statusButton.frame = CGRect(x: PhoneUtils.kScreenWidth - ((startX - 60) / 2) - 60, y: (cellHeight - 20) / 2, width: 60, height: 20)
        statusButton.setBackgroundImage(UIImage(named: "ic_identity_unauth"), for: UIControlState.normal)
        statusButton.setBackgroundImage(UIImage(named: "ic_identity_auth"), for: UIControlState.selected)
        self.contentView.addSubview(statusButton)
        
        tipsLabel = UILabel.init(frame: CGRect(x: 0, y: (noticeButton.frame).maxY, width: startX, height: 20))
        tipsLabel.text = "已提交资料，通知客服审核"
        tipsLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall3)
        tipsLabel.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(tipsLabel)
        
        let user = UserDefaultManager.getUser()!
        if (user.is_installer?.int32Value == 2) {
            statusButton.isSelected = true
            noticeButton.isHidden = true
            tipsLabel.isHidden = true
        } else {
            statusButton.isSelected = false
            noticeButton.isHidden = false
            tipsLabel.isHidden = false
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
