//
//  NewsCellTableViewCell.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/10.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(model: ArticleInfo) {
        self.newsImageView.setImageWith(URL.init(string: YCStringUtils.getString(model.image))!)
        self.timeLabel.text = YCStringUtils.getString(model.created_date)
        self.contentLabel.text = YCStringUtils.getString(model.title)
        
        self.contentLabel.font = UIFont.systemFont(ofSize: FontUtils.getFontSize(size: 17))
        self.timeLabel.font = UIFont.systemFont(ofSize: FontUtils.getFontSize(size: 15))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
