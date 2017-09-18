//
//  ProviceCityViewController.swift
//  HeTianYu
//
//  Created by 颜超 on 16/4/12.
//  Copyright © 2016年 Zoombin. All rights reserved.
//

import UIKit

protocol ProviceCityViewDelegate : NSObjectProtocol {
    func proviceAndCity(_ provice : ProvinceModel, city : CityModel, area : AreaModel)
}

class ProviceCityViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate : ProviceCityViewDelegate?
    var tableView1 : UITableView!
    var tableView2 : UITableView!
    var tableView3 : UITableView!
    
    var infoArray1 : NSMutableArray = NSMutableArray()
    var infoArray2 : NSMutableArray = NSMutableArray()
    var infoArray3 : NSMutableArray = NSMutableArray()
    
    var currentProvice : ProvinceModel?
    var currentCity : CityModel?
    var currentArea : AreaModel?
    var hasAll = false
    
    let cellReuseIdentifier1 = "TableViewCell1"
    let cellReuseIdentifier2 = "TableViewCell2"
    let cellReuseIdentifier3 = "TableViewCell3"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择城市"
        tableView1 = UITableView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth / 3, height: PhoneUtils.kScreenHeight), style: UITableViewStyle.plain)
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView1.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView1)
        tableView1.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier1)
        
        tableView2 = UITableView.init(frame: CGRect(x: PhoneUtils.kScreenWidth / 3, y: 64, width: PhoneUtils.kScreenWidth / 3, height: PhoneUtils.kScreenHeight - 64), style: UITableViewStyle.plain)
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView2.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView2)
        tableView2.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier2)
        
        tableView3 = UITableView.init(frame: CGRect(x: PhoneUtils.kScreenWidth * 2 / 3, y: 64, width: PhoneUtils.kScreenWidth / 3, height: PhoneUtils.kScreenHeight - 64), style: UITableViewStyle.plain)
        tableView3.delegate = self
        tableView3.dataSource = self
        tableView3.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView3)
        tableView3.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier3)
        
        loadProviceList()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.close))
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadProviceList() {
        API.sharedInstance.provincelistV2({ (provinces) in
            if (provinces.count > 0) {
                self.infoArray1.addObjects(from: provinces as [AnyObject])
                self.tableView1.reloadData()
                self.currentProvice = self.infoArray1.firstObject as? ProvinceModel
                self.loadCityWithProvice(self.infoArray1.firstObject as! ProvinceModel)
            }
        }) { (msg) in
            self.showHint(msg)
        }
    }
    
    func loadCityWithProvice(_ province : ProvinceModel) {
        API.sharedInstance.citylistV2(province.province_id!, success: { (array) in
            self.infoArray2.removeAllObjects()
            if (array.count == 0) {
                let city = CityModel()
                city.city_id = 0
                city.name = province.name
                self.infoArray2.add(city)
            } else {
                self.infoArray2.addObjects(from: array as [AnyObject])
                self.loadAreaWithCity(self.infoArray2.firstObject as! CityModel, province: self.currentProvice!)
            }
            self.currentCity = self.infoArray2.firstObject as? CityModel
            self.tableView2.reloadData()
        }) { (error) in
            self.showHint(error)
        }
    }
    
    func loadAreaWithCity(_ city : CityModel, province : ProvinceModel) {
        API.sharedInstance.areaList(city.city_id!, success: { (array) in
            self.infoArray3.removeAllObjects()
            if (array.count == 0) {
                let area = AreaModel()
                area.area_id = 0
                area.name = city.name
                if (self.hasAll) {
                    if (self.delegate != nil) {
                        self.delegate?.proviceAndCity(province, city: city, area: area)
                        self.close()
                    }
                }
            } else {
                self.infoArray3.addObjects(from: array as [AnyObject])
            }
            self.currentArea = self.infoArray3.firstObject as? AreaModel
            self.tableView3.reloadData()
        }) { (error) in
            self.showHint(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == tableView1) {
            return infoArray1.count
        } else if (tableView == tableView2) {
            return infoArray2.count
        } else {
            return infoArray3.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == tableView1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier1, for: indexPath as IndexPath)
            let province = infoArray1[indexPath.row] as! ProvinceModel
            cell.textLabel?.text = province.name
            cell.textLabel?.font = UIFont.systemFont(ofSize: FontUtils.getFontSize(size: 15))
            return cell
        }  else if (tableView == tableView2){
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier2, for: indexPath as IndexPath)
            let city = infoArray2[indexPath.row] as! CityModel
            cell.textLabel?.text = city.name
            cell.textLabel?.font = UIFont.systemFont(ofSize: FontUtils.getFontSize(size: 15))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier3, for: indexPath as IndexPath)
            let area = infoArray3[indexPath.row] as! AreaModel
            cell.textLabel?.text = area.name
            cell.textLabel?.font = UIFont.systemFont(ofSize: FontUtils.getFontSize(size: 15))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == tableView1) {
            currentCity = nil
            let province = infoArray1[indexPath.row] as! ProvinceModel
            currentProvice = province
            loadCityWithProvice(province)
        } else if (tableView == tableView2) {
            currentArea = nil
            let city = infoArray2[indexPath.row] as! CityModel
            currentCity = city
            loadAreaWithCity(city, province: currentProvice!)
        } else {
            let area = infoArray3[indexPath.row] as! AreaModel
            currentArea = area
            if (self.delegate != nil) {
                self.delegate?.proviceAndCity(currentProvice!, city: currentCity!, area: area)
                close()
            }
        }
    }
    
}
