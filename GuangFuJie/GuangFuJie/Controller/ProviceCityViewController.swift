//
//  ProviceCityViewController.swift
//  HeTianYu
//
//  Created by 颜超 on 16/4/12.
//  Copyright © 2016年 Zoombin. All rights reserved.
//

import UIKit

protocol ProviceCityViewDelegate : NSObjectProtocol {
    func proviceAndCity(provice : ProvinceModel, city : CityModel)
}

class ProviceCityViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate : ProviceCityViewDelegate?
    var tableView1 : UITableView!
    var tableView2 : UITableView!
    
    var infoArray1 : NSMutableArray = NSMutableArray()
    var infoArray2 : NSMutableArray = NSMutableArray()
    
    var currentProvice : ProvinceModel?
    var currentCity : CityModel?
    
    let cellReuseIdentifier1 = "TableViewCell1"
    let cellReuseIdentifier2 = "TableViewCell2"
    override func viewDidLoad() {
        super.viewDidLoad()
//        initTitle("选择城市")
        self.title = "选择城市"
        tableView1 = UITableView.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth / 2, PhoneUtils.kScreenHeight), style: UITableViewStyle.Plain)
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView1.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView1)
        
        tableView1.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier1)
        
        tableView2 = UITableView.init(frame: CGRectMake(PhoneUtils.kScreenWidth / 2, 64, PhoneUtils.kScreenWidth / 2, PhoneUtils.kScreenHeight - 64), style: UITableViewStyle.Plain)
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView2.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView2)
        
        tableView2.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier2)
        loadProviceList()
    }
    
    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func initLeftButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.close))
    }
    
    func loadProviceList() {
        API.sharedInstance.provincelist({ (provinces) in
            if (provinces.count > 0) {
                self.infoArray1.addObjectsFromArray(provinces as [AnyObject])
                self.tableView1.reloadData()
                self.currentProvice = self.infoArray1.firstObject as? ProvinceModel
                self.loadCityWithProvice(self.infoArray1.firstObject as! ProvinceModel)
            }
            }) { (msg) in
               self.showHint(msg)
        }
    }
    
    func loadCityWithProvice(province : ProvinceModel) {
        API.sharedInstance.citylist(province.province_id!, success: { (array) in
            self.infoArray2.removeAllObjects()
            if (array.count == 0) {
                let city = CityModel()
                city.city_id = 0
                city.city_label = province.province_label
                self.infoArray2.addObject(city)
            } else {
                self.infoArray2.addObjectsFromArray(array as [AnyObject])
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == tableView1) {
            return infoArray1.count
        } else {
            return infoArray2.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView == tableView1) {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier1, forIndexPath: indexPath)
            let province = infoArray1[indexPath.row] as! ProvinceModel
            cell.textLabel?.text = province.province_label
            cell.textLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier2, forIndexPath: indexPath)
            let city = infoArray2[indexPath.row] as! CityModel
            cell.textLabel?.text = city.city_label
            cell.textLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (tableView == tableView1) {
            currentCity = nil
            let provice = infoArray1[indexPath.row] as! ProvinceModel
            currentProvice = provice
            loadCityWithProvice(provice)
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
