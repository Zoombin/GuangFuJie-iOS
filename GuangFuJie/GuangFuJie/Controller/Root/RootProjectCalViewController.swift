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
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lngLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var average30: UILabel!
    @IBOutlet weak var averagehor: UILabel!
    @IBOutlet weak var sampleAngle: UILabel!
    
    var currentLat: NSNumber?
    var currentLng: NSNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "项目测算"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func locationSetting() {
        let vc = ProviceCityViewController()
        vc.delegate = self
        
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func proviceAndCity(_ provice: ProvinceModel, city: CityModel, area: AreaModel) {
        locationButton.setTitle("\(StringUtils.getString(city.name))\(StringUtils.getString(area.name))", for: UIControlState.normal)
        
        latLabel.text = "纬度:\(StringUtils.getNumber(area.lat))"
        lngLabel.text = "经度:\(StringUtils.getNumber(area.lng))"
        currentLat = area.lat
        currentLng = area.lng
    }
    
    @IBAction func loadInstallerData() {
        if (currentLat == nil || currentLng == nil) {
            self.showHint("请先选择位置")
            return
        }
        self.showHud(in: self.view, hint: "获取数据中...")
        API.sharedInstance.projectcalSunenerge(currentLat!, lng: currentLng!, success: { (info) in
            self.hideHud()
            self.average30.text = "水平辐照总值:\(StringUtils.getNumber(info.average_30))Kwh/㎡"
            self.averagehor.text = "倾角辐照总值:\(StringUtils.getNumber(info.average_hor))Kwh/㎡"
            self.sampleAngle.text = "参考倾角:\(StringUtils.getNumber(info.sample_angle))度"
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bkgXZView.layer.shadowColor = UIColor.lightGray.cgColor
        bkgXZView.layer.shadowRadius = 5.0
        bkgXZView.layer.shadowOpacity = 0.8
        bkgXZView.layer.shadowOffset = CGSize(width: -5, height: 0)
        self.navigationController?.tabBarItem.selectedImage = self.tabBarItem.selectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
