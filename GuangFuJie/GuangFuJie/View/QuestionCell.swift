//
//  QuestionCell.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/11/12.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {
    var hasInit = false
    var titleLabel: UILabel!
    var contentLabel: UILabel!
    var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if (hasInit == true) {
            return
        }
        hasInit = true
        let times = YCPhoneUtils.screenWidth / 375
        
        titleLabel = YCTopLeftLabel.init(frame: CGRect(x: 10 * times, y: 10 * times, width: 270 * times, height: 40 * times))
        titleLabel.text = ""
        titleLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.contentView.addSubview(titleLabel)
        
        let icons = UIImageView.init(frame: CGRect(x: 10 * times, y: titleLabel.frame.maxY + 10 * times, width: 17 * times, height: 15 * times))
        icons.image = UIImage(named: "ic_gfask_repeat")
        self.contentView.addSubview(icons)
        
        contentLabel = YCTopLeftLabel.init(frame: CGRect(x: 40 * times, y: titleLabel.frame.maxY + 10 * times, width: 240 * times, height: 85 * times))
        contentLabel.textColor = UIColor.lightGray
        contentLabel.text = ""
        contentLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        contentLabel.numberOfLines = 4
        contentLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        self.contentView.addSubview(contentLabel)
        
        statusLabel = UILabel.init(frame: CGRect(x: titleLabel.frame.maxX + 10 * times, y: titleLabel.frame.minY, width: 66 * times, height: 30 * times))
        statusLabel.layer.borderColor = Colors.answerGreen.cgColor
        statusLabel.layer.borderWidth = 1
        statusLabel.layer.cornerRadius = 6
        statusLabel.layer.masksToBounds = true
        statusLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        self.contentView.addSubview(statusLabel)
        
        let line = UILabel.init(frame: CGRect(x: 0, y: QuestionCell.cellHeight() - 1, width: YCPhoneUtils.screenWidth, height: 0.5))
        line.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(line)
    }
    
    func setData(questionInfo: QuestionInfo) {
        titleLabel.text = YCStringUtils.getString(questionInfo.question)
        contentLabel.text = YCStringUtils.getString(questionInfo.answer)
        statusLabel.text = questionInfo.is_answered!.intValue == 1 ? "已解答" : "未解答"
        statusLabel.textAlignment = NSTextAlignment.center
        statusLabel.textColor = questionInfo.is_answered!.intValue == 1 ? Colors.answerGreen : UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func cellHeight() -> CGFloat {
        let times = YCPhoneUtils.screenWidth / 375
        return 145 * times
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
