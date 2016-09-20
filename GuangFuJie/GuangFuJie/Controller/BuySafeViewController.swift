//
//  BuySafeViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/10.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class BuySafeViewController: BaseViewController {
    var priceLabel : UILabel!
    var totalLabel : UILabel!
    var scrollView : UIScrollView!
    var yearsTextField : UITextField!
    var tipsLabel : UILabel!
    
    var types = NSMutableArray()
    let BUTTON_TAG = 1000
    
    let offSetX : CGFloat = 5
    let offSetY : CGFloat = 5
    let labelHeight = PhoneUtils.kScreenHeight / 9
    var insureModel : InsuranceType?
    
    var baoe1Label : UILabel!
    var baoe2Label : UILabel!
    var baoe3Label : UILabel!
    var totalBaoeLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "购买保险"
        // Do any additional setup after loading the view.
        initView()
        loadInsuranceInfo()
    }
    
    func loadInsuranceInfo() {
        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.insuranceType({ (typeList, totalCount) in
                self.hideHud()
//                self.totalLabel.text = "累计投保:" + String(totalCount) + "份"
                self.totalLabel.text = "累计投保:3000+"
                self.types.addObjectsFromArray(typeList as [AnyObject])
                self.addTypeView()
            }) { (msg) in
                self.hideHud()
                self.showHint(msg)
        }
    }
    
    func addTypeView() {
        let startY = CGRectGetMaxY(totalLabel.frame) + labelHeight * 0.1
        let width = (PhoneUtils.kScreenWidth - offSetX * 4) / 4
        let height = PhoneUtils.kScreenHeight / 16
        let titleLabel1 = UILabel.init(frame: CGRectMake(0, startY, width, height))
        titleLabel1.text = "电站大小"
        titleLabel1.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        titleLabel1.textAlignment = NSTextAlignment.Center
        scrollView.addSubview(titleLabel1)
        
        var line : CGFloat = 0
        var index : CGFloat = 0
        var currentY : CGFloat = startY
        for i in 0..<types.count {
            print(i)
            if (i != 0 && i%3 == 0) {
                index = 0
                line += 1
            }
            let insureType = types[i] as! InsuranceType
            let button = UIButton.init(type: UIButtonType.Custom)
            button.frame = CGRectMake(CGRectGetMaxX(titleLabel1.frame) + offSetX + index * offSetX + width * index,startY + line * offSetY + height * line, width, height)
            button.setTitle(String(insureType.size!), forState: UIControlState.Normal)
            button.layer.borderColor = UIColor.blackColor().CGColor
            button.layer.borderWidth = 1
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
            button.tag = BUTTON_TAG + i
            button.addTarget(self, action: #selector(self.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            scrollView.addSubview(button)
            currentY = CGRectGetMaxY(button.frame)
            index += 1
        }
        
        let phoneButton = UIButton.init(type: UIButtonType.Custom)
        phoneButton.frame = CGRectMake(CGRectGetMaxX(titleLabel1.frame) + offSetX,currentY + offSetY, width * 3 + offSetX * 2, height)
        phoneButton.setTitle("特殊电站大小，请联系客户询价", forState: UIControlState.Normal)
        phoneButton.layer.borderColor = UIColor.blackColor().CGColor
        phoneButton.layer.borderWidth = 1
        phoneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        phoneButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        phoneButton.addTarget(self, action: #selector(self.tellPhoneUsButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(phoneButton)
        currentY = CGRectGetMaxY(phoneButton.frame)
        
        let titleLabel3 = UILabel.init(frame: CGRectMake(0, currentY + offSetY, width, height))
        titleLabel3.text = "保障金额"
        titleLabel3.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        titleLabel3.textAlignment = NSTextAlignment.Center
        scrollView.addSubview(titleLabel3)
        
        let titleWidth = (width * 3 + offSetX * 2) / 3
        let titleHeight = height
        let titles = ["保险标的", "保额", "保额合计", "光伏发电设备", "", "", "设备盗抢", "", "", "第三者责任", "", ""]
        var tline = 0
        var tindex = 0
        for i in 0..<titles.count {
            if (i != 0 && i%3 == 0) {
                tline += 1
                tindex = 0
            }
            var tmpHeight = titleHeight
            if (i == 5) {
                tmpHeight = titleHeight * 3
            }
            if (i == 8 || i == 11) {
                continue
            }
            
            let label = UILabel.init(frame: CGRectMake(CGRectGetMaxX(titleLabel3.frame) + offSetX + CGFloat(tindex) * titleWidth, titleLabel3.frame.origin.y  + CGFloat(tline) * titleHeight, titleWidth, tmpHeight))
            label.text = titles[i]
            label.textAlignment = NSTextAlignment.Center
            label.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
            label.layer.borderColor = UIColor.blackColor().CGColor
            label.layer.borderWidth = 1.0
            scrollView.addSubview(label)
            if (i == 5) {
                totalBaoeLabel = label
            }
            if (i == 4) {
                baoe1Label = label
            }
            if (i == 7) {
                baoe2Label = label
            }
            if (i == 10) {
                baoe3Label = label
            }
            tindex += 1
            currentY = CGRectGetMaxY(label.frame)
        }
        
        let titleLabel2 = UILabel.init(frame: CGRectMake(0, currentY + offSetY, width, height))
        titleLabel2.text = "保障时间"
        titleLabel2.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        titleLabel2.textAlignment = NSTextAlignment.Center
        scrollView.addSubview(titleLabel2)
        
        yearsTextField = UITextField.init(frame: CGRectMake(CGRectGetMaxX(titleLabel2.frame) + offSetX, currentY + offSetY, width, height))
        yearsTextField.layer.borderColor = UIColor.blackColor().CGColor
        yearsTextField.layer.borderWidth = 1
        yearsTextField.rightViewMode = UITextFieldViewMode.Always
        yearsTextField.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        yearsTextField.textAlignment = NSTextAlignment.Center
        scrollView.addSubview(yearsTextField)
        
        let yearsLabel = UILabel.init(frame: CGRectMake(0, 0, width / 4, height))
        yearsLabel.text = "年"
        yearsLabel.textColor = UIColor.blackColor()
        yearsLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        yearsTextField.rightView = yearsLabel
        
        tipsLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(yearsTextField.frame), CGRectGetMinY(titleLabel2.frame), PhoneUtils.kScreenWidth - CGRectGetMaxX(yearsTextField.frame), height))
        tipsLabel.textColor = UIColor.darkGrayColor()
        tipsLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        tipsLabel.numberOfLines = 0
        tipsLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        tipsLabel.text = "今日购买生效时间" + PhoneUtils.getTommorrowDateStr(NSDate()) + " 00:00:00"
        scrollView.addSubview(tipsLabel)
        
        let titleLabel4 = UILabel.init(frame: CGRectMake(0, CGRectGetMaxY(titleLabel2.frame) + offSetY, width, height))
        titleLabel4.text = "保险条款"
        titleLabel4.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        titleLabel4.textAlignment = NSTextAlignment.Center
        scrollView.addSubview(titleLabel4)
        
        let viewButton1 = UIButton.init(type: UIButtonType.Custom)
        viewButton1.frame = CGRectMake(CGRectGetMaxX(titleLabel4.frame) + offSetX,CGRectGetMaxY(titleLabel2.frame) + offSetY, width * 1.5, height)
        viewButton1.backgroundColor = Colors.installColor
        viewButton1.setTitle("查看保险条款", forState: UIControlState.Normal)
        viewButton1.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        viewButton1.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        viewButton1.addTarget(self, action: #selector(self.viewButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        viewButton1.tag = 1
        scrollView.addSubview(viewButton1)
        
        let titleLabel5 = UILabel.init(frame: CGRectMake(0, CGRectGetMaxY(titleLabel4.frame) + offSetY, width, height))
        titleLabel5.text = "保险范本"
        titleLabel5.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        titleLabel5.textAlignment = NSTextAlignment.Center
        scrollView.addSubview(titleLabel5)
        
        let viewButton2 = UIButton.init(type: UIButtonType.Custom)
        viewButton2.frame = CGRectMake(CGRectGetMaxX(titleLabel5.frame) + offSetX,CGRectGetMaxY(titleLabel4.frame) + offSetY, width * 1.5, height)
        viewButton2.backgroundColor = Colors.installColor
        viewButton2.setTitle("电子保单范本", forState: UIControlState.Normal)
        viewButton2.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        viewButton2.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        viewButton2.addTarget(self, action: #selector(self.viewButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        viewButton2.tag = 2
        scrollView.addSubview(viewButton2)
        
        let viewButton3 = UIButton.init(type: UIButtonType.Custom)
        viewButton3.frame = CGRectMake(CGRectGetMaxX(viewButton2.frame) + offSetX,CGRectGetMaxY(titleLabel4.frame) + offSetY, width * 1.5, height)
        viewButton3.backgroundColor = Colors.installColor
        viewButton3.setTitle("纸质保单范本", forState: UIControlState.Normal)
        viewButton3.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        viewButton3.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        viewButton3.addTarget(self, action: #selector(self.viewButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        viewButton3.tag = 3
        scrollView.addSubview(viewButton3)
        
        currentY = CGRectGetMaxY(titleLabel5.frame)
        
        scrollView.contentSize = CGSizeMake(0, currentY + 1)
    }
    
    func viewButtonClicked(sender : UIButton) {
        let vc = PhotoViewController()
        if (sender.tag == 1) {
            vc.type = 1
        } else if (sender.tag == 2) {
            vc.type = 2
        } else {
            vc.type = 3
        }
        self.pushViewController(vc)
    }
    
    func tellPhoneUsButtonClicked() {
        UIApplication.sharedApplication().openURL(NSURL.init(string: "tel://4006229666")!)
    }
    
    func buttonClicked(sender : UIButton) {
        for i in 0..<types.count {
            let button = scrollView.viewWithTag(i + BUTTON_TAG)
            button!.layer.borderColor = UIColor.blackColor().CGColor
            button!.layer.borderWidth = 1
        }
        sender.layer.borderColor = Colors.installColor.CGColor
        sender.layer.borderWidth = 1
        
        let insureType = types[sender.tag - BUTTON_TAG] as! InsuranceType
        insureModel = insureType
        priceLabel.text = "￥:" + String(insureType.price!) + "元"
        
        let size = NSString.init(string: insureType.size!)
        size.stringByReplacingOccurrencesOfString("KW", withString: "")
        let sizeFloat : CGFloat = CGFloat(size.floatValue)
        
        let baoe1 : CGFloat = sizeFloat * 0.7
        let baoe2 : CGFloat = sizeFloat * 0.7
        let baoe3 : CGFloat = 2.0
        let total : CGFloat = baoe1 + baoe2 + baoe3
        baoe1Label.text = String(format: "%.1f万", baoe1)
        baoe2Label.text = String(format: "%.1f万", baoe2)
        baoe3Label.text = String(format: "%.1f万", baoe3)
        totalBaoeLabel.text = String(format: "%.1f万/年", total)
    }
    
    func buyNow() {
        if (yearsTextField.text!.isEmpty) {
            self.showHint("请输入年限")
            return
        }
        if (insureModel == nil) {
            self.showHint("请选择电站大小")
            return
        }
        let vc = ApplyForOrderViewController()
        vc.insuranceType = insureModel
        vc.years = yearsTextField.text
        self.pushViewController(vc)
    }
    
    func initView() {
        let buyBottomView = UIView.init(frame: CGRectMake(0, self.view.frame.size.height - 50, PhoneUtils.kScreenWidth, 50))
        buyBottomView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(buyBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = buyBottomView.frame.size.height - 5 * 2
        
        let buyNowButton = UIButton.init(type: UIButtonType.Custom)
        buyNowButton.frame = CGRectMake(5, 5, buttonWidth, buttonHeight)
        buyNowButton.setTitle("立即购买", forState: UIControlState.Normal)
        buyNowButton.backgroundColor = Colors.installColor
        buyNowButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buyNowButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge2)
        buyNowButton.addTarget(self, action: #selector(self.buyNow), forControlEvents: UIControlEvents.TouchUpInside)
        buyBottomView.addSubview(buyNowButton)
        
        scrollView = UIScrollView.init(frame: CGRectMake(0, 64, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - buyBottomView.frame.size.height - 64))
        self.view.addSubview(scrollView)
        
        let topImageView = UIImageView.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, (PhoneUtils.kScreenWidth * 447) / 640))
        topImageView.image = UIImage(named: "ic_insure")
        scrollView.addSubview(topImageView)
        
        let labelHeight = PhoneUtils.kScreenHeight / 10
        priceLabel = UILabel.init(frame: CGRectMake(0, CGRectGetMaxY(topImageView.frame), PhoneUtils.kScreenWidth * 0.3, labelHeight))
        priceLabel.textColor = Colors.installRedColor
        priceLabel.text = "￥: 0元"
        priceLabel.textAlignment = NSTextAlignment.Center
        scrollView.addSubview(priceLabel)
        
        let noticeLabel = UILabel.init(frame: CGRectMake(PhoneUtils.kScreenWidth * 0.3, CGRectGetMaxY(topImageView.frame), PhoneUtils.kScreenWidth * 0.7, labelHeight))
        noticeLabel.textColor = Colors.lightGray
        noticeLabel.text = "注:一个屋顶电站只能购买一份保险，不可叠加购买"
        noticeLabel.numberOfLines = 0
        noticeLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        noticeLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        scrollView.addSubview(noticeLabel)
        
        totalLabel = UILabel.init(frame: CGRectMake((PhoneUtils.kScreenWidth * 0.7) - offSetX, CGRectGetMaxY(noticeLabel.frame) + labelHeight * 0.1, PhoneUtils.kScreenWidth * 0.3, labelHeight * 0.5))
        totalLabel.textAlignment = NSTextAlignment.Center
        totalLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        totalLabel.backgroundColor = Colors.installColor
        totalLabel.textColor = UIColor.whiteColor()
        scrollView.addSubview(totalLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
