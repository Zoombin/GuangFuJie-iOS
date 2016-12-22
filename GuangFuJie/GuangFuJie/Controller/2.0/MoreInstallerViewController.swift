//
//  MoreInstallerViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/7.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class MoreInstallerViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, ProviceCityViewDelegate {
    @IBOutlet weak var yezhuTableView : UITableView!
    @IBOutlet weak var countLabel : UILabel!
    @IBOutlet weak var checkmarkButton : UIButton!
    @IBOutlet weak var locationButton : UIButton!
    
    var provinceInfo: ProvinceModel!
    var cityInfo: CityModel!
    
    var yezhuArray : NSMutableArray = NSMutableArray()
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安装商列表"
        // Do any additional setup after loading the view.
        initView()
        
        yezhuTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.loadUserList))
        yezhuTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMore))
        
        loadUserList()
    }
    
    @IBAction func locationButtonClicked(_ sender : UIButton) {
        let vc = ProviceCityViewController()
        vc.delegate = self
        vc.hasAll = true
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func proviceAndCity(_ provice: ProvinceModel, city: CityModel) {
        provinceInfo = provice
        cityInfo = city
        var location = provinceInfo!.province_label! + " " + cityInfo!.city_label!
        if (provinceInfo!.province_label! == cityInfo!.city_label!) {
            location = provinceInfo!.province_label!
        }
        self.locationButton.setTitle(location, for: UIControlState.normal)
        
        loadUserList()
    }
    
    @IBAction func checkmarkButtonClicked(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        loadUserList()
    }
    
    func loadMore() {
        let is_auth = checkmarkButton.isSelected ? 3 : 2
        currentPage = currentPage + 1
        var province_id = NSNumber.init(value: 0)
        var city_id = NSNumber.init(value: 0)
        if (provinceInfo != nil) {
            province_id = provinceInfo.province_id!
        }
        if (cityInfo != nil) {
            city_id = cityInfo.city_id!
        }
        API.sharedInstance.userlist(currentPage, pagesize: 10, type: 2, province_id: province_id, city_id: city_id, is_suggest: nil, is_auth: is_auth as NSNumber?, success: { (totalCount, userInfos) in
            self.yezhuTableView.mj_footer.endRefreshing()
            if (userInfos.count > 0) {
                self.yezhuArray.addObjects(from: userInfos as [AnyObject])
            }
            if (userInfos.count < 10) {
                self.yezhuTableView.mj_footer.isHidden = true
            }
            self.yezhuTableView.reloadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    func loadUserList() {
        currentPage = 0
        let is_auth = checkmarkButton.isSelected ? 3 : 2
        self.yezhuTableView.mj_footer.isHidden = false
        self.showHud(in: self.view, hint: "加载中...")
        var province_id = NSNumber.init(value: 0)
        var city_id = NSNumber.init(value: 0)
        if (provinceInfo != nil) {
            province_id = provinceInfo.province_id!
        }
        if (cityInfo != nil) {
            city_id = cityInfo.city_id!
        }
        API.sharedInstance.userlist(0, pagesize: 10, type: 2, province_id: province_id, city_id: city_id, is_suggest: nil, is_auth: is_auth as NSNumber?, success: { (totalCount, userInfos) in
            self.yezhuTableView.mj_header.endRefreshing()
            self.hideHud()
            self.yezhuArray.removeAllObjects()
            if (userInfos.count > 0) {
                self.yezhuArray.addObjects(from: userInfos as [AnyObject])
            }
            if (userInfos.count < 10) {
                self.yezhuTableView.mj_footer.isHidden = true
            }
            self.countLabel.text = "\(totalCount)家安装商为您服务"
            self.yezhuTableView.reloadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    let yezhuCellReuseIdentifier = "yezhuCellReuseIdentifier"
    func initView() {
        yezhuTableView.register(YeZhuCell.self, forCellReuseIdentifier: yezhuCellReuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yezhuArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return YeZhuCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: yezhuCellReuseIdentifier, for: indexPath as IndexPath) as! YeZhuCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        cell.initCell()
        let userInfo = yezhuArray[indexPath.row] as! InstallInfo
        if (userInfo.logo != nil) {
            cell.avatarImageView.setImageWith(URL.init(string: userInfo.logo!)! as URL, placeholderImage: UIImage(named: "ic_avatar_yezhu"))
        }
        cell.nameLabel.text = userInfo.company_name
        cell.descriptionLabel.text = userInfo.company_intro
        var location = ""
        if ((userInfo.province_label) != nil) {
            location = location + userInfo.province_label!
        }
        if ((userInfo.city_label) != nil) {
            location = location + userInfo.city_label!
        }
        if ((userInfo.address) != nil) {
            location = location + userInfo.address!
        }
        cell.addressLabel.text = location
        if (userInfo.is_installer == 2) {
            cell.statusLabel.text = "已认证"
            cell.statusLabel.textColor = Colors.installColor
        } else {
            cell.statusLabel.text = "未认证"
            cell.statusLabel.textColor = Colors.installRedColor
        }
        cell.viewMoreButton.setTitle("点我安装", for: UIControlState.normal)
        cell.viewMoreButton.isUserInteractionEnabled = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if (shouldShowLogin()) {
            return
        }
        let userInfo = yezhuArray[indexPath.row] as! InstallInfo
        let vc = InstallerDetailViewController()
        vc.installer_id = userInfo.user_id!
        self.pushViewController(vc)
    }
}
