//
//  MyFavViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/1/7.
//  Copyright © 2017年 颜超. All rights reserved.
//

import UIKit

class MyFavViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{
    var installerArray = NSMutableArray()
    var roofArray = NSMutableArray()
    
    var tableView : UITableView!
    
    let installerCellReuseIdentifier = "installerCellReuseIdentifier"
    let roofCellReuseIdentifier = "roofCellReuseIdentifier"
    
    var installerButton: UIButton!
    var roofButton: UIButton!
    let topButtonHeight = PhoneUtils.kScreenHeight / 15
    let dir: CGFloat = 5
    
    var currentType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的收藏"
        // Do any additional setup after loading the view.
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    func initView() {
        initTopView()
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 64 + topButtonHeight + dir, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - 64 - topButtonHeight - dir), style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Colors.bkgColor
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(tableView)
        
        tableView.register(YeZhuCell.self, forCellReuseIdentifier: installerCellReuseIdentifier)
        tableView.register(InstallerCell.self, forCellReuseIdentifier: roofCellReuseIdentifier)
    }
    
    func loadData() {
        self.showHud(in: self.view, hint: "加载中...")
        if (currentType == 0) {
            API.sharedInstance.myFavInstallers({ (totalCount, array) in
                self.hideHud()
                self.installerArray.removeAllObjects()
                if (array.count > 0) {
                    self.installerArray.addObjects(from: array as! [Any])
                }
                self.tableView.reloadData()
            }, failure: { (msg) in
                self.hideHud()
                self.showHint(msg)
            })
        } else if (currentType == 1) {
            API.sharedInstance.myFavRoofs({ (totalCount, array) in
                self.hideHud()
                self.roofArray.removeAllObjects()
                if (array.count > 0) {
                    self.roofArray.addObjects(from: array as! [Any])
                }
                self.tableView.reloadData()
            }, failure: { (msg) in
                self.hideHud()
                self.showHint(msg)
            })
        }
    }
    
    func initTopView() {
        let topView = UIView.init(frame: CGRect(x: 0, y: 64, width: PhoneUtils.kScreenWidth, height: topButtonHeight))
        topView.backgroundColor = UIColor.lightGray
        self.view.addSubview(topView)
        
        installerButton = UIButton.init(type: UIButtonType.custom)
        installerButton.setTitle("安装商", for: UIControlState.normal)
        installerButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        installerButton.backgroundColor = Colors.installColor
        installerButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        installerButton.frame = CGRect(x: 0, y: 0, width: (PhoneUtils.kScreenWidth / 2) - 1, height: topButtonHeight)
        installerButton.tag = 0
        topView.addSubview(installerButton)
        
        roofButton = UIButton.init(type: UIButtonType.custom)
        roofButton.setTitle("屋顶", for: UIControlState.normal)
        roofButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        roofButton.backgroundColor = Colors.topButtonColor
        roofButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        roofButton.frame = CGRect(x: (PhoneUtils.kScreenWidth / 2) + 1, y: 0, width: (PhoneUtils.kScreenWidth / 2) - 1, height: topButtonHeight)
        roofButton.tag = 1
        topView.addSubview(roofButton)
    }
    
    func topButtonClicked(_ button : UIButton) {
        currentType = button.tag
        loadData()
        
        installerButton.backgroundColor = Colors.topButtonColor
        roofButton.backgroundColor = Colors.topButtonColor
        if (currentType == 0) {
            installerButton.backgroundColor = Colors.installColor
        } else if (currentType == 1) {
            roofButton.backgroundColor = Colors.installColor
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (currentType == 0) {
            return installerArray.count
        }
        return roofArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (currentType == 0) {
            return YeZhuCell.cellHeight()
        }
        return InstallerCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (currentType == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: installerCellReuseIdentifier, for: indexPath as IndexPath) as! YeZhuCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none;
            cell.initCell()
            let userInfo = installerArray[indexPath.row] as! InstallInfo
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
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: roofCellReuseIdentifier, for: indexPath as IndexPath) as! InstallerCell
            cell.initCell()
            let userInfo = roofArray[indexPath.row] as! RoofInfo
            if ((userInfo.fullname) != nil) {
                cell.nameLabel.text = userInfo.fullname! + " " + "屋顶出租"
            }
            if ((userInfo.created_date) != nil) {
                cell.timeLabel.text = userInfo.created_date!
            }
            if (userInfo.area_image != nil) {
                cell.avatarImageView.setImageWith(URL.init(string: userInfo.area_image!)! as URL)
            } else {
                cell.avatarImageView.image = UIImage(named: "ic_avatar_yezhu")
            }
            var type = "屋顶类型:"
            var size = "屋顶面积:"
            var price = "屋顶租金:"
            if (userInfo.area_size != nil) {
                size = size + String(format: "%.2f", userInfo.area_size!.floatValue) + "㎡"
            }
            if (userInfo.type != nil) {
                type = type + (userInfo.type == 2 ? "斜面" : "平面")
            }
            if (userInfo.price != nil) {
                price = price + String(describing: userInfo.price!) + "元/㎡"
            }
            cell.roofTypeLabel.text = type
            cell.roofSizeLabel.text = size
            cell.roofPriceLabel.text = price
            
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
            cell.viewMoreButton.setTitle("点我接单", for: UIControlState.normal)
            cell.viewMoreButton.isUserInteractionEnabled = false
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if (shouldShowLogin()) {
            return
        }
        if (currentType == 0) {
            let userInfo = installerArray[indexPath.row] as! InstallInfo
            let vc = InstallerDetailOldViewController(nibName: "InstallerDetailOldViewController", bundle: nil)
            vc.installer_id = userInfo.user_id!
            self.pushViewController(vc)
        } else {
            let userInfo = roofArray[indexPath.row] as! RoofInfo
            let vc = InstallBuyViewController()
            vc.roofId = userInfo.id!
            self.pushViewController(vc)
        }
    }
    
}
