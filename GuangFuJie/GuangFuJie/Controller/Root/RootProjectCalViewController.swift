//
//  RootProjectCalViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/14.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootProjectCalViewController: BaseViewController, ProviceCityViewDelegate {
    @IBOutlet weak var bkgXZView: UIView!
    @IBOutlet weak var bkgCNView: UIView!
    @IBOutlet weak var bkgSYView: UIView!
    @IBOutlet weak var bkgXJLView: UIView!
    
    //日照计算
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lngLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var average30: UILabel!
    @IBOutlet weak var averagehor: UILabel!
    
    //产能计算
    @IBOutlet weak var roofSizeTextField: UITextField!
    @IBOutlet weak var roofTypeButton: UIButton!
    
    @IBOutlet weak var buildSize: UILabel! //装机容量
    @IBOutlet weak var buildPrice: UILabel! //装机费用
    @IBOutlet weak var electricFirstyearHours: UILabel! //首年利用小时数
    @IBOutlet weak var electricFirstyearDayaverage: UILabel! //首年日发电量
    @IBOutlet weak var electricFirstyearTotal: UILabel! //首年总发电量
    @IBOutlet weak var electric25: UILabel! //25年总发电量
    @IBOutlet weak var reduceC: UILabel! //节约煤
    @IBOutlet weak var reduceCo2: UILabel! //减少二氧化碳
    @IBOutlet weak var reduceSo2: UILabel! //减少二氧化硫
    @IBOutlet weak var reduceNox: UILabel! //减少氮化物排放
    @IBOutlet weak var reduceSmoke: UILabel! //减少烟雾排行
    
    //收益分析
    @IBOutlet weak var tzjeLabel: UILabel! //投资金额
    @IBOutlet weak var khsldzjTextField: UITextField! //可回收流动资金
    @IBOutlet weak var ywcbTextField: UITextField! //运维成本
    @IBOutlet weak var zjbtTextField: UITextField! //装机补贴
    @IBOutlet weak var dkblTextField: UITextField! //贷款比例
    @IBOutlet weak var dknxTextField: UITextField! //贷款年限
    @IBOutlet weak var fullButton: UIButton! //全额上网
    @IBOutlet weak var leftButton: UIButton! //余电上网
    @IBOutlet weak var zydblTextField: UITextField! //自用电比例
    @IBOutlet weak var zyddjTextField: UITextField! //自用电电价
    @IBOutlet weak var ydbtTextField: UITextField! //用电补贴
    @IBOutlet weak var ydbtnxTextField: UITextField! //用电补贴年限
    @IBOutlet weak var ydswjTextField: UITextField! //余电上网价
    
    //现金流向
    @IBOutlet weak var xjtzjeLabel: UILabel! //现金流向投资金额
    @IBOutlet weak var zjrlLabel: UILabel! //装机容量
    @IBOutlet weak var dkLabel: UILabel! //贷款金额
    @IBOutlet weak var hkfsButton: UIButton! //还款方式
    @IBOutlet weak var dkllTextField: UITextField! //贷款利率
    @IBOutlet weak var dkbTextField: UITextField! //贷款倍率
    
    var loanType = 1 //还款方式
    
    var projectCalInfo: ProjectcalInfo?
    var energyCalInfo: EnergycalInfo?
    
    var currentLat: NSNumber?
    var currentLng: NSNumber?
    
    @IBOutlet weak var step1Button: UIButton!
    @IBOutlet weak var step2Button: UIButton!
    @IBOutlet weak var step3Button: UIButton!
    @IBOutlet weak var step4Button: UIButton!
    
    var type = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "项目测算"
        // Do any additional setup after loading the view.
    }
    
    func resetStepButton() {
        self.step1Button.backgroundColor = Colors.calUnSelectColor
        self.step1Button.setTitleColor(Colors.calUnSelectTextColor, for: UIControlState.normal)
        
        self.step2Button.backgroundColor = Colors.calUnSelectColor
        self.step2Button.setTitleColor(Colors.calUnSelectTextColor, for: UIControlState.normal)
        
        self.step3Button.backgroundColor = Colors.calUnSelectColor
        self.step3Button.setTitleColor(Colors.calUnSelectTextColor, for: UIControlState.normal)
        
        self.step4Button.backgroundColor = Colors.calUnSelectColor
        self.step4Button.setTitleColor(Colors.calUnSelectTextColor, for: UIControlState.normal)
    }
    
    func changeStepButtonWithIndex(index: NSInteger) {
        resetStepButton()
        if (index == 0) {
            self.step1Button.backgroundColor = Colors.calSelectedColor
            self.step1Button.setTitleColor(Colors.calSelectedTextColor, for: UIControlState.normal)
        } else if (index == 1) {
            self.step2Button.backgroundColor = Colors.calSelectedColor
            self.step2Button.setTitleColor(Colors.calSelectedTextColor, for: UIControlState.normal)
        } else if (index == 2) {
            self.step3Button.backgroundColor = Colors.calSelectedColor
            self.step3Button.setTitleColor(Colors.calSelectedTextColor, for: UIControlState.normal)
        } else if (index == 3) {
            self.step4Button.backgroundColor = Colors.calSelectedColor
            self.step4Button.setTitleColor(Colors.calSelectedTextColor, for: UIControlState.normal)
        }
    }
    
    @IBAction func leftStepButtonClicked(_ sender: UIButton) {
        if (sender.tag == 0) {
            hideAllView()
            self.bkgXZView.isHidden = false
            changeStepButtonWithIndex(index: 0)
        } else if (sender.tag == 1) {
            if (projectCalInfo == nil) {
                self.showHint("请先计算项目选址数据")
                return
            }
            hideAllView()
            self.bkgCNView.isHidden = false
            changeStepButtonWithIndex(index: 1)
        } else if (sender.tag == 2) {
            if (energyCalInfo == nil) {
                self.showHint("请先计算产能计算数据")
                return
            }
            hideAllView()
            self.bkgSYView.isHidden = false
            changeStepButtonWithIndex(index: 2)
            getSYParams()
        } else {
            if (projectCalInfo == nil) {
                self.showHint("请先计算项目选址数据")
                return
            }
            if (energyCalInfo == nil) {
                self.showHint("请先计算产能计算数据")
                return
            }
            hideAllView()
            self.bkgXJLView.isHidden = false
            changeStepButtonWithIndex(index: 3)
        }
    }
    
    func hideAllView() {
        self.bkgXZView.isHidden = true
        self.bkgCNView.isHidden = true
        self.bkgSYView.isHidden = true
        self.bkgXJLView.isHidden = true
    }
    
    @IBAction func nextStep() {
        if (bkgXZView.isHidden == false) {
            if (projectCalInfo == nil) {
                self.showHint("请先计算项目选址数据")
                return
            }
            hideAllView()
            self.bkgCNView.isHidden = false
            changeStepButtonWithIndex(index: 1)                                
        } else if (bkgCNView.isHidden == false) {
            if (energyCalInfo == nil) {
                self.showHint("请先计算产能计算数据")
                return
            }
            hideAllView()
            self.bkgSYView.isHidden = false
            changeStepButtonWithIndex(index: 2)
            getSYParams()
        } else if (bkgSYView.isHidden == false) {
            if (projectCalInfo == nil) {
                self.showHint("请先计算项目选址数据")
                return
            }
            if (energyCalInfo == nil) {
                self.showHint("请先计算产能计算数据")
                return
            }
            hideAllView()
            self.bkgXJLView.isHidden = false
            changeStepButtonWithIndex(index: 3)
        }
    }
    
    //位置选择
    @IBAction func locationSetting() {
        let vc = ProviceCityViewController()
        vc.delegate = self
        
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    //位置选择Delegate方法
    func proviceAndCity(_ provice: ProvinceModel, city: CityModel, area: AreaModel) {
        locationButton.setTitle("\(StringUtils.getString(provice.name))\(StringUtils.getString(city.name))\(StringUtils.getString(area.name))", for: UIControlState.normal)
        
        latLabel.text = String(format: "纬度:%.2f", StringUtils.getNumber(area.lat).floatValue)
        lngLabel.text = String(format: "经度:%.2f", StringUtils.getNumber(area.lng).floatValue)
        currentLat = area.lat
        currentLng = area.lng
    }
    
    //项目选址
    @IBAction func loadInstallerData() {
        if (currentLat == nil || currentLng == nil) {
            self.showHint("请先选择位置")
            return
        }
        self.showHud(in: self.view, hint: "获取数据中...")
        API.sharedInstance.projectcalSunenerge(currentLat!, lng: currentLng!, success: { (info) in
            self.projectCalInfo = info
            self.hideHud()
            self.averagehor.text = "年日照时数:\(StringUtils.getNumber(info.sunlight_year)) 小时"
            self.average30.text = "年辐照总量:\(StringUtils.getNumber(info.energy_year)) Kwh/㎡.年"
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    //产能计算
    @IBAction func loadCNData() {
        if (StringUtils.isEmpty(roofSizeTextField.text!)) {
            self.showHint("请输入屋顶面积")
            return
        }
        if (type == 0) {
            self.showHint("请选择安装方式")
            return
        }
        self.showHud(in: self.view, hint: "获取数据中...")
        API.sharedInstance.projectcalEnergycal(type: type, size: roofSizeTextField.text!, lat: currentLat!, lng: currentLng!, success: { (info) in
            self.hideHud()
            self.energyCalInfo = info
            self.buildSize.text = "装机容量：\(StringUtils.getNumber(info.build_size))Kwp"
            self.buildPrice.text = "建设费用：\(StringUtils.getNumber(info.build_price))万元"
            self.electricFirstyearHours.text = "首年发电利用小时数：\(StringUtils.getNumber(info.electric_firstyear_hours))小时"
            self.electricFirstyearDayaverage.text = "首年日发电量：\(StringUtils.getNumber(info.electric_firstyear_dayaverage))度"
            self.electricFirstyearTotal.text = "首年总发电量：\(StringUtils.getNumber(info.electric_firstyear_total))度"
            self.electric25.text = "25年总发电量：\(StringUtils.getNumber(info.electric_25))度"
            self.reduceC.text = "节约标准煤：\(StringUtils.getNumber(info.reduce_c))千克"
            self.reduceCo2.text = "减少CO₂排放：\(StringUtils.getNumber(info.reduce_co2))千克"
            self.reduceSo2.text = "减少SO₂排放：\(StringUtils.getNumber(info.reduce_so2))千克"
            self.reduceNox.text = "减少NOx排放：\(StringUtils.getNumber(info.reduce_nox))千克"
            self.reduceSmoke.text = "减少烟雾排放：\(StringUtils.getNumber(info.reduce_smoke))千克"
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    //获取收益分析的参数
    func getSYParams() {
        API.sharedInstance.getCityFromLatlng(lat: currentLat!, lng: currentLng!, success: { (locationInfo) in
            API.sharedInstance.incomecalParams(lat: self.currentLat!, lng: self.currentLng!, province: locationInfo.province_id!, city: locationInfo.city_id!, area: locationInfo.area_id!, type: NSNumber.init(value: self.type), size: self.roofSizeTextField.text!, onlineType: self.fullButton.isSelected == true ? 1 : 2, success: { (params) in
                self.inputSYValues(params: params)
            }) { (msg) in
                self.showHint(msg)
            }
        }) { (msg) in
            self.showHint(msg)
        }
    }
    
    func inputSYValues(params: IncomeCalParams) {
        tzjeLabel.text = "\(StringUtils.getNumber(energyCalInfo!.build_price))"
        if (khsldzjTextField.text!.isEmpty) {
            khsldzjTextField.text = String(format: "%.2f", StringUtils.getNumber(energyCalInfo!.build_price).floatValue * 0.05)
        }
        if (ywcbTextField.text!.isEmpty) {
            ywcbTextField.text = "\(StringUtils.getNumber(params.annual_maintenance_cost))"
        }
        if (zjbtTextField.text!.isEmpty) {
            zjbtTextField.text = "\(StringUtils.getNumber(params.installed_subsidy))"
        }
        if (dkblTextField.text!.isEmpty) {
            dkblTextField.text = "\(StringUtils.getNumber(params.loan_ratio))"
            dknxTextField.text = "\(StringUtils.getNumber(params.years_of_loans))"
        }
        zydblTextField.text = "\(StringUtils.getNumber(params.occupied_electric_ratio))"
        zyddjTextField.text = "\(StringUtils.getNumber(params.electric_price_perional))"
        ydbtTextField.text = "\(StringUtils.getNumber(params.electricity_subsidy))"
        ydbtnxTextField.text = "\(StringUtils.getNumber(params.electricity_subsidy_year))"
        ydswjTextField.text = "\(StringUtils.getNumber(params.sparetime_electric_price))"
    }
    
    func inputXMCSValues() {
//        @IBOutlet weak var xjtzjeLabel: UILabel! //现金流向投资金额
//        @IBOutlet weak var zjrlLabel: UILabel! //装机容量
//        @IBOutlet weak var dkLabel: UILabel! //贷款金额
//        @IBOutlet weak var hkfsButton: UIButton! //还款方式
//        @IBOutlet weak var dkllTextField: UITextField! //贷款利率
//        @IBOutlet weak var dkbTextField: UITextField! //贷款倍率
        dkllTextField.text = "4.9"
        dkbTextField.text = "1.0"
    }
    
    @IBAction func calSYButtonClicked() {
        let tmpParams = CalResultParams()
        tmpParams.address = locationButton.titleLabel?.text!
        tmpParams.type = NSNumber.init(value: type)
        tmpParams.size = roofSizeTextField.text!
        tmpParams.invest_amount = energyCalInfo!.build_price
        let ywcbPercent = NSString.init(string: ywcbTextField.text!)
        let ywcbValue = ywcbPercent.floatValue * energyCalInfo!.build_price!.floatValue
        
        tmpParams.annual_maintenance_cost = String(format: "%.2f%", ywcbValue)
        tmpParams.recoverable_liquid_capital = String(format: "%.2f", StringUtils.getNumber(energyCalInfo!.build_price).floatValue * 0.05)
        tmpParams.installed_subsidy = zjbtTextField.text!
        tmpParams.loan_ratio = dkblTextField.text!
        tmpParams.years_of_loans = dknxTextField.text!
        tmpParams.occupied_electric_ratio = zydblTextField.text!
        tmpParams.electric_price_perional = zyddjTextField.text!
        tmpParams.electricity_subsidy = ydbtTextField.text!
        tmpParams.electricity_subsidy_year = ydbtnxTextField.text!
        tmpParams.sparetime_electric_price = ydswjTextField.text!
        tmpParams.wOfPrice = "8"
        tmpParams.firstYearKwElectric = "4"
        
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
    
    func addBkgViewShadow(view: UIView) {
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: -5, height: 0)
    }
    
    func resetAllCheckBox() {
        fullButton.isSelected = false //全额
        leftButton.isSelected = false //余电
    }
    
   @IBAction func checkBoxButtonClicked(_ sender: UIButton) {
        resetAllCheckBox()
        if (sender.tag == 0) {
            sender.isSelected = true
        } else if (sender.tag == 1) {
            sender.isSelected = true
        }
        getSYParams()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bkgXZView.layer.borderColor = UIColor.black.cgColor
        bkgXZView.layer.borderWidth = 0.5
        
        bkgCNView.layer.borderColor = UIColor.black.cgColor
        bkgCNView.layer.borderWidth = 0.5
        
        bkgSYView.layer.borderColor = UIColor.black.cgColor
        bkgSYView.layer.borderWidth = 0.5
        
        bkgXJLView.layer.borderColor = UIColor.black.cgColor
        bkgXJLView.layer.borderWidth = 0.5
        
        self.navigationController?.tabBarItem.selectedImage = self.tabBarItem.selectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        roofSizeTextField.layer.borderColor = UIColor.lightGray.cgColor
        roofSizeTextField.layer.borderWidth = 0.5
        roofSizeTextField.layer.cornerRadius = 6.0
        roofSizeTextField.layer.masksToBounds = true
        
        roofTypeButton.layer.borderColor = UIColor.lightGray.cgColor
        roofTypeButton.layer.borderWidth = 0.5
        roofTypeButton.layer.cornerRadius = 6.0
        roofTypeButton.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showTypeAction() {
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
    
    @IBAction func showLoanTypeAction() {
        let vc = UIAlertController.init(title: "选择还款方式", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        let type1Action = UIAlertAction.init(title: "等额本息", style: UIAlertActionStyle.default) { (action) in
            self.hkfsButton.setTitle("等额本息", for: UIControlState.normal)
            self.loanType = 1
        }
        let type2Action = UIAlertAction.init(title: "等额本金", style: UIAlertActionStyle.default) { (action) in
            self.hkfsButton.setTitle("等额本金", for: UIControlState.normal)
            self.loanType = 2
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        vc.addAction(type1Action)
        vc.addAction(type2Action)
        vc.addAction(cancelAction)
        self.present(vc, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
