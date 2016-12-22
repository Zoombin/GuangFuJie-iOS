//
//  BuySafeViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/10.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class BuySafeViewController: BaseViewController, UITextFieldDelegate, UIAlertViewDelegate {
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
        self.showHud(in: self.view, hint: "加载中...")
        API.sharedInstance.insuranceType({ (typeList, totalCount) in
                self.hideHud()
//                self.totalLabel.text = "累计投保:" + String(totalCount) + "份"
                self.totalLabel.text = "累计投保:3000+"
                self.types.addObjects(from: typeList as [AnyObject])
                self.addTypeView()
            }) { (msg) in
                self.hideHud()
                self.showHint(msg)
        }
    }
    
    func addTypeView() {
        let startY = totalLabel.frame.maxY + labelHeight * 0.1
        let width = (PhoneUtils.kScreenWidth - offSetX * 4) / 4
        let height = PhoneUtils.kScreenHeight / 16
        let titleLabel1 = UILabel.init(frame: CGRect(x: 0, y: startY, width: width, height: height))
        titleLabel1.text = "电站大小"
        titleLabel1.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        titleLabel1.textAlignment = NSTextAlignment.center
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
            let button = UIButton.init(type: UIButtonType.custom)
            button.frame = CGRect(x: titleLabel1.frame.maxX + offSetX + index * offSetX + width * index, y: startY + line * offSetY + height * line, width: width, height: height)
            button.setTitle(String(insureType.size!), for: UIControlState.normal)
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
            button.tag = BUTTON_TAG + i
            button.addTarget(self, action: #selector(self.buttonClicked(_:)), for: UIControlEvents.touchUpInside)
            scrollView.addSubview(button)
            currentY = button.frame.maxY
            index += 1
        }
        
        let phoneButton = UIButton.init(type: UIButtonType.custom)
        phoneButton.frame = CGRect(x: titleLabel1.frame.maxX + offSetX, y: currentY + offSetY, width: width * 3 + offSetX * 2, height: height)
        phoneButton.setTitle("特殊电站大小，请联系客户询价", for: UIControlState.normal)
        phoneButton.layer.borderColor = UIColor.black.cgColor
        phoneButton.layer.borderWidth = 1
        phoneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        phoneButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        phoneButton.addTarget(self, action: #selector(self.tellPhoneUsButtonClicked), for: UIControlEvents.touchUpInside)
        scrollView.addSubview(phoneButton)
        currentY = phoneButton.frame.maxY
        
        let titleLabel3 = UILabel.init(frame: CGRect(x: 0, y: currentY + offSetY, width: width, height: height))
        titleLabel3.text = "保障金额"
        titleLabel3.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        titleLabel3.textAlignment = NSTextAlignment.center
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
            
            let label = UILabel.init(frame: CGRect(x: titleLabel3.frame.maxX + offSetX + CGFloat(tindex) * titleWidth, y: titleLabel3.frame.origin.y  + CGFloat(tline) * titleHeight, width: titleWidth, height: tmpHeight))
            label.text = titles[i]
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
            label.layer.borderColor = UIColor.black.cgColor
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
            currentY = label.frame.maxY
        }
        
        let titleLabel2 = UILabel.init(frame: CGRect(x: 0, y: currentY + offSetY, width: width, height: height))
        titleLabel2.text = "保障时间"
        titleLabel2.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        titleLabel2.textAlignment = NSTextAlignment.center
        scrollView.addSubview(titleLabel2)
        
        yearsTextField = UITextField.init(frame: CGRect(x: titleLabel2.frame.maxX + offSetX, y: currentY + offSetY, width: width, height: height))
        yearsTextField.layer.borderColor = UIColor.black.cgColor
        yearsTextField.layer.borderWidth = 1
        yearsTextField.rightViewMode = UITextFieldViewMode.always
        yearsTextField.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        yearsTextField.textAlignment = NSTextAlignment.center
        yearsTextField.text = "1"
        yearsTextField.addTarget(self, action: #selector(valueChanged), for: UIControlEvents.allEditingEvents)
        yearsTextField.keyboardType = UIKeyboardType.numberPad
        yearsTextField.delegate = self
        scrollView.addSubview(yearsTextField)
        
        let yearsLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: width / 4, height: height))
        yearsLabel.text = "年"
        yearsLabel.textColor = UIColor.black
        yearsLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        yearsTextField.rightView = yearsLabel
        
        tipsLabel = UILabel.init(frame: CGRect(x: yearsTextField.frame.maxX, y: titleLabel2.frame.minY, width: PhoneUtils.kScreenWidth - yearsTextField.frame.maxX, height: height))
        tipsLabel.textColor = UIColor.darkGray
        tipsLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        tipsLabel.numberOfLines = 0
        tipsLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        tipsLabel.text = "今日购买生效时间" + PhoneUtils.getTommorrowDateStr(Date()) + " 00:00:00"
        scrollView.addSubview(tipsLabel)
        
        let titleLabel4 = UILabel.init(frame: CGRect(x: 0, y: titleLabel2.frame.maxY + offSetY, width: width, height: height))
        titleLabel4.text = "保险条款"
        titleLabel4.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        titleLabel4.textAlignment = NSTextAlignment.center
        scrollView.addSubview(titleLabel4)
        
        let viewButton1 = UIButton.init(type: UIButtonType.custom)
        viewButton1.frame = CGRect(x: titleLabel4.frame.maxX + offSetX, y: titleLabel2.frame.maxY + offSetY, width: width * 1.5, height: height)
        viewButton1.backgroundColor = Colors.installColor
        viewButton1.setTitle("查看保险条款", for: UIControlState.normal)
        viewButton1.setTitleColor(UIColor.white, for: UIControlState.normal)
        viewButton1.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        viewButton1.addTarget(self, action: #selector(self.viewButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        viewButton1.tag = 1
        scrollView.addSubview(viewButton1)
        
        let titleLabel5 = UILabel.init(frame: CGRect(x: 0, y: titleLabel4.frame.maxY + offSetY, width: width, height: height))
        titleLabel5.text = "保险范本"
        titleLabel5.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        titleLabel5.textAlignment = NSTextAlignment.center
        scrollView.addSubview(titleLabel5)
        
        let viewButton2 = UIButton.init(type: UIButtonType.custom)
        viewButton2.frame = CGRect(x: titleLabel5.frame.maxX + offSetX, y: titleLabel4.frame.maxY + offSetY, width: width * 1.5, height: height)
        viewButton2.backgroundColor = Colors.installColor
        viewButton2.setTitle("电子保单范本", for: UIControlState.normal)
        viewButton2.setTitleColor(UIColor.white, for: UIControlState.normal)
        viewButton2.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        viewButton2.addTarget(self, action: #selector(self.viewButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        viewButton2.tag = 2
        scrollView.addSubview(viewButton2)
        
        let viewButton3 = UIButton.init(type: UIButtonType.custom)
        viewButton3.frame = CGRect(x: viewButton2.frame.maxX + offSetX, y: titleLabel4.frame.maxY + offSetY, width: width * 1.5, height: height)
        viewButton3.backgroundColor = Colors.installColor
        viewButton3.setTitle("纸质保单范本", for: UIControlState.normal)
        viewButton3.setTitleColor(UIColor.white, for: UIControlState.normal)
        viewButton3.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        viewButton3.addTarget(self, action: #selector(self.viewButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        viewButton3.tag = 3
        scrollView.addSubview(viewButton3)
        
        currentY = titleLabel5.frame.maxY
        
        scrollView.contentSize = CGSize(width: 0, height: currentY + 1)
    }
    
    func valueChanged() {
        reSizePrice()
    }
    
    func reSizePrice() {
        if (insureModel == nil) {
            return
        }
        var years = yearsTextField.text
        if (yearsTextField.text == "") {
            years = "0"
        }
        let currentPrice = NSInteger.init(years!)! * insureModel!.price!.intValue
        priceLabel.text = "￥:\(currentPrice)元"
    }
    
    func viewButtonClicked(_ sender : UIButton) {
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
        let alertView = UIAlertView.init(title: "提示", message: "是否拨打电话给客服？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertView.show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if (alertView.cancelButtonIndex != buttonIndex) {
            UIApplication.shared.openURL(URL.init(string: "tel://4006229666")! as URL)
        }
    }
    
    func buttonClicked(_ sender : UIButton) {
        for i in 0..<types.count {
            let button = scrollView.viewWithTag(i + BUTTON_TAG)
            button!.layer.borderColor = UIColor.black.cgColor
            button!.layer.borderWidth = 1
        }
        sender.layer.borderColor = Colors.installColor.cgColor
        sender.layer.borderWidth = 1
        
        let insureType = types[sender.tag - BUTTON_TAG] as! InsuranceType
        insureModel = insureType
        
        reSizePrice()
//        priceLabel.text = "￥:" + String(insureType.price!) + "元"
        
        let size = NSString.init(string: insureType.size!)
        size.replacingOccurrences(of: "KW", with: "")
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
        if (NSInteger.init(yearsTextField.text!) == 0) {
            self.showHint("年限不能为0")
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
        let buyBottomView = UIView.init(frame: CGRect(x: 0, y: self.view.frame.size.height - 50, width: PhoneUtils.kScreenWidth, height: 50))
        buyBottomView.backgroundColor = UIColor.white
        self.view.addSubview(buyBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = buyBottomView.frame.size.height - 5 * 2
        
        let buyNowButton = UIButton.init(type: UIButtonType.custom)
        buyNowButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        buyNowButton.setTitle("立即购买", for: UIControlState.normal)
        buyNowButton.backgroundColor = Colors.installColor
        buyNowButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        buyNowButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        buyNowButton.addTarget(self, action: #selector(self.buyNow), for: UIControlEvents.touchUpInside)
        buyBottomView.addSubview(buyNowButton)
        
        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 64, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - buyBottomView.frame.size.height - 64))
        self.view.addSubview(scrollView)
        
        let topImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: (PhoneUtils.kScreenWidth * 447) / 640))
        topImageView.image = UIImage(named: "ic_insure")
        scrollView.addSubview(topImageView)
        
        let labelHeight = PhoneUtils.kScreenHeight / 10
        priceLabel = UILabel.init(frame: CGRect(x: 0, y: topImageView.frame.maxY, width: PhoneUtils.kScreenWidth * 0.3, height: labelHeight))
        priceLabel.textColor = Colors.installRedColor
        priceLabel.text = "￥: 0元"
        priceLabel.textAlignment = NSTextAlignment.center
        scrollView.addSubview(priceLabel)
        
        let noticeLabel = UILabel.init(frame: CGRect(x: PhoneUtils.kScreenWidth * 0.3, y: topImageView.frame.maxY, width: PhoneUtils.kScreenWidth * 0.7, height: labelHeight))
        noticeLabel.textColor = Colors.lightGray
        noticeLabel.text = "注:一个屋顶电站只能购买一份保险，不可叠加购买"
        noticeLabel.numberOfLines = 0
        noticeLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        noticeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        scrollView.addSubview(noticeLabel)
        
        totalLabel = UILabel.init(frame: CGRect(x: (PhoneUtils.kScreenWidth * 0.65) - offSetX, y: noticeLabel.frame.maxY + labelHeight * 0.1, width: PhoneUtils.kScreenWidth * 0.35, height: labelHeight * 0.5))
        totalLabel.textAlignment = NSTextAlignment.center
        totalLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        totalLabel.backgroundColor = Colors.installColor
        totalLabel.textColor = UIColor.white
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
