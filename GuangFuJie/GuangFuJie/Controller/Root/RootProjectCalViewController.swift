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
    
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lngLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var average30: UILabel!
    @IBOutlet weak var averagehor: UILabel!
    
    @IBOutlet weak var roofSizeTextField: UITextField!
    @IBOutlet weak var roofTypeButton: UIButton!
    
    //产能计算
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
    
    
    var projectCalInfo: ProjectcalInfo?
    var energyCalInfo: EnergycalInfo?
    
    var currentLat: NSNumber?
    var currentLng: NSNumber?
    
    @IBOutlet weak var step1Button: UIButton!
    @IBOutlet weak var step2Button: UIButton!
    @IBOutlet weak var step3Button: UIButton!
//    @IBOutlet weak var step1Button: UIButton!
    
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
        } else {
            if (energyCalInfo == nil) {
                self.showHint("请先计算产能计算数据")
                return
            }
            hideAllView()
            self.bkgSYView.isHidden = false
            changeStepButtonWithIndex(index: 2)
        }
    }
    
    func hideAllView() {
        self.bkgXZView.isHidden = true
        self.bkgCNView.isHidden = true
        self.bkgSYView.isHidden = true
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
        locationButton.setTitle("\(StringUtils.getString(city.name))\(StringUtils.getString(area.name))", for: UIControlState.normal)
        
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
            self.average30.text = "年日照时数:\(StringUtils.getNumber(info.sunlight_year)) 小时"
            self.averagehor.text = "年辐照总量:\(StringUtils.getNumber(info.energy_year)) Kwh/㎡.年"
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
            self.buildSize.text = "\(StringUtils.getNumber(info.build_size))Kwp"
            self.buildPrice.text = "\(StringUtils.getNumber(info.build_price))万元"
            self.electricFirstyearHours.text = "\(StringUtils.getNumber(info.electric_firstyear_hours))小时"
            self.electricFirstyearDayaverage.text = "\(StringUtils.getNumber(info.electric_firstyear_dayaverage))度"
            self.electricFirstyearTotal.text = "\(StringUtils.getNumber(info.electric_firstyear_total))度"
            self.electric25.text = "\(StringUtils.getNumber(info.electric_25))度"
            self.reduceC.text = "\(StringUtils.getNumber(info.reduce_c))千克"
            self.reduceCo2.text = "\(StringUtils.getNumber(info.reduce_co2))千克"
            self.reduceSo2.text = "\(StringUtils.getNumber(info.reduce_so2))千克"
            self.reduceNox.text = "\(StringUtils.getNumber(info.reduce_nox))千克"
            self.reduceSmoke.text = "\(StringUtils.getNumber(info.reduce_smoke))千克"
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    func addBkgViewShadow(view: UIView) {
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: -5, height: 0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addBkgViewShadow(view: bkgXZView)
        addBkgViewShadow(view: bkgCNView)
        addBkgViewShadow(view: bkgSYView)
        
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
        let type1Action = UIAlertAction.init(title: "水平铺设", style: UIAlertActionStyle.default) { (action) in
            self.roofTypeButton.setTitle("水平铺设", for: UIControlState.normal)
            self.type = 1
        }
        let type2Action = UIAlertAction.init(title: "倾角铺设", style: UIAlertActionStyle.default) { (action) in
            self.roofTypeButton.setTitle("倾角铺设", for: UIControlState.normal)
            self.type = 2
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
