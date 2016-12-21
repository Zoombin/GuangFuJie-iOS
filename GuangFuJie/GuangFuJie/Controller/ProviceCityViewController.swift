//
//  ProviceCityViewController.swift
//  HeTianYu
//
//  Created by 颜超 on 16/4/12.
//  Copyright © 2016年 Zoombin. All rights reserved.
//

import UIKit

protocol ProviceCityViewDelegate : NSObjectProtocol {
    func proviceAndCity(_ provice : ProvinceModel, city : CityModel)
}

class ProviceCityViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate : ProviceCityViewDelegate?
    var tableView1 : UITableView!
    var tableView2 : UITableView!
    
    var infoArray1 : NSMutableArray = NSMutableArray()
    var infoArray2 : NSMutableArray = NSMutableArray()
    
    var currentProvice : ProvinceModel?
    var currentCity : CityModel?
    var hasAll = false
    
    let cellReuseIdentifier1 = "TableViewCell1"
    let cellReuseIdentifier2 = "TableViewCell2"
    override func viewDidLoad() {
        super.viewDidLoad()
//        initTitle("选择城市")
        self.title = "选择城市"
        tableView1 = UITableView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth / 2, height: PhoneUtils.kScreenHeight), style: UITableViewStyle.plain)
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView1.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView1)
        
        tableView1.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier1)
        
        tableView2 = UITableView.init(frame: CGRect(x: PhoneUtils.kScreenWidth / 2, y: 64, width: PhoneUtils.kScreenWidth / 2, height: PhoneUtils.kScreenHeight - 64), style: UITableViewStyle.plain)
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView2.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView2)
        
        tableView2.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier2)
        loadProviceList()
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initLeftButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.close))
    }
    
    func loadProviceList() {
        API.sharedInstance.provincelist({ (provinces) in
            if (provinces.count > 0) {
                if (self.hasAll) {
                    let allProvince = ProvinceModel()
                    allProvince.province_id = 0
                    allProvince.province_label = "所有区域"
                    self.infoArray1.add(allProvince)
                }
                
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
        if (currentProvice?.province_label == "所有区域") {
            return
        }
        API.sharedInstance.citylist(province.province_id!, success: { (array) in
            self.infoArray2.removeAllObjects()
            if (array.count == 0) {
                let city = CityModel()
                city.city_id = 0
                city.city_label = province.province_label
                if (self.hasAll) {
                    if (self.delegate != nil) {
                        self.delegate?.proviceAndCity(province, city: city)
                        self.close()
                    }
                }
                self.infoArray2.add(city)
            } else {
                self.infoArray2.addObjects(from: array as [AnyObject])
            }
            self.tableView2.reloadData()
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
        } else {
            return infoArray2.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == tableView1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier1, for: indexPath as IndexPath)
            let province = infoArray1[indexPath.row] as! ProvinceModel
            cell.textLabel?.text = province.province_label
            cell.textLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier2, for: indexPath as IndexPath)
            let city = infoArray2[indexPath.row] as! CityModel
            cell.textLabel?.text = city.city_label
            cell.textLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == tableView1) {
            currentCity = nil
            let province = infoArray1[indexPath.row] as! ProvinceModel
            currentProvice = province
            if (currentProvice?.province_label == "所有区域") {
                if (self.delegate != nil) {
                    let city = CityModel()
                    city.city_id = 0
                    city.city_label = province.province_label
                    self.delegate?.proviceAndCity(currentProvice!, city: city)
                    close()
                }
                return
            }
            loadCityWithProvice(province)
        } else {
            let city = infoArray2[indexPath.row] as! CityModel
            currentCity = city
            if (self.delegate != nil) {
                self.delegate?.proviceAndCity(currentProvice!, city: currentCity!)
                close()
            }
        }
    }
    
}
