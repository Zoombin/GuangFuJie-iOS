//
//  NewsCell.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/3/6.
//  Copyright © 2017年 颜超. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    var hasInit = false
    var newsImageView = UIImageView()
    var contentLabel = TopLeftLabel()
    var timeLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        if (hasInit) {

        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        if (hasInit) {
            return
        }
        self.contentView.backgroundColor = UIColor.white
        let dir: CGFloat = 8
        let width: CGFloat = PhoneUtils.kScreenWidth
        let height: CGFloat = NewsCell.cellHeight()
        
        let imgHeight = height - dir * 2
        let imgWidth = imgHeight * 1.2
        newsImageView.frame = CGRect(x: dir,y: dir, width: imgWidth, height: imgHeight)
        newsImageView.backgroundColor = Colors.bkgColor
        self.contentView.addSubview(newsImageView)
        
        contentLabel.frame = CGRect(x: newsImageView.frame.maxX + dir,y: dir, width: width - imgWidth - 3 * dir, height: imgHeight - 15)
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        contentLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        self.contentView.addSubview(contentLabel)
        
        timeLabel.frame = CGRect(x: newsImageView.frame.maxX + dir,y: contentLabel.frame.maxY, width: width - imgWidth - 3 * dir, height: 15)
        timeLabel.textColor = UIColor.lightGray
        timeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        self.contentView.addSubview(timeLabel)
        
        let line = UILabel.init(frame: CGRect(x: 0, y: NewsCell.cellHeight() - 2, width: width, height: 2))
        line.backgroundColor = Colors.bkgColor
        self.contentView.addSubview(line)
        
        hasInit = true
    }
    
    func setData(model: NewsInfo) {
        newsImageView.setImageWith(URL.init(string: StringUtils.getString(model.titleImage))!)
        timeLabel.text = StringUtils.getString(model.createdDate)
        contentLabel.text = StringUtils.getString(model.intro)
    }
    
    static func cellHeight() -> CGFloat {
        return PhoneUtils.kScreenHeight / 8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
