//
//  RootProjectCalV2ViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/10/19.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootProjectCalV2ViewController: BaseViewController {
    let times = PhoneUtils.kScreenWidth / 375
    var leftButton1: UIButton!
    var leftButton2: UIButton!
    var leftButton3: UIButton!
    var leftButton4: UIButton!
    
    var contentScrollView: UIScrollView!
    var rightContentView: UIView!
    
    var firstContentView: UIView!
    var secondContentView: UIView!
    var thirdContentView: UIView!
    var fourthContentView: UIView!
    
    var firstContentScroll: UIScrollView!  //日照计算
    var secondContentScroll: UIScrollView! //产能计算
    var thirdContentScroll: UIScrollView!  //收益分析
    var fourthContentScroll: UIScrollView! //现金流向
    
    let leftBtnTitles = ["日照\n计算", "产能\n计算", "收益\n分析", "现金\n流向"]
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initLeftButtons() {
        let btnWidth = 56 * times
        let btnHeight = contentScrollView.frame.size.height / 4
        
        let btns = NSMutableArray()
        for i in 0..<leftBtnTitles.count {
            let button = UIButton.init(type: UIButtonType.custom)
            button.backgroundColor = UIColor.lightGray
            button.frame = CGRect(x: 0, y: CGFloat(i) * btnHeight, width: btnWidth, height: btnHeight)
            button.setTitle(leftBtnTitles[i], for: UIControlState.normal)
            button.setTitleColor(Colors.calUnSelectTextColor, for: UIControlState.normal)
            button.backgroundColor = Colors.calUnSelectColor
            button.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            contentScrollView.addSubview(button)
            
            btns.add(button)
            if (i == 0) {
                button.setTitleColor(Colors.calSelectedTextColor, for: UIControlState.normal)
                button.backgroundColor = Colors.calSelectedColor
            }
        }
        leftButton1 = btns[0] as! UIButton
        leftButton2 = btns[1] as! UIButton
        leftButton3 = btns[2] as! UIButton
        leftButton4 = btns[3] as! UIButton
        
    }
    
    func initView() {
        self.title = "项目测算"
        self.automaticallyAdjustsScrollViewInsets = true
        contentScrollView = UIScrollView.init(frame: CGRect(x: 0, y: self.navigationBarAndStatusBarHeight(), width: PhoneUtils.kScreenWidth, height: self.view.frame.size.height - self.navigationBarAndStatusBarHeight()))
        contentScrollView.backgroundColor = UIColor.yellow
        self.view.addSubview(contentScrollView)
        
        initLeftButtons()
//        initFirstLeftView()
//        initSecondLeftView()
        initThirdLeftView()
//        initFourthLeftVie()
    }
    
    //MARK: 项目测算
    func initFirstLeftView() {
        firstContentView = UIView.init(frame: CGRect(x: leftButton1.frame.size.width, y: self.navigationBarAndStatusBarHeight(), width: PhoneUtils.kScreenWidth - leftButton1.frame.size.width, height: self.view.frame.size.height - self.navigationBarAndStatusBarHeight()))
        firstContentView.backgroundColor = UIColor.white
        self.addLeftShadow(view: firstContentView)
        self.view.addSubview(firstContentView)
        
        firstContentScroll = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: firstContentView.frame.size.width, height: firstContentView.frame.size.height))
        firstContentView.addSubview(firstContentScroll)
        
        let locationButton = UIButton.init(type: UIButtonType.custom)
        locationButton.frame = CGRect(x: 19 * times, y: 16 * times, width: 170, height: 18)
        locationButton.setTitle("请选择地区", for: UIControlState.normal)
        locationButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        locationButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        firstContentScroll.addSubview(locationButton)
        
        let latLabel = UILabel.init(frame: CGRect(x: locationButton.frame.origin.x, y: locationButton.frame.maxY + 35 * times, width: 100 * times, height: 18 * times))
        latLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        latLabel.text = "经度：75.23"
        firstContentScroll.addSubview(latLabel)
        
        let lngLabel = UILabel.init(frame: CGRect(x: latLabel.frame.maxX + 42 * times, y: locationButton.frame.maxY + 35 * times, width: 100 * times, height: 18 * times))
        lngLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        lngLabel.text = "纬度：75.23"
        firstContentScroll.addSubview(lngLabel)
        
        let sunriseButton = UIButton.init(type: UIButtonType.custom)
        sunriseButton.frame = CGRect(x: (firstContentScroll.frame.size.width - 268 * times) / 2, y: latLabel.frame.maxY + 41 * times, width: 268 * times, height: 38 * times)
        sunriseButton.setTitle("获取日照数据", for: UIControlState.normal)
        self.setCalBlueButtonCommonSet(btn: sunriseButton)
        firstContentScroll.addSubview(sunriseButton)
        
        let line = UILabel.init(frame: CGRect(x: sunriseButton.frame.minX, y: sunriseButton.frame.maxY + 26 * times, width: sunriseButton.frame.size.width, height: 0.5))
        line.backgroundColor = UIColor.lightGray
        firstContentScroll.addSubview(line)
        
        let tipsLabel = UILabel.init(frame: CGRect(x: (firstContentScroll.frame.size.width - 108 * times) / 2, y: sunriseButton.frame.maxY + 20 * times, width: 108 * times, height: 16))
        tipsLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        tipsLabel.text = "以下为计算结果"
        tipsLabel.textAlignment = NSTextAlignment.center
        tipsLabel.backgroundColor = UIColor.white
        firstContentScroll.addSubview(tipsLabel)
        
        let sunHourLabel = UILabel.init(frame: CGRect(x: 13 * times, y: line.frame.maxY + 20, width: 200 * times, height: 15 * times))
        sunHourLabel.text = "年日照时数：1418 小时"
        sunHourLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        firstContentScroll.addSubview(sunHourLabel)
        
        let sunYearTotalLabel = UILabel.init(frame: CGRect(x: 13 * times, y: sunHourLabel.frame.maxY + 17, width: 200 * times, height: 15 * times))
        sunYearTotalLabel.text = "年辐照总量：1657 kWh/㎡.年"
        sunYearTotalLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        firstContentScroll.addSubview(sunYearTotalLabel)
        
        let offSetX = (firstContentScroll.frame.size.width - 124 * times * 2) / 3
        let reCalButton = UIButton.init(type: UIButtonType.custom)
        reCalButton.frame = CGRect(x: offSetX, y: firstContentScroll.frame.size.height - 50 * times, width: 124 * times, height: 38 * times)
        reCalButton.setTitle("重新计算", for: UIControlState.normal)
        self.setCalBlueButtonCommonSet(btn: reCalButton)
        firstContentScroll.addSubview(reCalButton)
        
        let nextStepButton = UIButton.init(type: UIButtonType.custom)
        nextStepButton.frame = CGRect(x: offSetX * 2 + 124 * times, y: firstContentScroll.frame.size.height - 50 * times, width: 124 * times, height: 38 * times)
        nextStepButton.setTitle("下一步", for: UIControlState.normal)
        self.setCalBlueButtonCommonSet(btn: nextStepButton)
        firstContentScroll.addSubview(nextStepButton)
    }
    
    //MARK: 产能计算
    func initSecondLeftView() {
        secondContentView = UIView.init(frame: CGRect(x: leftButton1.frame.size.width, y: self.navigationBarAndStatusBarHeight(), width: PhoneUtils.kScreenWidth - leftButton1.frame.size.width, height: self.view.frame.size.height - self.navigationBarAndStatusBarHeight()))
        secondContentView.backgroundColor = UIColor.white
        self.addLeftShadow(view: secondContentView)
        self.view.addSubview(secondContentView)
        
        secondContentScroll = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: secondContentView.frame.size.width, height: secondContentView.frame.size.height - 50))
        secondContentView.addSubview(secondContentScroll)
        
        let roofSizeLabel = UILabel.init(frame: CGRect(x: 0, y: 5 * times, width: 60 * times, height: 34 * times))
        roofSizeLabel.text = "屋顶面积"
        roofSizeLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        roofSizeLabel.textAlignment = NSTextAlignment.center
        secondContentScroll.addSubview(roofSizeLabel)
        
        let roofSizeTextField = UITextField.init(frame: CGRect(x: roofSizeLabel.frame.maxX, y: 5 * times, width: 210 * times, height: 34 * times))
        roofSizeTextField.layer.cornerRadius = 3
        roofSizeTextField.layer.borderColor = UIColor.lightGray.cgColor
        roofSizeTextField.layer.borderWidth = 0.5
        roofSizeTextField.layer.masksToBounds = true
        roofSizeTextField.textAlignment = NSTextAlignment.center
        roofSizeTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        secondContentScroll.addSubview(roofSizeTextField)
        
        let roofRightLabel = UILabel.init(frame: CGRect(x: roofSizeTextField.frame.maxX, y: 5 * times, width: secondContentScroll.frame.size.width - roofSizeTextField.frame.maxX, height: 34 * times))
        roofRightLabel.text = "平方米"
        roofRightLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        roofRightLabel.textAlignment = NSTextAlignment.center
        secondContentScroll.addSubview(roofRightLabel)
        
        let roofTypeLabel = UILabel.init(frame: CGRect(x: 0, y: roofSizeTextField.frame.maxY + 10 * times, width: 60 * times, height: 34 * times))
        roofTypeLabel.text = "铺设方式"
        roofTypeLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        roofTypeLabel.textAlignment = NSTextAlignment.center
        secondContentScroll.addSubview(roofTypeLabel)
        
        let roofTypeButton = UIButton.init(frame: CGRect(x: roofTypeLabel.frame.maxX, y: roofSizeTextField.frame.maxY + 10 * times, width: 210 * times, height: 34 * times))
        roofTypeButton.layer.cornerRadius = 3
        roofTypeButton.layer.borderColor = UIColor.lightGray.cgColor
        roofTypeButton.layer.borderWidth = 0.5
        roofTypeButton.layer.masksToBounds = true
        roofTypeButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        secondContentScroll.addSubview(roofTypeButton)
        
        let roofTypeRightLabel = UILabel.init(frame: CGRect(x: roofTypeButton.frame.maxX, y: roofSizeTextField.frame.maxY + 10 * times, width: secondContentScroll.frame.size.width - roofTypeButton.frame.maxX, height: 34 * times))
        roofTypeRightLabel.text = "朝南"
        roofTypeRightLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        roofTypeRightLabel.textAlignment = NSTextAlignment.center
        secondContentScroll.addSubview(roofTypeRightLabel)
        
        let calButton = UIButton.init(type: UIButtonType.custom)
        calButton.frame = CGRect(x: (secondContentScroll.frame.size.width - 268 * times) / 2, y: roofTypeButton.frame.maxY + 5 * times, width: 268 * times, height: 38 * times)
        calButton.setTitle("计算", for: UIControlState.normal)
        self.setCalBlueButtonCommonSet(btn: calButton)
        secondContentScroll.addSubview(calButton)
        
        let line = UILabel.init(frame: CGRect(x: calButton.frame.minX, y: calButton.frame.maxY + 26 * times, width: calButton.frame.size.width, height: 0.5))
        line.backgroundColor = UIColor.lightGray
        secondContentScroll.addSubview(line)
        
        let tipsLabel = UILabel.init(frame: CGRect(x: (secondContentScroll.frame.size.width - 108 * times) / 2, y: calButton.frame.maxY + 20 * times, width: 108 * times, height: 16))
        tipsLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        tipsLabel.text = "以下为计算结果"
        tipsLabel.textAlignment = NSTextAlignment.center
        tipsLabel.backgroundColor = UIColor.white
        secondContentScroll.addSubview(tipsLabel)
        
        let labelWidth = 300 * times
        let labelHeight = 25 * times
        let offSetX = (secondContentScroll.frame.size.width - labelWidth) / 2
        
        var currentY = tipsLabel.frame.maxY + 22 * times
        let ckqjLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY, width: labelWidth, height: labelHeight))
        ckqjLabel.text = "参考倾角：0 度"
        ckqjLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(ckqjLabel)
        currentY = ckqjLabel.frame.maxY
        
        let zjrlLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        zjrlLabel.text = "装机容量：0 kWh"
        zjrlLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(zjrlLabel)
        currentY = zjrlLabel.frame.maxY
        
        let mwtzjeLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        mwtzjeLabel.text = "每瓦投资金额："
        mwtzjeLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(mwtzjeLabel)
        currentY = mwtzjeLabel.frame.maxY
        
        let tzjeLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        tzjeLabel.text = "投资金额：0 元"
        tzjeLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(tzjeLabel)
        currentY = tzjeLabel.frame.maxY
        
        let fdlLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        fdlLabel.text = "发电量"
        fdlLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        fdlLabel.textColor = Colors.appBlue
        YCLineUtils.addTopLine(fdlLabel, color: UIColor.lightGray, percent: 100)
        YCLineUtils.addBottomLine(fdlLabel, color: UIColor.lightGray, percent: 100)
        secondContentScroll.addSubview(fdlLabel)
        currentY = fdlLabel.frame.maxY
        
        let snfdlyxsLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        snfdlyxsLabel.text = "首年发电利用小时：0 小时"
        snfdlyxsLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(snfdlyxsLabel)
        currentY = snfdlyxsLabel.frame.maxY
        
        let snmqwrfdlLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        snmqwrfdlLabel.text = "首年每千瓦日发电量："
        snmqwrfdlLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(snmqwrfdlLabel)
        currentY = snmqwrfdlLabel.frame.maxY
        
        let snrfdLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        snrfdLabel.text = "首年日发电：0 度"
        snrfdLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(snrfdLabel)
        currentY = snrfdLabel.frame.maxY
        
        let snzfdLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        snzfdLabel.text = "首年总发电：0 度"
        snzfdLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(snzfdLabel)
        currentY = snzfdLabel.frame.maxY
        
        let zfd25Label = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        zfd25Label.text = "25年总发电：0 度"
        zfd25Label.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(zfd25Label)
        currentY = zfd25Label.frame.maxY
        
        //=======================
        let jnjpLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        jnjpLabel.text = "节能减排"
        jnjpLabel.textColor = Colors.appBlue
        jnjpLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        YCLineUtils.addTopLine(jnjpLabel, color: UIColor.lightGray, percent: 100)
        YCLineUtils.addBottomLine(jnjpLabel, color: UIColor.lightGray, percent: 100)
        secondContentScroll.addSubview(jnjpLabel)
        currentY = jnjpLabel.frame.maxY
        
        let jybztLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        jybztLabel.text = "节约标准碳：0 千克"
        jybztLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(jybztLabel)
        currentY = jybztLabel.frame.maxY
        
        let co2Label = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        co2Label.text = "减少CO₂排放：0 千克"
        co2Label.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(co2Label)
        currentY = co2Label.frame.maxY
        
        let so2Label = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        so2Label.text = "减少SO₂排放：0 千克"
        so2Label.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(so2Label)
        currentY = so2Label.frame.maxY
        
        let no2Label = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        no2Label.text = "减少氮化物排放：0 千克"
        no2Label.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(no2Label)
        currentY = no2Label.frame.maxY
        
        let smokeLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        smokeLabel.text = "减少烟雾排放：0 千克"
        smokeLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(smokeLabel)
        currentY = smokeLabel.frame.maxY
        
        secondContentScroll.contentSize = CGSize(width: 0, height: currentY)
        
        let bottomOffSetX = (secondContentView.frame.size.width - 124 * times * 2) / 3
        let reCalButton = UIButton.init(type: UIButtonType.custom)
        reCalButton.frame = CGRect(x: bottomOffSetX, y: secondContentScroll.frame.maxY, width: 124 * times, height: 38 * times)
        reCalButton.setTitle("重新计算", for: UIControlState.normal)
        self.setCalBlueButtonCommonSet(btn: reCalButton)
        secondContentView.addSubview(reCalButton)
        
        let nextStepButton = UIButton.init(type: UIButtonType.custom)
        nextStepButton.frame = CGRect(x: bottomOffSetX * 2 + 124 * times, y: secondContentScroll.frame.maxY, width: 124 * times, height: 38 * times)
        nextStepButton.setTitle("下一步", for: UIControlState.normal)
        self.setCalBlueButtonCommonSet(btn: nextStepButton)
        secondContentView.addSubview(nextStepButton)
    }
    
    func initThirdLeftView() {
        thirdContentView = UIView.init(frame: CGRect(x: leftButton1.frame.size.width, y: self.navigationBarAndStatusBarHeight(), width: PhoneUtils.kScreenWidth - leftButton1.frame.size.width, height: self.view.frame.size.height - self.navigationBarAndStatusBarHeight()))
        thirdContentView.backgroundColor = UIColor.white
        self.addLeftShadow(view: thirdContentView)
        self.view.addSubview(thirdContentView)
        
        thirdContentScroll = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: thirdContentView.frame.size.width, height: thirdContentView.frame.size.height))
        thirdContentView.addSubview(thirdContentScroll)
        
        //投资金额
        let tzjeLabel = UILabel.init(frame: CGRect(x: 10 * times, y: 15 * times, width: 55 * times, height: 35 * times))
        tzjeLabel.text = "投资金额"
        tzjeLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        thirdContentScroll.addSubview(tzjeLabel)
        
        let tzjeValueLabel = UILabel.init(frame: CGRect(x: tzjeLabel.frame.maxX, y: 15 * times, width: 224 * times, height: 35 * times))
        tzjeValueLabel.text = "0.00"
        tzjeValueLabel.textAlignment = NSTextAlignment.center
        tzjeValueLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        thirdContentScroll.addSubview(tzjeValueLabel)
        
        let tzjeRightLabel = UILabel.init(frame: CGRect(x: tzjeValueLabel.frame.maxX, y: 15 * times, width: thirdContentScroll.frame.size.width - tzjeValueLabel.frame.maxX, height: 35 * times))
        tzjeRightLabel.text = "元"
        tzjeRightLabel.textAlignment = NSTextAlignment.center
        tzjeRightLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        thirdContentScroll.addSubview(tzjeRightLabel)
        var currentY = tzjeRightLabel.frame.maxY
        
        //可回收流动资金
        let khsldzjLabel = UILabel.init(frame: CGRect(x: 10 * times, y: currentY + 10 * times, width: 95 * times, height: 35 * times))
        khsldzjLabel.text = "可回收流动资金"
        khsldzjLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        thirdContentScroll.addSubview(khsldzjLabel)
        
        let khsldzjTextField = UITextField.init(frame: CGRect(x: khsldzjLabel.frame.maxX, y: currentY + 10 * times, width: 180 * times, height: 35 * times))
        khsldzjTextField.layer.cornerRadius = 3
        khsldzjTextField.layer.borderColor = UIColor.lightGray.cgColor
        khsldzjTextField.layer.borderWidth = 0.5
        khsldzjTextField.layer.masksToBounds = true
        khsldzjTextField.textAlignment = NSTextAlignment.center
        khsldzjTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        thirdContentScroll.addSubview(khsldzjTextField)
        
        let khsldzjRightLabel = UILabel.init(frame: CGRect(x: khsldzjTextField.frame.maxX, y: currentY + 10 * times, width: thirdContentScroll.frame.size.width - khsldzjTextField.frame.maxX, height: 35 * times))
        khsldzjRightLabel.text = "元"
        khsldzjRightLabel.textAlignment = NSTextAlignment.center
        khsldzjRightLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        thirdContentScroll.addSubview(khsldzjRightLabel)
        currentY = khsldzjRightLabel.frame.maxY
        
        //运维成本
        let ywcbLabel = UILabel.init(frame: CGRect(x: 10 * times, y: currentY + 10 * times, width: 55 * times, height: 35 * times))
        ywcbLabel.text = "运维成本"
        ywcbLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        thirdContentScroll.addSubview(ywcbLabel)
        
        let ywcbTextField = UITextField.init(frame: CGRect(x: ywcbLabel.frame.maxX, y: currentY + 10 * times, width: 224 * times, height: 35 * times))
        ywcbTextField.layer.cornerRadius = 3
        ywcbTextField.layer.borderColor = UIColor.lightGray.cgColor
        ywcbTextField.layer.borderWidth = 0.5
        ywcbTextField.layer.masksToBounds = true
        ywcbTextField.textAlignment = NSTextAlignment.center
        ywcbTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        thirdContentScroll.addSubview(ywcbTextField)
        
        let ywcbRightLabel = UILabel.init(frame: CGRect(x: ywcbTextField.frame.maxX, y: currentY + 10 * times, width: thirdContentScroll.frame.size.width - ywcbTextField.frame.maxX, height: 35 * times))
        ywcbRightLabel.text = "%"
        ywcbRightLabel.textAlignment = NSTextAlignment.center
        ywcbRightLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        thirdContentScroll.addSubview(ywcbRightLabel)
        currentY = ywcbRightLabel.frame.maxY
        
        //装机补贴
        let zjbtLabel = UILabel.init(frame: CGRect(x: 10 * times, y: currentY + 10 * times, width: 55 * times, height: 35 * times))
        zjbtLabel.text = "装机补贴"
        zjbtLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        thirdContentScroll.addSubview(zjbtLabel)
        
        let zjbtTextField = UITextField.init(frame: CGRect(x: ywcbLabel.frame.maxX, y: currentY + 10 * times, width: 215 * times, height: 35 * times))
        zjbtTextField.layer.cornerRadius = 3
        zjbtTextField.layer.borderColor = UIColor.lightGray.cgColor
        zjbtTextField.layer.borderWidth = 0.5
        zjbtTextField.layer.masksToBounds = true
        zjbtTextField.textAlignment = NSTextAlignment.center
        zjbtTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        thirdContentScroll.addSubview(zjbtTextField)
        
        let zjbtRightLabel = UILabel.init(frame: CGRect(x: zjbtTextField.frame.maxX, y: currentY + 10 * times, width: thirdContentScroll.frame.size.width - zjbtTextField.frame.maxX, height: 35 * times))
        zjbtRightLabel.text = "元/瓦"
        zjbtRightLabel.textAlignment = NSTextAlignment.center
        zjbtRightLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        thirdContentScroll.addSubview(zjbtRightLabel)
        currentY = zjbtRightLabel.frame.maxY
        
        //贷款比例
        let dkblLabel = UILabel.init(frame: CGRect(x: 10 * times, y: currentY + 10 * times, width: 55 * times, height: 35 * times))
        dkblLabel.text = "贷款比例"
        dkblLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        thirdContentScroll.addSubview(dkblLabel)
        
        let dkblPercentTextField = UITextField.init(frame: CGRect(x: dkblLabel.frame.maxX, y: currentY + 10 * times, width: 95 * times, height: 35 * times))
        dkblPercentTextField.layer.cornerRadius = 3
        dkblPercentTextField.layer.borderColor = UIColor.lightGray.cgColor
        dkblPercentTextField.layer.borderWidth = 0.5
        dkblPercentTextField.layer.masksToBounds = true
        dkblPercentTextField.textAlignment = NSTextAlignment.center
        dkblPercentTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        thirdContentScroll.addSubview(dkblPercentTextField)
        
        let dkblMiddleLabel = UILabel.init(frame: CGRect(x: dkblPercentTextField.frame.maxX, y: currentY + 10 * times, width: 30 * times, height: 35 * times))
        dkblMiddleLabel.text = "%"
        dkblMiddleLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        dkblMiddleLabel.textAlignment = NSTextAlignment.center
        thirdContentScroll.addSubview(dkblMiddleLabel)
        
        let dkblYearsTextField = UITextField.init(frame: CGRect(x: dkblMiddleLabel.frame.maxX, y: currentY + 10 * times, width: 95 * times, height: 35 * times))
        dkblYearsTextField.layer.cornerRadius = 3
        dkblYearsTextField.layer.borderColor = UIColor.lightGray.cgColor
        dkblYearsTextField.layer.borderWidth = 0.5
        dkblYearsTextField.layer.masksToBounds = true
        dkblYearsTextField.textAlignment = NSTextAlignment.center
        dkblYearsTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        thirdContentScroll.addSubview(dkblYearsTextField)
        
        let dkblRightLabel = UILabel.init(frame: CGRect(x: dkblYearsTextField.frame.maxX, y: currentY + 10 * times, width: thirdContentScroll.frame.size.width - dkblYearsTextField.frame.maxX, height: 35 * times))
        dkblRightLabel.text = "年"
        dkblRightLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        dkblRightLabel.textAlignment = NSTextAlignment.center
        thirdContentScroll.addSubview(dkblRightLabel)
        currentY = dkblRightLabel.frame.maxY
        
        let line = UILabel.init(frame: CGRect(x: 0, y: currentY + 10 * times, width: thirdContentScroll.frame.size.width, height: 0.5))
        line.backgroundColor = UIColor.lightGray
        thirdContentScroll.addSubview(line)
    }
    
    func initFourthLeftView() {
        fourthContentView = UIView.init(frame: CGRect(x: leftButton1.frame.size.width, y: self.navigationBarAndStatusBarHeight(), width: PhoneUtils.kScreenWidth - leftButton1.frame.size.width, height: self.view.frame.size.height - self.navigationBarAndStatusBarHeight()))
        fourthContentView.backgroundColor = UIColor.white
        self.addLeftShadow(view: fourthContentView)
        self.view.addSubview(fourthContentView)
        
        fourthContentScroll = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: fourthContentView.frame.size.width, height: fourthContentView.frame.size.height))
        firstContentView.addSubview(fourthContentScroll)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addLeftShadow(view: UIView) {
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 1.0
    }
    
    func setCalBlueButtonCommonSet(btn: UIButton) {
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.backgroundColor = Colors.appBlue
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
    }

}
