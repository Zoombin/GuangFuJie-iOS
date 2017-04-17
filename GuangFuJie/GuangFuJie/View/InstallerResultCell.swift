//
//  InstallerResultCell.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/3/14.
//  Copyright © 2017年 颜超. All rights reserved.
//

import UIKit

class InstallerResultCell: UITableViewCell {
    static var dir = 10 * (PhoneUtils.kScreenWidth / 750)
    static var times = PhoneUtils.kScreenWidth / 750
    
    
    static var companyLabelWidth = PhoneUtils.kScreenWidth - 2 * InstallerResultCell.dir
    var componyNameLabel: UILabel!
    var contractNameLabel: TopLeftLabel!
    var createTimeLabel: TopLeftLabel!
    var addressLabel: TopLeftLabel!
    var rzLabel: UIButton!
    
    var hasInit = false
    
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
        self.contentView.backgroundColor = Colors.bkgGray
        
        let bkgViewWidth = PhoneUtils.kScreenWidth - 2 * InstallerResultCell.dir
        let bkgViewHeight = InstallerResultCell.cellHeight() - InstallerResultCell.dir
        let labelHeight = bkgViewHeight / 3
        
        let bkgView = UIView.init(frame: CGRect(x: InstallerResultCell.dir, y: InstallerResultCell.dir, width: bkgViewWidth, height: bkgViewHeight))
        bkgView.backgroundColor = UIColor.white
        self.contentView.addSubview(bkgView)
        
        componyNameLabel = UILabel.init(frame: CGRect(x: InstallerResultCell.dir, y: 0, width: InstallerResultCell.companyLabelWidth, height: labelHeight))
        componyNameLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm2)
        componyNameLabel.textColor = Colors.installColor
        bkgView.addSubview(componyNameLabel)
        
//        我要认证
        rzLabel = UIButton.init(frame: CGRect(x: componyNameLabel.frame.maxX + InstallerResultCell.dir, y: labelHeight * 0.1, width: 70, height: labelHeight * 0.8))
        rzLabel.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm2)
        rzLabel.setTitleColor(Colors.installRedColor, for: UIControlState.normal)
        rzLabel.layer.borderColor = Colors.installRedColor.cgColor
        rzLabel.layer.borderWidth = 1
        rzLabel.layer.cornerRadius = 5
        rzLabel.layer.masksToBounds = true
        rzLabel.setTitle("我要认证", for: UIControlState.normal)
        rzLabel.isHidden = true
        bkgView.addSubview(rzLabel)
        
        contractNameLabel = TopLeftLabel.init(frame: CGRect(x: InstallerResultCell.dir, y: componyNameLabel.frame.maxY, width: (componyNameLabel.frame.size.width / 2) * 0.7, height: labelHeight))
        bkgView.addSubview(contractNameLabel)
        
        createTimeLabel = TopLeftLabel.init(frame: CGRect(x: contractNameLabel.frame.maxX, y: componyNameLabel.frame.maxY, width: componyNameLabel.frame.size.width / 2, height: labelHeight))
        createTimeLabel.textAlignment = NSTextAlignment.right
        bkgView.addSubview(createTimeLabel)
        
        addressLabel = TopLeftLabel.init(frame: CGRect(x: InstallerResultCell.dir, y: contractNameLabel.frame.maxY, width: componyNameLabel.frame.size.width * 0.85, height: labelHeight))
        bkgView.addSubview(addressLabel)
        
        let arrowImg = UIImageView.init(frame: CGRect(x: bkgView.frame.size.width - labelHeight, y: labelHeight * 1.1, width: labelHeight * 0.8, height: labelHeight * 0.8))
        arrowImg.image = UIImage(named: "arrow_right_gray")
        bkgView.addSubview(arrowImg)
        
        hasInit = true
    }
    
    func setData(model: InstallInfo) {
        let componyName = StringUtils.getString(model.companyName)
        let contractName = " 联系人：\(StringUtils.getString(model.corporation))"
        let createTime = " 成立时间：\(StringUtils.getString(model.establishDate))"
        let address = " 地址：\(StringUtils.getString(model.address))"
        
        let contractAttr = NSMutableAttributedString.init(string: "•\(contractName)")
        contractAttr.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: Dimens.fontSizelarge), range: NSMakeRange(0, 1))
        contractAttr.addAttribute(NSForegroundColorAttributeName, value: Colors.installColor, range: NSMakeRange(0, 1))
        contractAttr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: Dimens.fontSizeSmall), range: NSMakeRange(1, StringUtils.strLength(contractName)))
        
        let createTimeAttr = NSMutableAttributedString.init(string: "•\(createTime)")
        createTimeAttr.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: Dimens.fontSizelarge), range: NSMakeRange(0, 1))
        createTimeAttr.addAttribute(NSForegroundColorAttributeName, value: Colors.installColor, range: NSMakeRange(0, 1))
        createTimeAttr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: Dimens.fontSizeSmall), range: NSMakeRange(1, StringUtils.strLength(createTime)))
        
        let addressAttr = NSMutableAttributedString.init(string: "•\(address)")
        addressAttr.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: Dimens.fontSizelarge), range: NSMakeRange(0, 1))
        addressAttr.addAttribute(NSForegroundColorAttributeName, value: Colors.installColor, range: NSMakeRange(0, 1))
        addressAttr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: Dimens.fontSizeSmall), range: NSMakeRange(1, StringUtils.strLength(address)))
        
        var width = MSLFrameUtil.getLabWidth(componyName, fontSize: Dimens.fontSizeComm2, height: componyNameLabel.frame.size.height) + InstallerResultCell.dir
        if (width + 70 + InstallerResultCell.dir > InstallerResultCell.companyLabelWidth) {
            width = InstallerResultCell.companyLabelWidth - 70 - InstallerResultCell.dir * 2
        }
        componyNameLabel.frame = CGRect(x: componyNameLabel.frame.origin.x, y: componyNameLabel.frame.origin.y, width: width, height: componyNameLabel.frame.size.height)
        rzLabel.frame = CGRect(x: componyNameLabel.frame.maxX + InstallerResultCell.dir, y: rzLabel.frame.origin.y, width: 70, height: rzLabel.frame.size.height)
        rzLabel.isHidden = false
        
        componyNameLabel.text = componyName
        contractNameLabel.attributedText = contractAttr
        createTimeLabel.attributedText = createTimeAttr
        addressLabel.attributedText = addressAttr
    }
    
    static func cellHeight() -> CGFloat {
        return 170 * times
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
