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
    
    func setData(model: NewsInfo) {
        self.newsImageView.setImageWith(URL.init(string: StringUtils.getString(model.titleImage))!)
        self.timeLabel.text = StringUtils.getString(model.createdDate)
        self.contentLabel.text = StringUtils.getString(model.intro)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
