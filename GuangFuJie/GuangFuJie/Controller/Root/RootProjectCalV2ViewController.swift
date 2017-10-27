//
//  RootProjectCalV2ViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/10/19.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootProjectCalV2ViewController: BaseViewController, ProviceCityViewDelegate, UITextFieldDelegate {
    let times = PhoneUtils.kScreenWidth / 375
    var leftBtns = NSMutableArray()
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
    
    //日照计算控件
    var locationButton: UIButton! //地区按钮
    var latLabel: UILabel! //经度
    var lngLabel: UILabel! //纬度
    var sunHourLabel: UILabel! //日照小时数
    var sunYearTotalLabel: UILabel! //日照数值
    
    var projectCalInfo: ProjectcalInfo?
    var energyCalInfo: EnergycalInfo?
    
    var currentLat: NSNumber?
    var currentLng: NSNumber?
    
    //产能计算控件
    var roofSizeTextField: UITextField! //屋顶面积
    var roofTypeButton: UIButton! //安装方式
    var ckqjLabel: UILabel!
    var zjrlLabel: UILabel!
    var mwtzjeTextField: UITextField!
    var mwtzjeLabel: UILabel!
    var tzjeLabel: UILabel!
    var snfdlyxsLabel: UILabel!
    var snmqwrfdTextField: UITextField!
    var snrfdLabel: UILabel!
    var snzfdLabel: UILabel!
    var zfd25Label: UILabel!
    var jybztLabel: UILabel!
    var co2Label: UILabel!
    var so2Label: UILabel!
    var no2Label: UILabel!
    var smokeLabel: UILabel!
    
    var type = 1 //铺设方式
    
    //收益分析
    var tzjeValueLabel: UILabel!
    var khsldzjTextField: UITextField!
    var ywcbTextField: UITextField!
    var zjbtTextField: UITextField!
    var dkblPercentTextField: UITextField!
    var dkblYearsTextField: UITextField!
    var leftCheckBox: UIButton!
    var rightCheckBox: UIButton!
    var zydblTextField: UITextField!
    var zyddjTextField: UITextField!
    var ydbtPriceTextField: UITextField!
    var ydbtYearsTextField: UITextField!
    var ydswjTextField: UITextField!
    
    //现金流向
    var lxtzjeValueLabel: UILabel!
    var lxzjrlValueLabel: UILabel!
    var lxdkjeLabel: UILabel!
    var lxdkjeYearsLabel: UILabel!
    var backTypeButton: UIButton!
    var dkllTextField: UITextField!
    var dkllTimesTextField: UITextField!
    var dkllRightLabel: UILabel!
    
    var loanType = 1 //还款方式
    
    let leftBtnTitles = ["日照\n计算", "产能\n计算", "收益\n分析", "现金\n流向"]
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initLeftButtons() {
        let btnWidth = 56 * times
        let btnHeight = contentScrollView.frame.size.height / 4
        
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
            button.tag = i
            button.addTarget(self, action: #selector(self.leftButtonClicked(btn:)), for: UIControlEvents.touchUpInside)
            contentScrollView.addSubview(button)
            
            leftBtns.add(button)
            if (i == 0) {
                button.setTitleColor(Colors.calSelectedTextColor, for: UIControlState.normal)
                button.backgroundColor = Colors.calSelectedColor
            }
        }
        leftButton1 = leftBtns[0] as! UIButton
        leftButton2 = leftBtns[1] as! UIButton
        leftButton3 = leftBtns[2] as! UIButton
        leftButton4 = leftBtns[3] as! UIButton
        
    }
    
    func initView() {
        self.title = "项目测算"
        self.automaticallyAdjustsScrollViewInsets = true
        contentScrollView = UIScrollView.init(frame: CGRect(x: 0, y: self.navigationBarAndStatusBarHeight(), width: PhoneUtils.kScreenWidth, height: self.view.frame.size.height - self.navigationBarAndStatusBarHeight() - 50))
        contentScrollView.backgroundColor = UIColor.white
        self.view.addSubview(contentScrollView)
        
        initLeftButtons()
        
        initSecondLeftView()
        initThirdLeftView()
        initFourthLeftView()
        initFirstLeftView()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "生成截图", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.screenShot))
    }
    
    func screenShot() {
        let image = YCPhoneUtils.screenShot(view: self.view)
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.showHint("截屏成功")
    }
    
    func leftButtonClicked(btn: UIButton) {
        firstContentView.isHidden = true
        secondContentView.isHidden = true
        thirdContentView.isHidden = true
        fourthContentView.isHidden = true
        for i in 0..<leftBtns.count {
            let button = leftBtns[i] as! UIButton
            button.setTitleColor(Colors.calUnSelectTextColor, for: UIControlState.normal)
            button.backgroundColor = Colors.calUnSelectColor
        }
        if (btn.tag == 0) {
            firstContentView.isHidden = false
            btn.setTitleColor(Colors.calSelectedTextColor, for: UIControlState.normal)
            btn.backgroundColor = Colors.calSelectedColor
        } else if (btn.tag == 1) {
            secondContentView.isHidden = false
            btn.setTitleColor(Colors.calSelectedTextColor, for: UIControlState.normal)
            btn.backgroundColor = Colors.calSelectedColor
        } else if (btn.tag == 2) {
            thirdContentView.isHidden = false
            btn.setTitleColor(Colors.calSelectedTextColor, for: UIControlState.normal)
            btn.backgroundColor = Colors.calSelectedColor
        } else if (btn.tag == 3) {
            fourthContentView.isHidden = false
            btn.setTitleColor(Colors.calSelectedTextColor, for: UIControlState.normal)
            btn.backgroundColor = Colors.calSelectedColor
        }
    }
    
    //MARK: 项目测算
    func initFirstLeftView() {
        firstContentView = UIView.init(frame: CGRect(x: leftButton1.frame.size.width, y: 0, width: PhoneUtils.kScreenWidth - leftButton1.frame.size.width, height: contentScrollView.frame.size.height))
        firstContentView.backgroundColor = UIColor.white
        self.addLeftShadow(view: firstContentView)
        contentScrollView.addSubview(firstContentView)
        
        firstContentScroll = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: firstContentView.frame.size.width, height: firstContentView.frame.size.height))
        firstContentView.addSubview(firstContentScroll)
        
        locationButton = UIButton.init(type: UIButtonType.custom)
        locationButton.frame = CGRect(x: 19 * times, y: 16 * times, width: 240, height: 18)
        locationButton.setTitle("请选择地区", for: UIControlState.normal)
        locationButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        locationButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        locationButton.addTarget(self, action: #selector(self.locationSetting), for: UIControlEvents.touchUpInside)
        firstContentScroll.addSubview(locationButton)
        
        latLabel = UILabel.init(frame: CGRect(x: locationButton.frame.origin.x, y: locationButton.frame.maxY + 35 * times, width: 100 * times, height: 18 * times))
        latLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        latLabel.text = "经度：--"
        firstContentScroll.addSubview(latLabel)
        
        lngLabel = UILabel.init(frame: CGRect(x: latLabel.frame.maxX + 42 * times, y: locationButton.frame.maxY + 35 * times, width: 100 * times, height: 18 * times))
        lngLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        lngLabel.text = "纬度：--"
        firstContentScroll.addSubview(lngLabel)
        
        let sunriseButton = UIButton.init(type: UIButtonType.custom)
        sunriseButton.frame = CGRect(x: (firstContentScroll.frame.size.width - 268 * times) / 2, y: latLabel.frame.maxY + 41 * times, width: 268 * times, height: 38 * times)
        sunriseButton.setTitle("获取日照数据", for: UIControlState.normal)
        self.setCalBlueButtonCommonSet(btn: sunriseButton)
        sunriseButton.addTarget(self, action: #selector(self.loadSunriseData), for: UIControlEvents.touchUpInside)
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
        
        sunHourLabel = UILabel.init(frame: CGRect(x: 13 * times, y: line.frame.maxY + 20, width: 200 * times, height: 15 * times))
        sunHourLabel.text = "年日照时数：-- 小时"
        sunHourLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        firstContentScroll.addSubview(sunHourLabel)
        
        sunYearTotalLabel = UILabel.init(frame: CGRect(x: 13 * times, y: sunHourLabel.frame.maxY + 17, width: 200 * times, height: 15 * times))
        sunYearTotalLabel.text = "年辐照总量：-- 度/平方米"
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
        nextStepButton.addTarget(self, action: #selector(self.nextStep), for: UIControlEvents.touchUpInside)
        self.setCalBlueButtonCommonSet(btn: nextStepButton)
        firstContentScroll.addSubview(nextStepButton)
    }
    
    func locationSetting() {
        let vc = ProviceCityViewController()
        vc.delegate = self
        
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    //位置选择Delegate方法
    func proviceAndCity(_ provice: ProvinceModel, city: CityModel, area: AreaModel) {
        locationButton.setTitle("\(YCStringUtils.getString(provice.name))\(YCStringUtils.getString(city.name))\(YCStringUtils.getString(area.name))", for: UIControlState.normal)
        
        latLabel.text = String(format: "纬度：%.2f", YCStringUtils.getNumber(area.lat).floatValue)
        lngLabel.text = String(format: "经度：%.2f", YCStringUtils.getNumber(area.lng).floatValue)
        currentLat = area.lat
        currentLng = area.lng
    }
    
    //年日照幅度
    func loadSunriseData() {
        if (currentLat == nil || currentLng == nil) {
            self.showHint("请先选择位置")
            return
        }
        self.showHud(in: self.view, hint: "获取数据中...")
        API.sharedInstance.projectcalSunenerge(currentLat!, lng: currentLng!, success: { (info) in
            self.projectCalInfo = info
            self.hideHud()
            self.sunHourLabel.text = "年日照时数：\(YCStringUtils.getNumber(info.sunlight_year)) 小时"
            self.sunYearTotalLabel.text = "年辐照总量：\(YCStringUtils.getNumber(info.energy_year)) 度/平方米"
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    //MARK: 产能计算
    func initSecondLeftView() {
        secondContentView = UIView.init(frame: CGRect(x: leftButton1.frame.size.width, y: 0, width: PhoneUtils.kScreenWidth - leftButton1.frame.size.width, height: contentScrollView.frame.size.height))
        secondContentView.backgroundColor = UIColor.white
        secondContentView.isHidden = true
        self.addLeftShadow(view: secondContentView)
        contentScrollView.addSubview(secondContentView)
        
        secondContentScroll = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: secondContentView.frame.size.width, height: secondContentView.frame.size.height - 50 * times))
        secondContentView.addSubview(secondContentScroll)
        
        let roofSizeLabel = UILabel.init(frame: CGRect(x: 0, y: 5 * times, width: 60 * times, height: 34 * times))
        roofSizeLabel.text = "屋顶面积"
        roofSizeLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        roofSizeLabel.textAlignment = NSTextAlignment.center
        secondContentScroll.addSubview(roofSizeLabel)
        
        roofSizeTextField = UITextField.init(frame: CGRect(x: roofSizeLabel.frame.maxX, y: 5 * times, width: 210 * times, height: 34 * times))
        roofSizeTextField.keyboardType = UIKeyboardType.numberPad
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
        
        roofTypeButton = UIButton.init(frame: CGRect(x: roofTypeLabel.frame.maxX, y: roofSizeTextField.frame.maxY + 10 * times, width: 210 * times, height: 34 * times))
        roofTypeButton.setTitle("平顶", for: UIControlState.normal)
        roofTypeButton.layer.cornerRadius = 3
        roofTypeButton.layer.borderColor = UIColor.lightGray.cgColor
        roofTypeButton.layer.borderWidth = 0.5
        roofTypeButton.layer.masksToBounds = true
        roofTypeButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        roofTypeButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        roofTypeButton.addTarget(self, action: #selector(self.showTypeAction), for: UIControlEvents.touchUpInside)
        secondContentScroll.addSubview(roofTypeButton)
        
        let darkIcons = UIImageView.init(frame: CGRect(x: roofTypeButton.frame.size.width - 20 * times, y: (roofTypeButton.frame.size.height - 8 * times) / 2, width: 13 * times, height: 8 * times))
        darkIcons.image = UIImage(named: "ic_arrow_down_black")
        roofTypeButton.addSubview(darkIcons)
        
        let roofTypeRightLabel = UILabel.init(frame: CGRect(x: roofTypeButton.frame.maxX, y: roofSizeTextField.frame.maxY + 10 * times, width: secondContentScroll.frame.size.width - roofTypeButton.frame.maxX, height: 34 * times))
        roofTypeRightLabel.text = "朝南"
        roofTypeRightLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        roofTypeRightLabel.textAlignment = NSTextAlignment.center
        secondContentScroll.addSubview(roofTypeRightLabel)
        
        let calButton = UIButton.init(type: UIButtonType.custom)
        calButton.frame = CGRect(x: (secondContentScroll.frame.size.width - 268 * times) / 2, y: roofTypeButton.frame.maxY + 5 * times, width: 268 * times, height: 38 * times)
        calButton.setTitle("计算", for: UIControlState.normal)
        self.setCalBlueButtonCommonSet(btn: calButton)
        calButton.addTarget(self, action: #selector(self.loadCNData), for: UIControlEvents.touchUpInside)
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
        ckqjLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY, width: labelWidth, height: labelHeight))
        ckqjLabel.text = "参考倾角：-- 度"
        ckqjLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(ckqjLabel)
        currentY = ckqjLabel.frame.maxY
        
        zjrlLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        zjrlLabel.text = "装机容量：-- 千瓦"
        zjrlLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(zjrlLabel)
        currentY = zjrlLabel.frame.maxY
        
        mwtzjeLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: 95 * times, height: labelHeight))
        mwtzjeLabel.text = "每瓦投资金额："
        mwtzjeLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(mwtzjeLabel)
        
        mwtzjeTextField = UITextField.init(frame: CGRect(x: mwtzjeLabel.frame.maxX, y: currentY + 5 * times, width: 65 * times, height: labelHeight))
        mwtzjeTextField.keyboardType = UIKeyboardType.numberPad
        mwtzjeTextField.layer.cornerRadius = 3
        mwtzjeTextField.layer.borderColor = UIColor.lightGray.cgColor
        mwtzjeTextField.layer.borderWidth = 0.5
        mwtzjeTextField.layer.masksToBounds = true
        mwtzjeTextField.textAlignment = NSTextAlignment.center
        mwtzjeTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        secondContentScroll.addSubview(mwtzjeTextField)
        
        let mwtzjeRightLabel = UILabel.init(frame: CGRect(x: mwtzjeTextField.frame.maxX, y: currentY + 5 * times, width: 20 * times, height: labelHeight))
        mwtzjeRightLabel.text = "元"
        mwtzjeRightLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(mwtzjeRightLabel)
        mwtzjeRightLabel.textAlignment = NSTextAlignment.center
        currentY = mwtzjeRightLabel.frame.maxY
        
        tzjeLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        tzjeLabel.text = "投资金额：-- 元"
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
        
        snfdlyxsLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        snfdlyxsLabel.text = "首年发电利用小时：-- 小时"
        snfdlyxsLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(snfdlyxsLabel)
        currentY = snfdlyxsLabel.frame.maxY
        
        let snmqwrfdlLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: 135 * times, height: labelHeight))
        snmqwrfdlLabel.text = "首年每千瓦日发电量："
        snmqwrfdlLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(snmqwrfdlLabel)
        
        snmqwrfdTextField = UITextField.init(frame: CGRect(x: snmqwrfdlLabel.frame.maxX, y: currentY + 5 * times, width: 65 * times, height: labelHeight))
        snmqwrfdTextField.keyboardType = UIKeyboardType.numberPad
        snmqwrfdTextField.layer.cornerRadius = 3
        snmqwrfdTextField.layer.borderColor = UIColor.lightGray.cgColor
        snmqwrfdTextField.layer.borderWidth = 0.5
        snmqwrfdTextField.layer.masksToBounds = true
        snmqwrfdTextField.textAlignment = NSTextAlignment.center
        snmqwrfdTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        secondContentScroll.addSubview(snmqwrfdTextField)
        
        let snmqwrfdRightLabel = UILabel.init(frame: CGRect(x: snmqwrfdTextField.frame.maxX, y: currentY + 5 * times, width: 20 * times, height: labelHeight))
        snmqwrfdRightLabel.text = "度"
        snmqwrfdRightLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(snmqwrfdRightLabel)
        snmqwrfdRightLabel.textAlignment = NSTextAlignment.center
        currentY = snmqwrfdRightLabel.frame.maxY
        
        snrfdLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        snrfdLabel.text = "首年日发电：-- 度"
        snrfdLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(snrfdLabel)
        currentY = snrfdLabel.frame.maxY
        
        snzfdLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        snzfdLabel.text = "首年总发电：-- 度"
        snzfdLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(snzfdLabel)
        currentY = snzfdLabel.frame.maxY
        
        zfd25Label = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        zfd25Label.text = "25年总发电：-- 度"
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
        
        jybztLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        jybztLabel.text = "节约标准碳：-- 千克"
        jybztLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(jybztLabel)
        currentY = jybztLabel.frame.maxY
        
        co2Label = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        co2Label.text = "减少CO₂排放：-- 千克"
        co2Label.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(co2Label)
        currentY = co2Label.frame.maxY
        
        so2Label = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        so2Label.text = "减少SO₂排放：-- 千克"
        so2Label.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(so2Label)
        currentY = so2Label.frame.maxY
        
        no2Label = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        no2Label.text = "减少氮化物排放：-- 千克"
        no2Label.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(no2Label)
        currentY = no2Label.frame.maxY
        
        smokeLabel = UILabel.init(frame: CGRect(x: offSetX, y: currentY + 5 * times, width: labelWidth, height: labelHeight))
        smokeLabel.text = "减少烟雾排放：-- 千克"
        smokeLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        secondContentScroll.addSubview(smokeLabel)
        currentY = smokeLabel.frame.maxY
        
        secondContentScroll.contentSize = CGSize(width: 0, height: currentY)
        
        let bottomOffSetX = (secondContentView.frame.size.width - 124 * times * 2) / 3
        let reCalButton = UIButton.init(type: UIButtonType.custom)
        reCalButton.frame = CGRect(x: bottomOffSetX, y: secondContentScroll.frame.maxY, width: 124 * times, height: 38 * times)
        reCalButton.setTitle("重新计算", for: UIControlState.normal)
        self.setCalBlueButtonCommonSet(btn: reCalButton)
        reCalButton.addTarget(self, action: #selector(self.loadCNData), for: UIControlEvents.touchUpInside)
        secondContentView.addSubview(reCalButton)
        
        let nextStepButton = UIButton.init(type: UIButtonType.custom)
        nextStepButton.frame = CGRect(x: bottomOffSetX * 2 + 124 * times, y: secondContentScroll.frame.maxY, width: 124 * times, height: 38 * times)
        nextStepButton.setTitle("下一步", for: UIControlState.normal)
        self.setCalBlueButtonCommonSet(btn: nextStepButton)
        nextStepButton.addTarget(self, action: #selector(self.nextStep), for: UIControlEvents.touchUpInside)
        secondContentView.addSubview(nextStepButton)
    }
    
    //产能计算
    func loadCNData() {
        if (YCStringUtils.isEmpty(roofSizeTextField.text!)) {
            self.showHint("请输入屋顶面积")
            return
        }
        if (type == 0) {
            self.showHint("请选择安装方式")
            return
        }
        var wOfPrice = "8"
        var firstYearKwElectric = "4"
        if (!YCStringUtils.isEmpty(mwtzjeTextField.text!)) {
            wOfPrice = mwtzjeTextField.text!
        }
        if (!YCStringUtils.isEmpty(snmqwrfdTextField.text!)) {
            firstYearKwElectric = snmqwrfdTextField.text!
        }
        self.showHud(in: self.view, hint: "获取数据中...")
        API.sharedInstance.projectcalEnergycal(type: type, size: roofSizeTextField.text!, lat: currentLat!, lng: currentLng!, wOfPrice: wOfPrice, firstYearKwElectric: firstYearKwElectric, success: { (info) in
            self.hideHud()
            self.energyCalInfo = info
            self.ckqjLabel.text = "参考倾角：\(YCStringUtils.getNumber(info.sample_angle).doubleValue) 度"
            self.zjrlLabel.text = "装机容量：\(YCStringUtils.getNumber(info.build_size).doubleValue) 千瓦"
            self.mwtzjeTextField.text = "\(YCStringUtils.getNumber(info.wOfPrice).doubleValue)"
            self.tzjeLabel.text = "投资金额：\(YCStringUtils.getNumber(info.build_price).doubleValue) 元"
            self.snfdlyxsLabel.text = "首年发电利用小时：\(YCStringUtils.getNumber(info.electric_firstyear_hours).doubleValue) 小时"
            self.snmqwrfdTextField.text = "\(YCStringUtils.getNumber(info.firstYearKwElectric).doubleValue)"
            self.snrfdLabel.text = "首年日发电：\(YCStringUtils.getNumber(info.electric_firstyear_dayaverage).doubleValue) 度"
            self.snzfdLabel.text = "首年总发电：\(YCStringUtils.getNumber(info.electric_firstyear_total).doubleValue) 度"
            self.zfd25Label.text = "25年总发电：\(YCStringUtils.getNumber(info.electric_25).doubleValue) 度"
            self.jybztLabel.text = "节约标准碳：\(YCStringUtils.getNumber(info.reduce_c).doubleValue) 千克"
            self.co2Label.text = "减少CO₂排放：\(YCStringUtils.getNumber(info.reduce_co2).doubleValue) 千克"
            self.so2Label.text = "减少SO₂排放：\(YCStringUtils.getNumber(info.reduce_so2).doubleValue) 千克"
            self.no2Label.text = "减少氮化物排放：\(YCStringUtils.getNumber(info.reduce_nox).doubleValue) 千克"
            self.smokeLabel.text = "减少烟雾排放：\(YCStringUtils.getNumber(info.reduce_smoke).doubleValue) 千克"
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    func showTypeAction() {
        let vc = UIAlertController.init(title: "选择铺设方式", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        let type1Action = UIAlertAction.init(title: "平顶", style: UIAlertActionStyle.default) { (action) in
            self.roofTypeButton.setTitle("平顶", for: UIControlState.normal)
            self.type = 1
        }
        let type2Action = UIAlertAction.init(title: "斜顶", style: UIAlertActionStyle.default) { (action) in
            self.roofTypeButton.setTitle("斜顶", for: UIControlState.normal)
            self.type = 2
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        vc.addAction(type1Action)
        vc.addAction(type2Action)
        vc.addAction(cancelAction)
        self.present(vc, animated: true, completion: nil)
    }
    
    
    //#MARK: 收益分析
    func initThirdLeftView() {
        thirdContentView = UIView.init(frame: CGRect(x: leftButton1.frame.size.width, y: 0, width: PhoneUtils.kScreenWidth - leftButton1.frame.size.width, height: contentScrollView.frame.size.height))
        thirdContentView.backgroundColor = UIColor.white
        thirdContentView.isHidden = true
        self.addLeftShadow(view: thirdContentView)
        contentScrollView.addSubview(thirdContentView)
        
        thirdContentScroll = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: thirdContentView.frame.size.width, height: thirdContentView.frame.size.height - 50 * times))
        thirdContentView.addSubview(thirdContentScroll)
        
        //投资金额
        let tzjeLabel = UILabel.init(frame: CGRect(x: 10 * times, y: 15 * times, width: 55 * times, height: 35 * times))
        tzjeLabel.text = "投资金额"
        tzjeLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        thirdContentScroll.addSubview(tzjeLabel)
        
        tzjeValueLabel = UILabel.init(frame: CGRect(x: tzjeLabel.frame.maxX, y: 15 * times, width: 224 * times, height: 35 * times))
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
        
        khsldzjTextField = UITextField.init(frame: CGRect(x: khsldzjLabel.frame.maxX, y: currentY + 10 * times, width: 180 * times, height: 35 * times))
        khsldzjTextField.keyboardType = UIKeyboardType.numberPad
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
        
        ywcbTextField = UITextField.init(frame: CGRect(x: ywcbLabel.frame.maxX, y: currentY + 10 * times, width: 224 * times, height: 35 * times))
        ywcbTextField.keyboardType = UIKeyboardType.numberPad
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
        
        zjbtTextField = UITextField.init(frame: CGRect(x: ywcbLabel.frame.maxX, y: currentY + 10 * times, width: 215 * times, height: 35 * times))
        zjbtTextField.keyboardType = UIKeyboardType.numberPad
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
        
        dkblPercentTextField = UITextField.init(frame: CGRect(x: dkblLabel.frame.maxX, y: currentY + 10 * times, width: 95 * times, height: 35 * times))
        dkblPercentTextField.keyboardType = UIKeyboardType.numberPad
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
        
        dkblYearsTextField = UITextField.init(frame: CGRect(x: dkblMiddleLabel.frame.maxX, y: currentY + 10 * times, width: 95 * times, height: 35 * times))
        dkblYearsTextField.keyboardType = UIKeyboardType.numberPad
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
        currentY = line.frame.maxY
        
        //上网模式
        let netMethodLabel = UILabel.init(frame: CGRect(x: 10 * times, y: currentY + 10 * times, width: 55 * times, height: 35 * times))
        netMethodLabel.text = "上网模式"
        netMethodLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        thirdContentScroll.addSubview(netMethodLabel)
        
        leftCheckBox = UIButton.init(frame: CGRect(x: netMethodLabel.frame.maxX, y: currentY + 10 * times, width: 110 * times, height: 35 * times))
        leftCheckBox.setTitleColor(UIColor.black, for: UIControlState.normal)
        leftCheckBox.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        leftCheckBox.setTitle("全额上网", for: UIControlState.normal)
        leftCheckBox.setImage(UIImage(named: "checkbox_hl"), for: UIControlState.selected)
        leftCheckBox.setImage(UIImage(named: "checkbox"), for: UIControlState.normal)
        leftCheckBox.addTarget(self, action: #selector(self.checkBoxButtonClicked), for: UIControlEvents.touchUpInside)
        thirdContentScroll.addSubview(leftCheckBox)
        leftCheckBox.isSelected = true
        
        rightCheckBox = UIButton.init(frame: CGRect(x: leftCheckBox.frame.maxX + 5 * times, y: currentY + 10 * times, width: 110 * times, height: 35 * times))
        rightCheckBox.setTitleColor(UIColor.black, for: UIControlState.normal)
        rightCheckBox.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        rightCheckBox.setTitle("余电上网", for: UIControlState.normal)
        rightCheckBox.setImage(UIImage(named: "checkbox_hl"), for: UIControlState.selected)
        rightCheckBox.setImage(UIImage(named: "checkbox"), for: UIControlState.normal)
        rightCheckBox.addTarget(self, action: #selector(self.checkBoxButtonClicked), for: UIControlEvents.touchUpInside)
        thirdContentScroll.addSubview(rightCheckBox)
        currentY = rightCheckBox.frame.maxY
        
        //自用电比例
        let zydblLabel = UILabel.init(frame: CGRect(x: 10 * times, y: currentY + 10 * times, width: 75 * times, height: 35 * times))
        zydblLabel.text = "自用电比例"
        zydblLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        thirdContentScroll.addSubview(zydblLabel)
        
        zydblTextField = UITextField.init(frame: CGRect(x: zydblLabel.frame.maxX, y: currentY + 10 * times, width: 190 * times, height: 35 * times))
        zydblTextField.keyboardType = UIKeyboardType.numberPad
        zydblTextField.layer.cornerRadius = 3
        zydblTextField.layer.borderColor = UIColor.lightGray.cgColor
        zydblTextField.layer.borderWidth = 0.5
        zydblTextField.layer.masksToBounds = true
        zydblTextField.textAlignment = NSTextAlignment.center
        zydblTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        thirdContentScroll.addSubview(zydblTextField)
        
        let zydblRightLabel = UILabel.init(frame: CGRect(x: zydblTextField.frame.maxX, y: currentY + 10 * times, width: thirdContentScroll.frame.size.width - zydblTextField.frame.maxX, height: 35 * times))
        zydblRightLabel.text = "%"
        zydblRightLabel.textAlignment = NSTextAlignment.center
        zydblRightLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        thirdContentScroll.addSubview(zydblRightLabel)
        currentY = zydblRightLabel.frame.maxY
        
        //自用电电价
        let zyddjLabel = UILabel.init(frame: CGRect(x: 10 * times, y: currentY + 10 * times, width: 75 * times, height: 35 * times))
        zyddjLabel.text = "自用电电价"
        zyddjLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        thirdContentScroll.addSubview(zyddjLabel)
        
        zyddjTextField = UITextField.init(frame: CGRect(x: zyddjLabel.frame.maxX, y: currentY + 10 * times, width: 190 * times, height: 35 * times))
        zyddjTextField.keyboardType = UIKeyboardType.numberPad
        zyddjTextField.layer.cornerRadius = 3
        zyddjTextField.layer.borderColor = UIColor.lightGray.cgColor
        zyddjTextField.layer.borderWidth = 0.5
        zyddjTextField.layer.masksToBounds = true
        zyddjTextField.textAlignment = NSTextAlignment.center
        zyddjTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        thirdContentScroll.addSubview(zyddjTextField)
        
        let zyddjRightLabel = UILabel.init(frame: CGRect(x: zyddjTextField.frame.maxX, y: currentY + 10 * times, width: thirdContentScroll.frame.size.width - zyddjTextField.frame.maxX, height: 35 * times))
        zyddjRightLabel.text = "元/度"
        zyddjRightLabel.textAlignment = NSTextAlignment.center
        zyddjRightLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        thirdContentScroll.addSubview(zyddjRightLabel)
        currentY = zyddjRightLabel.frame.maxY
        
        //用电补贴
        let ydbtLabel = UILabel.init(frame: CGRect(x: 10 * times, y: currentY + 10 * times, width: 55 * times, height: 35 * times))
        ydbtLabel.text = "用电补贴"
        ydbtLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        thirdContentScroll.addSubview(ydbtLabel)
        
        ydbtPriceTextField = UITextField.init(frame: CGRect(x: ydbtLabel.frame.maxX, y: currentY + 10 * times, width: 90 * times, height: 35 * times))
        ydbtPriceTextField.keyboardType = UIKeyboardType.numberPad
        ydbtPriceTextField.layer.cornerRadius = 3
        ydbtPriceTextField.layer.borderColor = UIColor.lightGray.cgColor
        ydbtPriceTextField.layer.borderWidth = 0.5
        ydbtPriceTextField.layer.masksToBounds = true
        ydbtPriceTextField.textAlignment = NSTextAlignment.center
        ydbtPriceTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        thirdContentScroll.addSubview(ydbtPriceTextField)
        
        let ydbtMiddleLabel = UILabel.init(frame: CGRect(x: ydbtPriceTextField.frame.maxX, y: currentY + 10 * times, width: 40 * times, height: 35 * times))
        ydbtMiddleLabel.text = "元/度"
        ydbtMiddleLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        ydbtMiddleLabel.textAlignment = NSTextAlignment.center
        thirdContentScroll.addSubview(ydbtMiddleLabel)
        
        ydbtYearsTextField = UITextField.init(frame: CGRect(x: ydbtMiddleLabel.frame.maxX, y: currentY + 10 * times, width: 90 * times, height: 35 * times))
        ydbtYearsTextField.keyboardType = UIKeyboardType.numberPad
        ydbtYearsTextField.layer.cornerRadius = 3
        ydbtYearsTextField.layer.borderColor = UIColor.lightGray.cgColor
        ydbtYearsTextField.layer.borderWidth = 0.5
        ydbtYearsTextField.layer.masksToBounds = true
        ydbtYearsTextField.textAlignment = NSTextAlignment.center
        ydbtYearsTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        thirdContentScroll.addSubview(ydbtYearsTextField)
        
        let ydbtRightLabel = UILabel.init(frame: CGRect(x: ydbtYearsTextField.frame.maxX, y: currentY + 10 * times, width: thirdContentScroll.frame.size.width - ydbtYearsTextField.frame.maxX, height: 35 * times))
        ydbtRightLabel.text = "年"
        ydbtRightLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        ydbtRightLabel.textAlignment = NSTextAlignment.center
        thirdContentScroll.addSubview(ydbtRightLabel)
        currentY = ydbtRightLabel.frame.maxY
        
        //余电上网价
        let ydswjLabel = UILabel.init(frame: CGRect(x: 10 * times, y: currentY + 10 * times, width: 75 * times, height: 35 * times))
        ydswjLabel.text = "余电上网价"
        ydswjLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        thirdContentScroll.addSubview(ydswjLabel)
        
        ydswjTextField = UITextField.init(frame: CGRect(x: ydswjLabel.frame.maxX, y: currentY + 10 * times, width: 190 * times, height: 35 * times))
        ydswjTextField.keyboardType = UIKeyboardType.numberPad
        ydswjTextField.layer.cornerRadius = 3
        ydswjTextField.layer.borderColor = UIColor.lightGray.cgColor
        ydswjTextField.layer.borderWidth = 0.5
        ydswjTextField.layer.masksToBounds = true
        ydswjTextField.textAlignment = NSTextAlignment.center
        ydswjTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        thirdContentScroll.addSubview(ydswjTextField)
        
        let ydswjRightLabel = UILabel.init(frame: CGRect(x: ydswjTextField.frame.maxX, y: currentY + 10 * times, width: thirdContentScroll.frame.size.width - ydswjTextField.frame.maxX, height: 35 * times))
        ydswjRightLabel.text = "元/瓦"
        ydswjRightLabel.textAlignment = NSTextAlignment.center
        ydswjRightLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        thirdContentScroll.addSubview(ydswjRightLabel)
        currentY = ydswjRightLabel.frame.maxY
        
        thirdContentScroll.contentSize = CGSize(width: 0, height: currentY)
        
        let bottomOffSetX = (thirdContentView.frame.size.width - 124 * times * 2) / 3
        let reCalButton = UIButton.init(type: UIButtonType.custom)
        reCalButton.frame = CGRect(x: bottomOffSetX, y: thirdContentScroll.frame.maxY, width: 124 * times, height: 38 * times)
        reCalButton.setTitle("计算收益", for: UIControlState.normal)
        self.setCalBlueButtonCommonSet(btn: reCalButton)
        reCalButton.addTarget(self, action: #selector(self.calSYButtonClicked), for: UIControlEvents.touchUpInside)
        thirdContentView.addSubview(reCalButton)
        
        let nextStepButton = UIButton.init(type: UIButtonType.custom)
        nextStepButton.frame = CGRect(x: bottomOffSetX * 2 + 124 * times, y: thirdContentScroll.frame.maxY, width: 124 * times, height: 38 * times)
        nextStepButton.setTitle("下一步", for: UIControlState.normal)
        self.setCalBlueButtonCommonSet(btn: nextStepButton)
        nextStepButton.addTarget(self, action: #selector(self.nextStep), for: UIControlEvents.touchUpInside)
        thirdContentView.addSubview(nextStepButton)
    }
    
    func calSYButtonClicked() {
        if (YCStringUtils.isEmpty(khsldzjTextField.text!)) {
            self.showHint("可回收流动资金不能为空")
            return
        }
        if (YCStringUtils.isEmpty(ywcbTextField.text!)) {
            self.showHint("运维成本不能为空")
            return
        }
        if (YCStringUtils.isEmpty(zjbtTextField.text!)) {
            self.showHint("装机补贴不能为空")
            return
        }
        if (YCStringUtils.isEmpty(dkblPercentTextField.text!)) {
            self.showHint("贷款比例不能为空")
            return
        }
        if (YCStringUtils.isEmpty(dkblYearsTextField.text!)) {
            self.showHint("贷款年数不能为空")
            return
        }
        if (YCStringUtils.isEmpty(zydblTextField.text!)) {
            self.showHint("自用电比例不能为空")
            return
        }
        if (YCStringUtils.isEmpty(zyddjTextField.text!)) {
            self.showHint("自用电电价不能为空")
            return
        }
        if (YCStringUtils.isEmpty(ydbtPriceTextField.text!)) {
            self.showHint("用电补贴价格不能为空")
            return
        }
        if (YCStringUtils.isEmpty(ydbtYearsTextField.text!)) {
            self.showHint("用电补贴年数不能为空")
            return
        }
        if (YCStringUtils.isEmpty(ydswjTextField.text!)) {
            self.showHint("余电上网价不能为空")
            return
        }
        
        let tmpParams = CalResultParams()
        tmpParams.address = locationButton.titleLabel?.text!
        tmpParams.type = NSNumber.init(value: type)
        tmpParams.size = roofSizeTextField.text!
        tmpParams.invest_amount = energyCalInfo!.build_price
        let ywcbPercent = NSString.init(string: ywcbTextField.text!)
        let ywcbValue = ywcbPercent.floatValue * energyCalInfo!.build_price!.floatValue
        
        tmpParams.annual_maintenance_cost = String(format: "%.2f%", ywcbValue)
        tmpParams.recoverable_liquid_capital = String(format: "%.2f", YCStringUtils.getNumber(energyCalInfo!.build_price).floatValue * 0.05)
        tmpParams.installed_subsidy = zjbtTextField.text!
        tmpParams.loan_ratio = String(format: "%.2f", NSString.init(string: dkblPercentTextField.text!).floatValue * NSString.init(string: tzjeValueLabel.text!).floatValue / 100)
        tmpParams.years_of_loans = dkblYearsTextField.text!
        tmpParams.occupied_electric_ratio = zydblTextField.text!
        tmpParams.electric_price_perional = zyddjTextField.text!
        tmpParams.electricity_subsidy = ydbtPriceTextField.text!
        tmpParams.electricity_subsidy_year = ydbtYearsTextField.text!
        tmpParams.sparetime_electric_price = ydswjTextField.text!
        tmpParams.wOfPrice = mwtzjeLabel.text
        tmpParams.firstYearKwElectric = snmqwrfdTextField.text!
        
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let tabVC = sb.instantiateViewController(withIdentifier: "CalResultTabBar") as! UITabBarController
        let first = tabVC.viewControllers?.first as! RootComViewController
        first.params = tmpParams
        
        let second = tabVC.viewControllers?[1] as! RootElectricViewController
        second.params = tmpParams
        
        let third = tabVC.viewControllers?[2] as! RootPayViewController
        third.params = tmpParams
        
        let fourth = tabVC.viewControllers?[3] as! RootEarnViewController
        fourth.params = tmpParams
        self.pushViewController(tabVC)
    }
    
    func checkBoxButtonClicked() {
        if (leftCheckBox.isSelected) {
            leftCheckBox.isSelected = false
            rightCheckBox.isSelected = true
        } else {
            leftCheckBox.isSelected = true
            rightCheckBox.isSelected = false
        }
        getSYParams()
    }
    
    //获取收益分析的参数
    func getSYParams() {
        self.showHud(in: self.view, hint: "加载中...")
        API.sharedInstance.getCityFromLatlng(lat: currentLat!, lng: currentLng!, success: { (locationInfo) in
            API.sharedInstance.incomecalParams(lat: self.currentLat!, lng: self.currentLng!, province: locationInfo.province_id!, city: locationInfo.city_id!, area: locationInfo.area_id!, type: NSNumber.init(value: self.type), size: self.roofSizeTextField.text!, onlineType:
                self.leftCheckBox.isSelected == true ? 1 : 2, success: { (params) in
                    self.hideHud()
                    self.inputSYValues(params: params)
            }) { (msg) in
                self.hideHud()
                self.showHint(msg)
            }
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    func inputSYValues(params: IncomeCalParams) {
        tzjeValueLabel.text = "\(YCStringUtils.getNumber(energyCalInfo!.build_price))"
        khsldzjTextField.text = "\(YCStringUtils.getNumber(energyCalInfo!.build_price).doubleValue * 0.05)"
        if (YCStringUtils.isEmpty(ywcbTextField.text!)) {
            ywcbTextField.text = "\(YCStringUtils.getNumber(params.annual_maintenance_cost).doubleValue)"
        }
        if (YCStringUtils.isEmpty(zjbtTextField.text!)) {
            zjbtTextField.text = "\(YCStringUtils.getNumber(params.installed_subsidy).doubleValue)"
        }
        if (YCStringUtils.isEmpty(dkblPercentTextField.text!)) {
            dkblPercentTextField.text = "\(YCStringUtils.getNumber(params.loan_ratio).doubleValue)"
            dkblYearsTextField.text = "\(YCStringUtils.getNumber(params.years_of_loans).doubleValue)"
        }
        zydblTextField.text = "\(YCStringUtils.getNumber(params.occupied_electric_ratio).doubleValue)"
        zyddjTextField.text = "\(YCStringUtils.getNumber(params.electric_price_perional).doubleValue)"
        ydbtPriceTextField.text = "\(YCStringUtils.getNumber(params.electricity_subsidy).doubleValue)"
        ydbtYearsTextField.text = "\(YCStringUtils.getNumber(params.electricity_subsidy_year).doubleValue)"
        ydswjTextField.text = "\(YCStringUtils.getNumber(params.sparetime_electric_price).doubleValue)"
    }
    
    //#MARK: 现金流向
    func initFourthLeftView() {
        fourthContentView = UIView.init(frame: CGRect(x: leftButton1.frame.size.width, y: 0, width: PhoneUtils.kScreenWidth - leftButton1.frame.size.width, height: contentScrollView.frame.size.height))
        fourthContentView.backgroundColor = UIColor.white
        fourthContentView.isHidden = true
        self.addLeftShadow(view: fourthContentView)
        contentScrollView.addSubview(fourthContentView)
        
        fourthContentScroll = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: fourthContentView.frame.size.width, height: fourthContentView.frame.size.height))
        fourthContentView.addSubview(fourthContentScroll)
        
        //投资金额
        let tzjeLabel = UILabel.init(frame: CGRect(x: 10 * times, y: 15 * times, width: 55 * times, height: 35 * times))
        tzjeLabel.text = "投资金额"
        tzjeLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        fourthContentScroll.addSubview(tzjeLabel)
        
        lxtzjeValueLabel = UILabel.init(frame: CGRect(x: tzjeLabel.frame.maxX, y: 15 * times, width: 224 * times, height: 35 * times))
        lxtzjeValueLabel.text = "0.00"
        lxtzjeValueLabel.textAlignment = NSTextAlignment.center
        lxtzjeValueLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        fourthContentScroll.addSubview(lxtzjeValueLabel)
        
        let tzjeRightLabel = UILabel.init(frame: CGRect(x: lxtzjeValueLabel.frame.maxX, y: 15 * times, width: fourthContentScroll.frame.size.width - lxtzjeValueLabel.frame.maxX, height: 35 * times))
        tzjeRightLabel.text = "元"
        tzjeRightLabel.textAlignment = NSTextAlignment.center
        tzjeRightLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        fourthContentScroll.addSubview(tzjeRightLabel)
        var currentY = tzjeRightLabel.frame.maxY
        
        //装机容量
        let zjrlLabel = UILabel.init(frame: CGRect(x: 10 * times, y: currentY + 10 * times, width: 55 * times, height: 35 * times))
        zjrlLabel.text = "装机容量"
        zjrlLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        fourthContentScroll.addSubview(zjrlLabel)
        
        lxzjrlValueLabel = UILabel.init(frame: CGRect(x: tzjeLabel.frame.maxX, y: currentY + 10 * times, width: 224 * times, height: 35 * times))
        lxzjrlValueLabel.text = "0.00"
        lxzjrlValueLabel.textAlignment = NSTextAlignment.center
        lxzjrlValueLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        fourthContentScroll.addSubview(lxzjrlValueLabel)
        
        let zjrlRightLabel = UILabel.init(frame: CGRect(x: lxzjrlValueLabel.frame.maxX, y: currentY + 10 * times, width: fourthContentScroll.frame.size.width - lxzjrlValueLabel.frame.maxX, height: 35 * times))
        zjrlRightLabel.text = "千瓦"
        zjrlRightLabel.textAlignment = NSTextAlignment.center
        zjrlRightLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        fourthContentScroll.addSubview(zjrlRightLabel)
        currentY = zjrlRightLabel.frame.maxY
        
        //贷款金额 年数
        let dkjeLabel = UILabel.init(frame: CGRect(x: 10 * times, y: currentY + 10 * times, width: 55 * times, height: 35 * times))
        dkjeLabel.text = "贷　　款"
        dkjeLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        fourthContentScroll.addSubview(dkjeLabel)
        
        lxdkjeLabel = UILabel.init(frame: CGRect(x: dkjeLabel.frame.maxX, y: currentY + 10 * times, width: 95 * times, height: 35 * times))
        lxdkjeLabel.textAlignment = NSTextAlignment.center
        lxdkjeLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        fourthContentScroll.addSubview(lxdkjeLabel)
        
        let dkjeMiddleLabel = UILabel.init(frame: CGRect(x: lxdkjeLabel.frame.maxX, y: currentY + 10 * times, width: 30 * times, height: 35 * times))
        dkjeMiddleLabel.text = "元"
        dkjeMiddleLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        dkjeMiddleLabel.textAlignment = NSTextAlignment.center
        fourthContentScroll.addSubview(dkjeMiddleLabel)
        
        lxdkjeYearsLabel = UILabel.init(frame: CGRect(x: dkjeMiddleLabel.frame.maxX, y: currentY + 10 * times, width: 95 * times, height: 35 * times))
        lxdkjeYearsLabel.textAlignment = NSTextAlignment.center
        lxdkjeYearsLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        fourthContentScroll.addSubview(lxdkjeYearsLabel)
        
        let dkjeRightLabel = UILabel.init(frame: CGRect(x: lxdkjeYearsLabel.frame.maxX, y: currentY + 10 * times, width: fourthContentScroll.frame.size.width - lxdkjeYearsLabel.frame.maxX, height: 35 * times))
        dkjeRightLabel.text = "年"
        dkjeRightLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        dkjeRightLabel.textAlignment = NSTextAlignment.center
        fourthContentScroll.addSubview(dkjeRightLabel)
        currentY = dkjeRightLabel.frame.maxY
        
        //还款方式
        let backTypeLabel = UILabel.init(frame: CGRect(x: 10 * times, y: currentY + 10 * times, width: 55 * times, height: 35 * times))
        backTypeLabel.text = "还款方式"
        backTypeLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        backTypeLabel.textAlignment = NSTextAlignment.center
        fourthContentScroll.addSubview(backTypeLabel)
        
        backTypeButton = UIButton.init(frame: CGRect(x: backTypeLabel.frame.maxX , y: currentY + 10 * times, width: 240 * times, height: 35 * times))
        backTypeButton.setTitle("等额本息", for: UIControlState.normal)
        backTypeButton.layer.cornerRadius = 3
        backTypeButton.layer.borderColor = UIColor.lightGray.cgColor
        backTypeButton.layer.borderWidth = 0.5
        backTypeButton.layer.masksToBounds = true
        backTypeButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        backTypeButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        backTypeButton.addTarget(self, action: #selector(self.showLoanTypeAction), for: UIControlEvents.touchUpInside)
        fourthContentScroll.addSubview(backTypeButton)
        
        let darkIcons = UIImageView.init(frame: CGRect(x: backTypeButton.frame.size.width - 20 * times, y: (backTypeButton.frame.size.height - 8 * times) / 2, width: 13 * times, height: 8 * times))
        darkIcons.image = UIImage(named: "ic_arrow_down_black")
        backTypeButton.addSubview(darkIcons)
        currentY = backTypeButton.frame.maxY
        
        //贷款利率
        let dkllLabel = UILabel.init(frame: CGRect(x: 10 * times, y: currentY + 10 * times, width: 55 * times, height: 35 * times))
        dkllLabel.text = "贷款利率"
        dkllLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        fourthContentScroll.addSubview(dkllLabel)
        
        let llRightView = UILabel.init(frame: CGRect(x: 0, y: 0, width: 30 * times, height: 35 * times))
        llRightView.text = "%"
        llRightView.textAlignment = NSTextAlignment.center
        llRightView.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        
        dkllTextField = UITextField.init(frame: CGRect(x: dkllLabel.frame.maxX, y: currentY + 10 * times, width: 75 * times, height: 35 * times))
        dkllTextField.keyboardType = UIKeyboardType.numberPad
        dkllTextField.layer.cornerRadius = 3
        dkllTextField.layer.borderColor = UIColor.lightGray.cgColor
        dkllTextField.layer.borderWidth = 0.5
        dkllTextField.layer.masksToBounds = true
        dkllTextField.textAlignment = NSTextAlignment.center
        dkllTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        dkllTextField.rightViewMode = UITextFieldViewMode.always
        dkllTextField.rightView = llRightView
        dkllTextField.addTarget(self, action: #selector(self.valueChanged(textField:)), for: UIControlEvents.allEditingEvents)
        fourthContentScroll.addSubview(dkllTextField)
        
        let dkllMiddleLabel = UILabel.init(frame: CGRect(x: dkllTextField.frame.maxX, y: currentY + 10 * times, width: 30 * times, height: 35 * times))
        dkllMiddleLabel.text = "x"
        dkllMiddleLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        dkllMiddleLabel.textAlignment = NSTextAlignment.center
        fourthContentScroll.addSubview(dkllMiddleLabel)
        
        let timesRightView = UILabel.init(frame: CGRect(x: 0, y: 0, width: 30 * times, height: 35 * times))
        timesRightView.text = "倍"
        timesRightView.textAlignment = NSTextAlignment.center
        timesRightView.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        
        dkllTimesTextField = UITextField.init(frame: CGRect(x: dkllMiddleLabel.frame.maxX, y: currentY + 10 * times, width: 75 * times, height: 35 * times))
        dkllTimesTextField.keyboardType = UIKeyboardType.numberPad
        dkllTimesTextField.layer.cornerRadius = 3
        dkllTimesTextField.layer.borderColor = UIColor.lightGray.cgColor
        dkllTimesTextField.layer.borderWidth = 0.5
        dkllTimesTextField.layer.masksToBounds = true
        dkllTimesTextField.textAlignment = NSTextAlignment.center
        dkllTimesTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 12))
        dkllTimesTextField.rightViewMode = UITextFieldViewMode.always
        dkllTimesTextField.rightView = timesRightView
        dkllTimesTextField.addTarget(self, action: #selector(self.valueChanged(textField:)), for: UIControlEvents.allEditingEvents)
        fourthContentScroll.addSubview(dkllTimesTextField)
        
        dkllRightLabel = UILabel.init(frame: CGRect(x: dkllTimesTextField.frame.maxX, y: currentY + 10 * times, width: thirdContentScroll.frame.size.width - dkllTimesTextField.frame.maxX, height: 35 * times))
        dkllRightLabel.text = "= 4.9%"
        dkllRightLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
        dkllRightLabel.textAlignment = NSTextAlignment.center
        fourthContentScroll.addSubview(dkllRightLabel)
        currentY = dkllRightLabel.frame.maxY
        
        let startCalButton = UIButton.init(type: UIButtonType.custom)
        startCalButton.frame = CGRect(x: (fourthContentScroll.frame.size.width - 268 * times) / 2, y: currentY + 30 * times, width: 268 * times, height: 38 * times)
        startCalButton.setTitle("开始计算", for: UIControlState.normal)
        self.setCalBlueButtonCommonSet(btn: startCalButton)
        startCalButton.addTarget(self, action: #selector(self.calCashButtonClicked), for: UIControlEvents.touchUpInside)
        fourthContentScroll.addSubview(startCalButton)
    }
    
    func showLoanTypeAction() {
        let vc = UIAlertController.init(title: "选择还款方式", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        let type1Action = UIAlertAction.init(title: "等额本息", style: UIAlertActionStyle.default) { (action) in
            self.backTypeButton.setTitle("等额本息", for: UIControlState.normal)
            self.loanType = 1
        }
        let type2Action = UIAlertAction.init(title: "等额本金", style: UIAlertActionStyle.default) { (action) in
            self.backTypeButton.setTitle("等额本金", for: UIControlState.normal)
            self.loanType = 2
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        vc.addAction(type1Action)
        vc.addAction(type2Action)
        vc.addAction(cancelAction)
        self.present(vc, animated: true, completion: nil)
    }
    
    func valueChanged(textField: UITextField) {
        let rate = NSString.init(string: dkllTextField.text!).floatValue * NSString.init(string: dkllTimesTextField.text!).floatValue
        dkllRightLabel.text = String(format: "= %.2f%%", rate)
    }
    
    func inputXMCSValues() {
        let dkbl = NSString.init(string: dkblPercentTextField.text!).floatValue
        let tzje = NSString.init(string: "\(YCStringUtils.getNumber(energyCalInfo!.build_price))").floatValue
        
        lxtzjeValueLabel.text = "\(YCStringUtils.getNumber(energyCalInfo!.build_price))"
        lxzjrlValueLabel.text = "\(YCStringUtils.getNumber(energyCalInfo!.build_size))"
        lxdkjeLabel.text = String(format: "%.2f", dkbl * tzje / 100)
        lxdkjeYearsLabel.text = dkblYearsTextField.text!
        dkllTextField.text = "4.9"
        dkllTimesTextField.text = "1.0"
    }
    
    func calCashButtonClicked() {
        if (dkllTextField.text!.isEmpty) {
            self.showHint("贷款利率不能为空!")
            return
        }
        if (dkllTimesTextField.text!.isEmpty) {
            self.showHint("利率倍数不能为空!")
            return
        }
        let tmpParams = CalResultParams()
        tmpParams.address = locationButton.titleLabel?.text!
        tmpParams.type = NSNumber.init(value: type)
        tmpParams.size = roofSizeTextField.text!
        tmpParams.invest_amount = energyCalInfo!.build_price
        let ywcbPercent = NSString.init(string: ywcbTextField.text!)
        let ywcbValue = ywcbPercent.floatValue * energyCalInfo!.build_price!.floatValue
        
        tmpParams.annual_maintenance_cost = String(format: "%.2f%", ywcbValue)
        tmpParams.recoverable_liquid_capital = String(format: "%.2f", YCStringUtils.getNumber(energyCalInfo!.build_price).floatValue * 0.05)
        tmpParams.installed_subsidy = zjbtTextField.text!
        tmpParams.loan_ratio = String(format: "%.2f", NSString.init(string: dkblPercentTextField.text!).floatValue * NSString.init(string: tzjeValueLabel.text!).floatValue)
        tmpParams.years_of_loans = lxdkjeYearsLabel.text!
        tmpParams.occupied_electric_ratio = zydblTextField.text!
        tmpParams.electric_price_perional = zyddjTextField.text!
        tmpParams.electricity_subsidy = ydbtPriceTextField.text!
        tmpParams.electricity_subsidy_year = ydbtYearsTextField.text!
        tmpParams.sparetime_electric_price = ydswjTextField.text!
        tmpParams.wOfPrice = mwtzjeTextField.text
        tmpParams.firstYearKwElectric = snmqwrfdTextField.text!
        tmpParams.onlineType = leftCheckBox.isSelected == true ? "1" : "2"
        
        let rate = NSString.init(string: dkllTextField.text!).floatValue * NSString.init(string: dkllTimesTextField.text!).floatValue
        tmpParams.loan_rate = "\(rate)"
        tmpParams.loan_type = "\(loanType)"
        
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CashListViewController") as! CashListViewController
        vc.params = tmpParams
        self.pushViewController(vc)
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
    
    func hideAllView() {
        firstContentView.isHidden = true
        secondContentView.isHidden = true
        thirdContentView.isHidden = true
        fourthContentView.isHidden = true
    }
    
    //#MARK 下一步
    func nextStep() {
        if (firstContentView.isHidden == false) {
            if (projectCalInfo == nil) {
                self.showHint("请先计算项目选址数据")
                return
            }
            hideAllView()
            self.secondContentView.isHidden = false
            changeStepButtonWithIndex(index: 1)
        } else if (secondContentView.isHidden == false) {
            if (energyCalInfo == nil) {
                self.showHint("请先计算产能计算数据")
                return
            }
            hideAllView()
            self.thirdContentView.isHidden = false
            changeStepButtonWithIndex(index: 2)
            getSYParams()
        } else if (thirdContentView.isHidden == false) {
            if (projectCalInfo == nil) {
                self.showHint("请先计算项目选址数据")
                return
            }
            if (energyCalInfo == nil) {
                self.showHint("请先计算产能计算数据")
                return
            }
            hideAllView()
            self.fourthContentView.isHidden = false
            changeStepButtonWithIndex(index: 3)
            inputXMCSValues()
        }
    }
    
    func resetStepButton() {
        self.leftButton1.backgroundColor = Colors.calUnSelectColor
        self.leftButton1.setTitleColor(Colors.calUnSelectTextColor, for: UIControlState.normal)
        
        self.leftButton2.backgroundColor = Colors.calUnSelectColor
        self.leftButton2.setTitleColor(Colors.calUnSelectTextColor, for: UIControlState.normal)
        
        self.leftButton3.backgroundColor = Colors.calUnSelectColor
        self.leftButton3.setTitleColor(Colors.calUnSelectTextColor, for: UIControlState.normal)
        
        self.leftButton4.backgroundColor = Colors.calUnSelectColor
        self.leftButton4.setTitleColor(Colors.calUnSelectTextColor, for: UIControlState.normal)
    }
    
    func changeStepButtonWithIndex(index: NSInteger) {
        resetStepButton()
        if (index == 0) {
            self.leftButton1.backgroundColor = Colors.calSelectedColor
            self.leftButton1.setTitleColor(Colors.calSelectedTextColor, for: UIControlState.normal)
        } else if (index == 1) {
            self.leftButton2.backgroundColor = Colors.calSelectedColor
            self.leftButton2.setTitleColor(Colors.calSelectedTextColor, for: UIControlState.normal)
        } else if (index == 2) {
            self.leftButton3.backgroundColor = Colors.calSelectedColor
            self.leftButton3.setTitleColor(Colors.calSelectedTextColor, for: UIControlState.normal)
        } else if (index == 3) {
            self.leftButton4.backgroundColor = Colors.calSelectedColor
            self.leftButton4.setTitleColor(Colors.calSelectedTextColor, for: UIControlState.normal)
        }
    }

}
