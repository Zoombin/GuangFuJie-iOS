//
//  NewsV2Cell.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/11/3.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class NewsV2Cell: UITableViewCell {
    var hasInit = false
    var newsImageView = UIImageView()
    var contentLabel = YCTopLeftLabel()
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
        let times = YCPhoneUtils.screenWidth / 375
        self.contentView.backgroundColor = UIColor.white
        let dir: CGFloat = 8 * times
        let width: CGFloat = YCPhoneUtils.screenWidth
        let height: CGFloat = NewsV2Cell.cellHeight()
        
        let imgHeight = height - dir * 2
        let imgWidth = imgHeight
        newsImageView.frame = CGRect(x: dir,y: dir, width: imgWidth, height: imgHeight)
        newsImageView.backgroundColor = Colors.bkgColor
        self.contentView.addSubview(newsImageView)
        
        contentLabel.frame = CGRect(x: newsImageView.frame.maxX + dir,y: dir, width: width - imgWidth - 3 * dir, height: imgHeight - 15)
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        contentLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        contentLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        self.contentView.addSubview(contentLabel)
        
        timeLabel.frame = CGRect(x: newsImageView.frame.maxX + dir,y: contentLabel.frame.maxY, width: width - imgWidth - 3 * dir, height: 15)
        timeLabel.textColor = UIColor.lightGray
        timeLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        self.contentView.addSubview(timeLabel)
        
        let line = UILabel.init(frame: CGRect(x: 0, y: NewsV2Cell.cellHeight() - 2, width: width, height: 2))
        line.backgroundColor = Colors.bkgColor
        self.contentView.addSubview(line)
        
        hasInit = true
    }
    
    func setData(model: ArticleInfo) {
        newsImageView.setImageWith(URL.init(string: YCStringUtils.getString(model.image))!)
        timeLabel.text = YCStringUtils.getString(model.created_date)
        contentLabel.text = YCStringUtils.getString(model.title)
    }
    
    static func cellHeight() -> CGFloat {
        return 100 * (YCPhoneUtils.screenWidth / 375)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
