//
//  GFJRoofListViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/10.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class GFJRoofListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, ProviceCityViewDelegate {
    
    @IBOutlet weak var installTableView : UITableView!
    @IBOutlet weak var topView: UIView!
    
    var locationButton: UIButton!
    var sizeButton: UIButton!
    var typeButton: UIButton!
    
    var installerArray : NSMutableArray = NSMutableArray()
    var currentPage = 0
    
    var provinceInfo: ProvinceModel!
    var cityInfo: CityModel!
    
    var sizeView: UIView!
    var startTextField: UITextField!
    var endTextField: UITextField!
    
    var typeView: UIView!
    var imageView1: UIImageView!
    var imageView2: UIImageView!
    var imageView3: UIImageView!
    
    var roofTypeIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "业主出租"
        // Do any additional setup after loading the view.
        initLoginView()
        initView()
        initTopMenuButton()
        initSizeView()
        initTypeView()
        
        installTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.loadInstallerList))
        installTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMore))
        
        loadInstallerList()
    }
    
    func initSizeView() {
        sizeView = UIView.init(frame: CGRectMake(0, installTableView.frame.origin.y, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - 50 - 64))
        sizeView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        sizeView.hidden = true
        self.view.addSubview(sizeView)
        
        let bkgButton = UIButton.init(type: UIButtonType.Custom)
        bkgButton.frame = CGRectMake(0, 0, sizeView.frame.size.width, sizeView.frame.size.height)
        bkgButton.addTarget(self, action: #selector(self.hideSizeView), forControlEvents: UIControlEvents.TouchUpInside)
        sizeView.addSubview(bkgButton)
        
        let offSetX : CGFloat = 10
        let dir : CGFloat = 5
        let textFieldWidth = (PhoneUtils.kScreenWidth - offSetX * 3) / 2
        
        let bkgView = UIView.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, 50 + dir * 3))
        bkgView.backgroundColor = UIColor.whiteColor()
        sizeView.addSubview(bkgView)
        
        startTextField = UITextField.init(frame: CGRectMake(offSetX, dir, textFieldWidth, 25))
        startTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        startTextField.layer.borderWidth = 1
        startTextField.placeholder = "请输入最小面积"
        startTextField.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        startTextField.textAlignment = NSTextAlignment.Center
        bkgView.addSubview(startTextField)
        
        let toLabel = UILabel.init(frame: CGRectMake(offSetX + textFieldWidth, dir, offSetX, 30))
        toLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        toLabel.text = "~"
        toLabel.textAlignment = NSTextAlignment.Center
        sizeView.addSubview(toLabel)
        
        endTextField = UITextField.init(frame: CGRectMake((offSetX * 2) + textFieldWidth, dir, textFieldWidth, 25))
        endTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        endTextField.layer.borderWidth = 1
        endTextField.placeholder = "请输入最大面积"
        endTextField.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        endTextField.textAlignment = NSTextAlignment.Center
        bkgView.addSubview(endTextField)
        
        let buttonWidth = PhoneUtils.kScreenWidth / 3
        let buttonOffSet = buttonWidth / 3
        
        let clearButton = UIButton.init(frame: CGRectMake(buttonOffSet, CGRectGetMaxY(startTextField.frame) + dir, buttonWidth, 25))
        clearButton.setTitle("清除", forState: UIControlState.Normal)
        clearButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        clearButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        clearButton.addTarget(self, action: #selector(self.clearButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        clearButton.backgroundColor = Colors.installColor
        bkgView.addSubview(clearButton)
        
        let sureButton = UIButton.init(frame: CGRectMake((buttonOffSet * 2) + buttonWidth, CGRectGetMaxY(startTextField.frame) + dir, buttonWidth, 25))
        sureButton.setTitle("确定", forState: UIControlState.Normal)
        sureButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        sureButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        sureButton.addTarget(self, action: #selector(self.sureButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        sureButton.backgroundColor = Colors.installColor
        bkgView.addSubview(sureButton)
    }
    
    func clearButtonClicked() {
        hideAllKeyBoard()
        startTextField.text = ""
        endTextField.text = ""
        sizeButton.setTitle("屋顶面积", forState: UIControlState.Normal)
        
        sizeView.hidden = true
        loadInstallerList()
    }
    
    
    func hideAllKeyBoard() {
        startTextField.resignFirstResponder()
        endTextField.resignFirstResponder()
    }
    
    func sureButtonClicked() {
        hideAllKeyBoard()
        
        if (startTextField.text!.isEmpty) {
            self.showHint("请输入最小面积")
            return
        }
        if (endTextField.text!.isEmpty) {
             self.showHint("请输入最大面积")
            return
        }
        hideSizeView()
        
        sizeButton.setTitle("屋顶面积：" + startTextField.text! + "~" + endTextField.text!, forState: UIControlState.Normal)
        loadInstallerList()
    }
    
    func hideSizeView() {
        hideAllKeyBoard()
        sizeView.hidden = true
    }
    
    func hideTypeView() {
        hideAllKeyBoard()
        typeView.hidden = true
    }
    
    func initTypeView() {
        typeView = UIView.init(frame: CGRectMake(0, installTableView.frame.origin.y, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - 50 - 64))
        typeView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        typeView.hidden = true
        self.view.addSubview(typeView)
        
        let bkgButton = UIButton.init(type: UIButtonType.Custom)
        bkgButton.frame = CGRectMake(0, 0, typeView.frame.size.width, typeView.frame.size.height)
        bkgButton.addTarget(self, action: #selector(self.hideTypeView), forControlEvents: UIControlEvents.TouchUpInside)
        typeView.addSubview(bkgButton)
        
        let roofTypeView = UIView.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight / 4))
        roofTypeView.backgroundColor = UIColor.whiteColor()
        typeView.addSubview(roofTypeView)
        
        let offSet : CGFloat = 5
        let imageWidth = (PhoneUtils.kScreenWidth - offSet * 4) / 3
        let imageHeight = roofTypeView.frame.size.height - offSet * 2 - 20 - 35
        
        imageView1 = UIImageView.init(frame: CGRectMake(offSet, offSet, imageWidth, imageHeight))
        imageView1.image = UIImage(named: "ic_wuding_bies")
        imageView1.tag = 0
        imageView1.layer.borderColor = Colors.installColor.CGColor
        roofTypeView.addSubview(imageView1)
        
        let label1 = UILabel.init(frame: CGRectMake(imageView1.frame.origin.x, CGRectGetMaxY(imageView1.frame), imageWidth, 20))
        label1.text = "别墅"
        label1.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        label1.textAlignment = NSTextAlignment.Center
        roofTypeView.addSubview(label1)
        
        imageView2 = UIImageView.init(frame: CGRectMake(offSet * 2 + imageWidth, offSet, imageWidth, imageHeight))
        imageView2.image = UIImage(named: "ic_wuding_changf")
        imageView2.tag = 1
        imageView2.layer.borderColor = Colors.installColor.CGColor
        roofTypeView.addSubview(imageView2)
        
        let label2 = UILabel.init(frame: CGRectMake(imageView2.frame.origin.x, CGRectGetMaxY(imageView2.frame), imageWidth, 20))
        label2.text = "厂房"
        label2.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        label2.textAlignment = NSTextAlignment.Center
        roofTypeView.addSubview(label2)
        
        imageView3 = UIImageView.init(frame: CGRectMake(offSet * 3 + imageWidth * 2, offSet, imageWidth, imageHeight))
        imageView3.image = UIImage(named: "ic_wuding_nongc")
        imageView3.tag = 2
        imageView3.layer.borderColor = Colors.installColor.CGColor
        roofTypeView.addSubview(imageView3)
        
        let label3 = UILabel.init(frame: CGRectMake(imageView3.frame.origin.x, CGRectGetMaxY(imageView1.frame), imageWidth, 20))
        label3.text = "民房"
        label3.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        label3.textAlignment = NSTextAlignment.Center
        roofTypeView.addSubview(label3)
        
        let tapGesture1 = UITapGestureRecognizer.init(target: self, action: #selector(self.imageSelected(_:)))
        let tapGesture2 = UITapGestureRecognizer.init(target: self, action: #selector(self.imageSelected(_:)))
        let tapGesture3 = UITapGestureRecognizer.init(target: self, action: #selector(self.imageSelected(_:)))
        
        imageView1.userInteractionEnabled = true
        imageView2.userInteractionEnabled = true
        imageView3.userInteractionEnabled = true
        
        imageView1.addGestureRecognizer(tapGesture1)
        imageView2.addGestureRecognizer(tapGesture2)
        imageView3.addGestureRecognizer(tapGesture3)
        
        let clearButton = UIButton.init(frame: CGRectMake(0, CGRectGetMaxY(label1.frame) + 5, PhoneUtils.kScreenWidth, 35))
        clearButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        clearButton.layer.borderWidth = 0.5
        clearButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        clearButton.setTitle("清除所有选择", forState: UIControlState.Normal)
        clearButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        clearButton.addTarget(self, action: #selector(self.clearAllSelected), forControlEvents: UIControlEvents.TouchUpInside)
        roofTypeView.addSubview(clearButton)
    }
    
    func clearAllSelected() {
        imageView1.layer.borderWidth = 0
        imageView2.layer.borderWidth = 0
        imageView3.layer.borderWidth = 0
        
        roofTypeIndex = 0
        typeButton.setTitle("屋顶类型", forState: UIControlState.Normal)
        
        hideTypeView()
        loadInstallerList()
    }
    
    func imageSelected(gesture : UITapGestureRecognizer) {
        let index = gesture.view!.tag
        imageView1.layer.borderWidth = 0
        imageView2.layer.borderWidth = 0
        imageView3.layer.borderWidth = 0
        if (index == 0) {
            imageView1.layer.borderWidth = 2
            typeButton.setTitle("屋顶类型：" + "别墅", forState: UIControlState.Normal)
            roofTypeIndex = 1
        } else if (index == 1) {
            imageView2.layer.borderWidth = 2
            typeButton.setTitle("屋顶类型：" + "厂房", forState: UIControlState.Normal)
            roofTypeIndex = 2
        } else if (index == 2) {
            imageView3.layer.borderWidth = 2
            typeButton.setTitle("屋顶类型：" + "民房", forState: UIControlState.Normal)
            roofTypeIndex = 3
        }
        
        hideTypeView()
        loadInstallerList()
    }
    
    func initTopMenuButton() {
        let buttonWidth = PhoneUtils.kScreenWidth / 3
        let buttonHeight = topView.frame.size.height
        
        locationButton = UIButton.init(type: UIButtonType.Custom)
        locationButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight)
        locationButton.setTitle("所有区域", forState: UIControlState.Normal)
        locationButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        locationButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        locationButton.tag = 0
        locationButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        locationButton.setImage(UIImage(named: "ic_arrow_down_black"), forState: UIControlState.Normal)
        topView.addSubview(locationButton)
        
        sizeButton = UIButton.init(type: UIButtonType.Custom)
        sizeButton.frame = CGRectMake(buttonWidth, 0, buttonWidth, buttonHeight)
        sizeButton.setTitle("屋顶面积", forState: UIControlState.Normal)
        sizeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        sizeButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        sizeButton.tag = 1
        sizeButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        sizeButton.setImage(UIImage(named: "ic_arrow_down_black"), forState: UIControlState.Normal)
        topView.addSubview(sizeButton)
        
        typeButton = UIButton.init(type: UIButtonType.Custom)
        typeButton.frame = CGRectMake(buttonWidth * 2, 0, buttonWidth, buttonHeight)
        typeButton.setTitle("屋顶类型", forState: UIControlState.Normal)
        typeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        typeButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        typeButton.tag = 2
        typeButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        typeButton.setImage(UIImage(named: "ic_arrow_down_black"), forState: UIControlState.Normal)
        topView.addSubview(typeButton)
    }
    
    func topButtonClicked(sender: UIButton) {
        sizeView.hidden = true
        typeView.hidden = true
        if (sender.tag == 0) {
            locationButtonClicked()
        } else if (sender.tag == 1) {
            sizeView.hidden = false
        } else {
            typeView.hidden = false
        }
    }
    
    func locationButtonClicked() {
        let vc = ProviceCityViewController()
        vc.delegate = self
        vc.hasAll = true
        let nav = UINavigationController.init(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func proviceAndCity(provice: ProvinceModel, city: CityModel) {
        provinceInfo = provice
        cityInfo = city
        var location = provinceInfo!.province_label! + " " + cityInfo!.city_label!
        if (provinceInfo!.province_label! == cityInfo!.city_label!) {
            location = provinceInfo!.province_label!
        }
        self.locationButton.setTitle(location, forState: UIControlState.Normal)
        
        loadInstallerList()
    }
    
    func loadMore() {
        currentPage = currentPage + 1
        var province_id = NSNumber.init(integer: 0)
        var city_id = NSNumber.init(integer: 0)
        if (provinceInfo != nil) {
            province_id = provinceInfo.province_id!
        }
        if (cityInfo != nil) {
            city_id = cityInfo.city_id!
        }
        let start = startTextField.text!
        let end = endTextField.text!
        
        API.sharedInstance.getRoofList(currentPage, pagesize: 10, status: 1, province_id: province_id, city_id: city_id, min_area_size: start, max_area_size: end, type: roofTypeIndex, success: { (userInfos) in
            self.installTableView.mj_footer.endRefreshing()
            if (userInfos.count > 0) {
                self.installerArray.addObjectsFromArray(userInfos as [AnyObject])
            }
            if (userInfos.count < 10) {
                self.installTableView.mj_footer.hidden = true
            }
            self.installTableView.reloadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    //MARK: 安装商列表
    func loadInstallerList() {
        currentPage = 0
        self.installTableView.mj_footer.hidden = false
        self.showHudInView(self.view, hint: "加载中...")
        
        var province_id = NSNumber.init(integer: 0)
        var city_id = NSNumber.init(integer: 0)
        if (provinceInfo != nil) {
            province_id = provinceInfo.province_id!
        }
        if (cityInfo != nil) {
            city_id = cityInfo.city_id!
        }
        let start = startTextField.text!
        let end = endTextField.text!
        
        API.sharedInstance.getRoofList(currentPage, pagesize: 10, status: 1, province_id: province_id, city_id: city_id, min_area_size: start, max_area_size: end, type: roofTypeIndex, success: { (userInfos) in
            self.installTableView.mj_header.endRefreshing()
            self.hideHud()
            self.installerArray.removeAllObjects()
            if (userInfos.count > 0) {
                self.installerArray.addObjectsFromArray(userInfos as [AnyObject])
            }
            if (userInfos.count < 10) {
                self.installTableView.mj_footer.hidden = true
            }
            self.installTableView.reloadData()
        }) { (msg) in
            self.installTableView.mj_header.endRefreshing()
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    let installerCellReuseIdentifier = "installerCellReuseIdentifier"
    func initView() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "附近屋顶", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.nearByRoof))
        
        installTableView.registerClass(InstallerCell.self, forCellReuseIdentifier: installerCellReuseIdentifier)
    }
    
    func nearByRoof() {
        let vc = NearByRoofViewController()
        self.pushViewController(vc)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return installerArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return InstallerCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(installerCellReuseIdentifier, forIndexPath: indexPath) as! InstallerCell
        cell.initCell()
        let userInfo = installerArray[indexPath.row] as! RoofInfo
        if ((userInfo.fullname) != nil) {
            cell.nameLabel.text = userInfo.fullname! + " " + "屋顶出租"
        }
        if ((userInfo.created_date) != nil) {
            cell.timeLabel.text = userInfo.created_date!
        }
        if (userInfo.area_image != nil) {
            cell.avatarImageView.setImageWithURL(NSURL.init(string: userInfo.area_image!)!)
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
            price = price + String(userInfo.price!) + "元/㎡"
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
        cell.viewMoreButton.setTitle("点我接单", forState: UIControlState.Normal)
        cell.viewMoreButton.userInteractionEnabled = false
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (shouldShowLogin()) {
            return
        }
        let userInfo = installerArray[indexPath.row] as! RoofInfo
        let vc = InstallBuyViewController()
        vc.roofId = userInfo.id!
        self.pushViewController(vc)
    }
}
