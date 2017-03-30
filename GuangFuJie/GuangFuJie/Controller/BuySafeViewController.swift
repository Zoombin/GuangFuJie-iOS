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
    var guigeLabel : UILabel!
    var scrollView : UIScrollView!
    var yearsLabel : UILabel!
    var sizeLabel : UILabel!
    
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
    
    var typeView : UIView!
    var yearsView : UIView!
    
    var years = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "购买保险"
        // Do any additional setup after loading the view.
        initView()
        loadInsuranceInfo()
    }
    
    func initView() {
        let buyBottomView = UIView.init(frame: CGRect(x: 0, y: self.view.frame.size.height - 50, width: PhoneUtils.kScreenWidth, height: 50))
        buyBottomView.backgroundColor = UIColor.white
        self.view.addSubview(buyBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = buyBottomView.frame.size.height - 5 * 2
        
        let buyNowButton = GFJBottomButton.init(type: UIButtonType.custom)
        buyNowButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        buyNowButton.setTitle("立即购买", for: UIControlState.normal)
        buyNowButton.backgroundColor = Colors.installColor
        buyNowButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        buyNowButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        buyNowButton.addTarget(self, action: #selector(self.buyNow), for: UIControlEvents.touchUpInside)
        buyBottomView.addSubview(buyNowButton)

        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 64, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - buyBottomView.frame.size.height - 64))
        self.view.addSubview(scrollView)

        let topImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: (PhoneUtils.kScreenWidth * 356) / 640))
        topImageView.image = UIImage(named: "ic_insure")
        scrollView.addSubview(topImageView)
        
        let times = PhoneUtils.kScreenWidth / 320
        var maxY = topImageView.frame.maxY
        
        let sectionView3 = UIView.init(frame: CGRect(x: 0, y: maxY, width: PhoneUtils.kScreenWidth, height: 60 * times))
        sectionView3.backgroundColor = UIColor.white
        scrollView.addSubview(sectionView3)
        
        let titleLabel2 = UILabel.init(frame: CGRect(x: offSetX, y: 0, width: 100, height: sectionView3.frame.size.height * 0.5))
        titleLabel2.text = "电站大小"
        titleLabel2.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        sectionView3.addSubview(titleLabel2)
        
        guigeLabel = UILabel.init(frame: CGRect(x: PhoneUtils.kScreenWidth - 15 * times - offSetX - 105, y: 0, width: 100, height: 30 * times))
        guigeLabel.text = "请选择电站规格"
        guigeLabel.textColor = Colors.installColor
        guigeLabel.textAlignment = NSTextAlignment.right
        guigeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        sectionView3.addSubview(guigeLabel)
        
        let arrowImageButton1 = UIButton.init(frame: CGRect(x: PhoneUtils.kScreenWidth - 15 * times - offSetX, y:7.5 * times, width: 15 * times, height: 15 * times))
        arrowImageButton1.setImage(UIImage(named: "ic_blue_arrowdown"), for: UIControlState.normal)
        sectionView3.addSubview(arrowImageButton1)
        
        let tips3Label = UILabel.init(frame: CGRect(x: offSetX, y: titleLabel2.frame.maxY, width: PhoneUtils.kScreenWidth - 2 * offSetX, height: sectionView3.frame.size.height / 2))
        tips3Label.text = "特殊电站大小，请联系客服询价"
        tips3Label.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        tips3Label.textAlignment = NSTextAlignment.right
        sectionView3.addSubview(tips3Label)
        
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 30 * times))
        button.addTarget(self, action: #selector(self.showTypeView), for: UIControlEvents.touchUpInside)
        sectionView3.addSubview(button)
        
        maxY = sectionView3.frame.maxY + offSetY
        
        let sectionView5 = UIView.init(frame: CGRect(x: 0, y: maxY, width: PhoneUtils.kScreenWidth, height: 60 * times))
        sectionView5.backgroundColor = UIColor.white
        scrollView.addSubview(sectionView5)
        
        let titleLabel4 = UILabel.init(frame: CGRect(x: offSetX, y: 0, width: 100, height: 30 * times))
        titleLabel4.text = "保障时间"
        titleLabel4.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        sectionView5.addSubview(titleLabel4)
        
        yearsLabel = UILabel.init(frame: CGRect(x: PhoneUtils.kScreenWidth - 15 * times - offSetX - 105, y: 0, width: 100, height: 30 * times))
        yearsLabel.text = "请选择投保年限"
        yearsLabel.textColor = Colors.installColor
        yearsLabel.textAlignment = NSTextAlignment.right
        yearsLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        sectionView5.addSubview(yearsLabel)
        
        let arrowImageButton2 = UIButton.init(frame: CGRect(x: PhoneUtils.kScreenWidth - 15 * times - offSetX, y: 7.5 * times, width: 15 * times, height: 15 * times))
        arrowImageButton2.setImage(UIImage(named: "ic_blue_arrowdown"), for: UIControlState.normal)
        sectionView5.addSubview(arrowImageButton2)
        
        let titleLabel5 = UILabel.init(frame: CGRect(x: offSetX, y: titleLabel4.frame.maxY, width: 120, height: 30 * times))
        titleLabel5.text = "今日购买生效时间"
        titleLabel5.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        sectionView5.addSubview(titleLabel5)
        
        let takeEffectLabel = UILabel.init(frame: CGRect(x: PhoneUtils.kScreenWidth - offSetX - 150, y: titleLabel4.frame.maxY, width: 150, height: 30 * times))
        takeEffectLabel.text = PhoneUtils.getTommorrowDateStr(Date()) + " 00:00:00"
        takeEffectLabel.textAlignment = NSTextAlignment.right
        takeEffectLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        sectionView5.addSubview(takeEffectLabel)
        
        let button5 = UIButton.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 30 * times))
        button5.addTarget(self, action: #selector(self.showYearsView), for: UIControlEvents.touchUpInside)
        sectionView5.addSubview(button5)
        
        maxY = sectionView5.frame.maxY + offSetY
        
        let sectionView1 = UIView.init(frame: CGRect(x: 0, y: maxY, width: PhoneUtils.kScreenWidth, height: 60 * times))
        sectionView1.backgroundColor = UIColor.white
        scrollView.addSubview(sectionView1)
        
        let titleLabel1 = UILabel.init(frame: CGRect(x: offSetX, y: 0, width: 100, height: sectionView1.frame.size.height * 0.6))
        titleLabel1.text = "保费金额"
        titleLabel1.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        sectionView1.addSubview(titleLabel1)
        
        priceLabel = UILabel.init(frame: CGRect(x: PhoneUtils.kScreenWidth - offSetX - 100, y: 0, width: 100, height: sectionView1.frame.size.height * 0.6))
        priceLabel.text = "￥:0"
        priceLabel.textColor = UIColor.init(red: 185/255.0, green: 0/255.0, blue: 17/255.0, alpha: 1.0)
        priceLabel.textAlignment = NSTextAlignment.right
        priceLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge)
        sectionView1.addSubview(priceLabel)
        
        let tipsLabel = UILabel.init(frame: CGRect(x: offSetX, y: priceLabel.frame.maxY, width: PhoneUtils.kScreenWidth - 2 * offSetX, height: sectionView1.frame.size.height * 0.4))
        tipsLabel.text = "注:一个屋顶电站只能购买一份保险，不可叠加。"
        tipsLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        tipsLabel.textAlignment = NSTextAlignment.right
        sectionView1.addSubview(tipsLabel)
        
        let sectionView2 = UIView.init(frame: CGRect(x: 0, y: sectionView1.frame.maxY + offSetY, width: PhoneUtils.kScreenWidth, height: 30 * times))
        sectionView2.backgroundColor = UIColor.white
        scrollView.addSubview(sectionView2)
        
        let tips2Label = UILabel.init(frame: CGRect(x: offSetX, y: 0, width: PhoneUtils.kScreenWidth - 2 * offSetX, height: sectionView2.frame.size.height))
        tips2Label.text = "累计投保：3000+"
        tips2Label.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        tips2Label.textAlignment = NSTextAlignment.right
        sectionView2.addSubview(tips2Label)
        
        maxY = sectionView1.frame.maxY + offSetY
        
        let sectionView4 = UIView.init(frame: CGRect(x: 0, y: maxY, width: PhoneUtils.kScreenWidth, height: 175 * times))
        sectionView4.backgroundColor = UIColor.white
        scrollView.addSubview(sectionView4)
        
        let titleLabel3 = UILabel.init(frame: CGRect(x: offSetX, y: 0, width: 100, height: 30 * times))
        titleLabel3.text = "保障金额"
        titleLabel3.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        sectionView4.addSubview(titleLabel3)
        
        let titleWidth = (PhoneUtils.kScreenWidth - 2 * offSetX) / 3
        let titleHeight = ((175 - 30) * times - 2 * offSetY) / 4
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
            
            
            let label = UILabel.init(frame: CGRect(x:offSetX + CGFloat(tindex) * titleWidth, y: titleLabel3.frame.maxY + CGFloat(tline) * titleHeight, width: titleWidth, height: tmpHeight))
            label.text = titles[i]
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
            label.layer.borderColor = UIColor.lightGray.cgColor
            label.layer.borderWidth = 0.5
            sectionView4.addSubview(label)
            if (i == 0 || i == 1 || i == 2) {
                label.textColor = UIColor.white
                label.backgroundColor = Colors.installColor
            }
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
        }
        
        maxY = sectionView4.frame.maxY + offSetY
        
        let sectionView6 = UIView.init(frame: CGRect(x: 0, y: maxY, width: PhoneUtils.kScreenWidth, height: 30 * times))
        sectionView6.backgroundColor = UIColor.white
        scrollView.addSubview(sectionView6)
        
        let titleLabel6 = UILabel.init(frame: CGRect(x: offSetX, y: 0, width: 100, height: 30 * times))
        titleLabel6.text = "保障条款"
        titleLabel6.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        sectionView6.addSubview(titleLabel6)
        
        let titleLabel7 = UILabel.init(frame: CGRect(x: PhoneUtils.kScreenWidth - 15 * times - offSetX - 80, y: 0, width: 80, height: 30 * times))
        titleLabel7.text = "查看保险条款"
        titleLabel7.textColor = UIColor.darkGray
        titleLabel7.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        sectionView6.addSubview(titleLabel7)
        
        let arrowImageButton3 = UIButton.init(frame: CGRect(x: PhoneUtils.kScreenWidth - 15 * times - offSetX, y: 7.5 * times, width: 15 * times, height: 15 * times))
        arrowImageButton3.setImage(UIImage(named: "arrow_right"), for: UIControlState.normal)
        sectionView6.addSubview(arrowImageButton3)
        
        let button2 = UIButton.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 30 * times))
        button2.tag = 1
        button2.addTarget(self, action: #selector(self.viewButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        sectionView6.addSubview(button2)
        
        maxY = sectionView6.frame.maxY + offSetY
        
        let sectionView7 = UIView.init(frame: CGRect(x: 0, y: maxY, width: PhoneUtils.kScreenWidth, height: 60 * times))
        sectionView7.backgroundColor = UIColor.white
        scrollView.addSubview(sectionView7)
        
        let titleLabel8 = UILabel.init(frame: CGRect(x: offSetX, y: 0, width: 100, height: 30 * times))
        titleLabel8.text = "保障条款"
        titleLabel8.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        sectionView7.addSubview(titleLabel8)
        
        let titleLabel9 = UILabel.init(frame: CGRect(x: PhoneUtils.kScreenWidth - 15 * times - offSetX - 80, y: 0, width: 80, height: 30 * times))
        titleLabel9.text = "电子保单范本"
        titleLabel9.textColor = UIColor.darkGray
        titleLabel9.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        sectionView7.addSubview(titleLabel9)
        
        let arrowImageButton4 = UIButton.init(frame: CGRect(x: PhoneUtils.kScreenWidth - 15 * times - offSetX, y: 7.5 * times, width: 15 * times, height: 15 * times))
        arrowImageButton4.setImage(UIImage(named: "arrow_right"), for: UIControlState.normal)
        sectionView7.addSubview(arrowImageButton4)
        
        let titleLabel10 = UILabel.init(frame: CGRect(x: PhoneUtils.kScreenWidth - 15 * times - offSetX - 80, y: titleLabel8.frame.maxY, width: 80, height: 30 * times))
        titleLabel10.text = "纸质保单范本"
        titleLabel10.textColor = UIColor.darkGray
        titleLabel10.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        sectionView7.addSubview(titleLabel10)
        
        let arrowImageButton5 = UIButton.init(frame: CGRect(x: PhoneUtils.kScreenWidth - 15 * times - offSetX, y: titleLabel8.frame.maxY + 7.5 * times, width: 15 * times, height: 15 * times))
        arrowImageButton5.setImage(UIImage(named: "arrow_right"), for: UIControlState.normal)
        sectionView7.addSubview(arrowImageButton5)

        let button3 = UIButton.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 30 * times))
        button3.tag = 2
        button3.addTarget(self, action: #selector(self.viewButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        sectionView7.addSubview(button3)
        
        let button4 = UIButton.init(frame: CGRect(x: 0, y: button3.frame.maxY, width: PhoneUtils.kScreenWidth, height: 30 * times))
        button4.tag = 3
        button4.addTarget(self, action: #selector(self.viewButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        sectionView7.addSubview(button4)
        
        scrollView.contentSize = CGSize(width: 0, height: sectionView7.frame.maxY)
    }
    
    func loadInsuranceInfo() {
        self.showHud(in: self.view, hint: "加载中...")
        API.sharedInstance.insuranceType({ (typeList, totalCount) in
                self.hideHud()
//                self.totalLabel.text = "累计投保:" + String(totalCount) + "份"
                self.types.addObjects(from: typeList as [AnyObject])
                self.addTypeView()
                self.addYearsView()
            }) { (msg) in
                self.hideHud()
                self.showHint(msg)
        }
    }

    deinit {
        typeView.removeFromSuperview()
        yearsView.removeFromSuperview()
    }
    
    func showYearsView() {
        if (yearsView != nil) {
            yearsView.isHidden = false
        }
    }
    
    func addYearsView() {
        let years = ["一年", "二年", "三年", "四年", "五年", "六年", "七年", "八年", "九年", "十年"]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        yearsView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight))
        yearsView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.2)
        yearsView.isHidden = true
        appDelegate.window?.addSubview(yearsView)
        
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self.closeYearsView))
        yearsView.isUserInteractionEnabled = true
        yearsView.addGestureRecognizer(gesture)
        
        let totalLine: CGFloat = CGFloat((years.count / 4) + 1)
        let dir: CGFloat = 5
        let width = (PhoneUtils.kScreenWidth - dir * 5) / 4
        let height = PhoneUtils.kScreenHeight / 15
        let bkgViewHeight = (totalLine * height) + (totalLine + 1) * dir
        
        let bkgView = UIView.init(frame: CGRect(x: 0, y: PhoneUtils.kScreenHeight - bkgViewHeight - 50, width: PhoneUtils.kScreenWidth, height: bkgViewHeight))
        bkgView.backgroundColor = UIColor.white
        yearsView.addSubview(bkgView)
        
        let closeBottomView = UIView.init(frame: CGRect(x: 0, y: bkgView.frame.maxY, width: PhoneUtils.kScreenWidth, height: 50))
        closeBottomView.backgroundColor = UIColor.white
        yearsView.addSubview(closeBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = closeBottomView.frame.size.height - 5 * 2
        
        let cancelButton = GFJBottomButton.init(type: UIButtonType.custom)
        cancelButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.backgroundColor = Colors.installColor
        cancelButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        cancelButton.addTarget(self, action: #selector(self.closeYearsView), for: UIControlEvents.touchUpInside)
        closeBottomView.addSubview(cancelButton)
        
        var line : CGFloat = 0
        var index : CGFloat = 0
        for i in 0..<years.count {
            print(i)
            if (i != 0 && i%4 == 0) {
                index = 0
                line += 1
            }
            let button = UIButton.init(type: UIButtonType.custom)
            button.frame = CGRect(x: dir + index * offSetX + width * index, y: (line + 1) * dir + height * line, width: width, height: height)
            button.setTitle(years[i], for: UIControlState.normal)
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.backgroundColor = UIColor.white
            button.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
            button.tag = i
            button.addTarget(self, action: #selector(self.yearsButtonClicked(_:)), for: UIControlEvents.touchUpInside)
            bkgView.addSubview(button)
            index += 1
        }
    }
    
    func closeYearsView() {
        yearsView.isHidden = true
    }
    
    func yearsButtonClicked(_ button: UIButton) {
        years = button.tag + 1
        yearsLabel.text = "投保\(years)年"
        closeYearsView()
        
        reSizePrice()
    }
    
    func showTypeView() {
        if (typeView != nil) {
            typeView.isHidden = false
        }
    }
    
    func addTypeView() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        typeView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight))
        typeView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.2)
        typeView.isHidden = true
        appDelegate.window?.addSubview(typeView)
        
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self.closeTypeView))
        typeView.isUserInteractionEnabled = true
        typeView.addGestureRecognizer(gesture)
    
        let totalLine: CGFloat = CGFloat((types.count / 4) + 1)
        let dir: CGFloat = 5
        let width = (PhoneUtils.kScreenWidth - dir * 5) / 4
        let height = PhoneUtils.kScreenHeight / 15
        let bkgViewHeight = (totalLine * height) + (totalLine + 1) * dir
        
        let bkgView = UIView.init(frame: CGRect(x: 0, y: PhoneUtils.kScreenHeight - bkgViewHeight - 50, width: PhoneUtils.kScreenWidth, height: bkgViewHeight))
        bkgView.backgroundColor = UIColor.white
        typeView.addSubview(bkgView)
        
        let closeBottomView = UIView.init(frame: CGRect(x: 0, y: bkgView.frame.maxY, width: PhoneUtils.kScreenWidth, height: 50))
        closeBottomView.backgroundColor = UIColor.white
        typeView.addSubview(closeBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = closeBottomView.frame.size.height - 5 * 2
        
        let cancelButton = GFJBottomButton.init(type: UIButtonType.custom)
        cancelButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.backgroundColor = Colors.installColor
        cancelButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        cancelButton.addTarget(self, action: #selector(self.closeTypeView), for: UIControlEvents.touchUpInside)
        closeBottomView.addSubview(cancelButton)
        
        
        var line : CGFloat = 0
        var index : CGFloat = 0
        for i in 0..<types.count {
            print(i)
            if (i != 0 && i%4 == 0) {
                index = 0
                line += 1
            }
            let insureType = types[i] as! InsuranceType
            let button = UIButton.init(type: UIButtonType.custom)
            button.frame = CGRect(x: dir + index * offSetX + width * index, y: (line + 1) * dir + height * line, width: width, height: height)
            button.setTitle(StringUtils.getString(insureType.label), for: UIControlState.normal)
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.backgroundColor = UIColor.white
            button.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
            button.tag = BUTTON_TAG + i
            button.addTarget(self, action: #selector(self.buttonClicked(_:)), for: UIControlEvents.touchUpInside)
            bkgView.addSubview(button)
            index += 1
        }
    }
    
    func closeTypeView() {
        typeView.isHidden = true
    }
    
    func valueChanged() {
        reSizePrice()
    }
    
    func reSizePrice() {
        if (insureModel == nil) {
            return
        }
        let currentPrice = Float(years) * insureModel!.price!.floatValue
        priceLabel.text = String(format: "￥:%.2f元", currentPrice)
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
        closeTypeView()
        for i in 0..<types.count {
            let button = typeView.viewWithTag(i + BUTTON_TAG)
            button!.layer.borderColor = UIColor.black.cgColor
            button!.layer.borderWidth = 1
        }
        sender.layer.borderColor = Colors.installColor.cgColor
        sender.layer.borderWidth = 1
        
        let insureType = types[sender.tag - BUTTON_TAG] as! InsuranceType
        insureModel = insureType
        
        guigeLabel.text = StringUtils.getString(insureModel!.label)
        reSizePrice()
        
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
        if (years == 0) {
            self.showHint("请选择年限")
            return
        }
        if (insureModel == nil) {
            self.showHint("请选择电站大小")
            return
        }
        let vc = ApplyForOrderViewController()
        vc.insuranceType = insureModel
        vc.years = "\(years)"
        self.pushViewController(vc)
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
