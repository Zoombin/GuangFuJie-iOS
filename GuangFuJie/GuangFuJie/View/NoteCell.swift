//
//  NoteCell.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/15.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    var hasInit = false
    var nameLabel: UILabel!
    var timeLabel: UILabel!
    var phoneLabel: UILabel!
    var addressLabel: UILabel!
    var noteLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let times = YCPhoneUtils.screenWidth / 375
        let offSetx = 10 * times
        
        let contentWidth = YCPhoneUtils.screenWidth - offSetx * 2
        
        nameLabel = UILabel.init(frame: CGRect(x: offSetx, y: 0, width: contentWidth * 0.4, height: 50 * times))
        nameLabel.textColor = Colors.appBlue
        nameLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        self.contentView.addSubview(nameLabel)
        
        timeLabel = UILabel.init(frame: CGRect(x: nameLabel.frame.maxX, y: 0, width: contentWidth * 0.6, height: 50 * times))
        timeLabel.textAlignment = NSTextAlignment.right
        timeLabel.textColor = UIColor.lightGray
        timeLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        self.contentView.addSubview(timeLabel)
        
        phoneLabel = UILabel.init(frame: CGRect(x: offSetx, y: timeLabel.frame.maxY, width: contentWidth, height: (100 * times) / 3))
        phoneLabel.textColor = UIColor.black
        phoneLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        self.contentView.addSubview(phoneLabel)
        
        addressLabel = UILabel.init(frame: CGRect(x: offSetx, y: phoneLabel.frame.maxY, width: contentWidth, height: (100 * times) / 3))
        addressLabel.textColor = UIColor.black
        addressLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        self.contentView.addSubview(addressLabel)
        
        noteLabel = UILabel.init(frame: CGRect(x: offSetx, y: addressLabel.frame.maxY, width: contentWidth, height: (100 * times) / 3))
        noteLabel.textColor = UIColor.black
        noteLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        self.contentView.addSubview(noteLabel)
        
        let line = UILabel.init(frame: CGRect(x: offSetx, y: timeLabel.frame.maxY, width: contentWidth, height: 1))
        line.backgroundColor = Colors.bkgColor
        self.contentView.addSubview(line)
        
        let line2 = UILabel.init(frame: CGRect(x: 0, y: noteLabel.frame.maxY, width: YCPhoneUtils.screenWidth, height: 10 * times))
        line2.backgroundColor = Colors.bkgColor
        self.contentView.addSubview(line2)
    }
    
    func setData(note: NoteInfo) {
        nameLabel.text = YCStringUtils.getString(note.title)
        timeLabel.text = "最后跟进日期：" + YCStringUtils.getString(note.created_date)
        phoneLabel.text = "电话：" + YCStringUtils.getString(note.phone)
        addressLabel.text = "地址：" + YCStringUtils.getString(note.address)
        noteLabel.text = "备注：" + YCStringUtils.getString(note.msg)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func cellHeight() -> CGFloat {
        let times = YCPhoneUtils.screenWidth / 375
        return 160 * times
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
