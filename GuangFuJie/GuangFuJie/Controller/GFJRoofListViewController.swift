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
        initView()
        initTopMenuButton()
        initSizeView()
        initTypeView()
        
        installTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.loadInstallerList))
        installTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMore))
        
        loadInstallerList()
    }
    
    func initSizeView() {
        sizeView = UIView.init(frame: CGRect(x: 0, y: installTableView.frame.origin.y, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - 50 - 64))
        sizeView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        sizeView.isHidden = true
        self.view.addSubview(sizeView)
        
        let bkgButton = UIButton.init(type: UIButtonType.custom)
        bkgButton.frame = CGRect(x: 0, y: 0, width: sizeView.frame.size.width, height: sizeView.frame.size.height)
        bkgButton.addTarget(self, action: #selector(self.hideSizeView), for: UIControlEvents.touchUpInside)
        sizeView.addSubview(bkgButton)
        
        let offSetX : CGFloat = 10
        let dir : CGFloat = 5
        let textFieldWidth = (PhoneUtils.kScreenWidth - offSetX * 3) / 2
        
        let bkgView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 50 + dir * 3))
        bkgView.backgroundColor = UIColor.white
        sizeView.addSubview(bkgView)
        
        startTextField = UITextField.init(frame: CGRect(x: offSetX, y: dir, width: textFieldWidth, height: 25))
        startTextField.layer.borderColor = UIColor.lightGray.cgColor
        startTextField.layer.borderWidth = 1
        startTextField.placeholder = "请输入最小面积"
        startTextField.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        startTextField.textAlignment = NSTextAlignment.center
        bkgView.addSubview(startTextField)
        
        let toLabel = UILabel.init(frame: CGRect(x: offSetX + textFieldWidth, y: dir, width: offSetX, height: 30))
        toLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        toLabel.text = "~"
        toLabel.textAlignment = NSTextAlignment.center
        sizeView.addSubview(toLabel)
        
        endTextField = UITextField.init(frame: CGRect(x: (offSetX * 2) + textFieldWidth, y: dir, width: textFieldWidth, height: 25))
        endTextField.layer.borderColor = UIColor.lightGray.cgColor
        endTextField.layer.borderWidth = 1
        endTextField.placeholder = "请输入最大面积"
        endTextField.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        endTextField.textAlignment = NSTextAlignment.center
        bkgView.addSubview(endTextField)
        
        let buttonWidth = PhoneUtils.kScreenWidth / 3
        let buttonOffSet = buttonWidth / 3
        
        let clearButton = UIButton.init(frame: CGRect(x: buttonOffSet, y: (startTextField.frame).maxY + dir, width: buttonWidth, height: 25))
        clearButton.setTitle("清除", for: UIControlState.normal)
        clearButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        clearButton.addTarget(self, action: #selector(self.clearButtonClicked), for: UIControlEvents.touchUpInside)
        clearButton.backgroundColor = Colors.installColor
        bkgView.addSubview(clearButton)
        
        let sureButton = UIButton.init(frame: CGRect(x: (buttonOffSet * 2) + buttonWidth, y: (startTextField.frame).maxY + dir, width: buttonWidth, height: 25))
        sureButton.setTitle("确定", for: UIControlState.normal)
        sureButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        sureButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        sureButton.addTarget(self, action: #selector(self.sureButtonClicked), for: UIControlEvents.touchUpInside)
        sureButton.backgroundColor = Colors.installColor
        bkgView.addSubview(sureButton)
    }
    
    func clearButtonClicked() {
        hideAllKeyBoard()
        startTextField.text = ""
        endTextField.text = ""
        sizeButton.setTitle("屋顶面积", for: UIControlState.normal)
        
        sizeView.isHidden = true
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
        
        sizeButton.setTitle("屋顶面积：" + startTextField.text! + "~" + endTextField.text!, for: UIControlState.normal)
        loadInstallerList()
    }
    
    func hideSizeView() {
        hideAllKeyBoard()
        sizeView.isHidden = true
    }
    
    func hideTypeView() {
        hideAllKeyBoard()
        typeView.isHidden = true
    }
    
    func initTypeView() {
        typeView = UIView.init(frame: CGRect(x: 0, y: installTableView.frame.origin.y, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - 50 - 64))
        typeView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        typeView.isHidden = true
        self.view.addSubview(typeView)
        
        let bkgButton = UIButton.init(type: UIButtonType.custom)
        bkgButton.frame = CGRect(x: 0, y: 0, width: typeView.frame.size.width, height: typeView.frame.size.height)
        bkgButton.addTarget(self, action: #selector(self.hideTypeView), for: UIControlEvents.touchUpInside)
        typeView.addSubview(bkgButton)
        
        let roofTypeView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight / 4))
        roofTypeView.backgroundColor = UIColor.white
        typeView.addSubview(roofTypeView)
        
        let offSet : CGFloat = 5
        let imageWidth = (PhoneUtils.kScreenWidth - offSet * 4) / 3
        let imageHeight = roofTypeView.frame.size.height - offSet * 2 - 20 - 35
        
        imageView1 = UIImageView.init(frame: CGRect(x: offSet, y: offSet, width: imageWidth, height: imageHeight))
        imageView1.image = UIImage(named: "ic_wuding_bies")
        imageView1.tag = 0
        imageView1.layer.borderColor = Colors.installColor.cgColor
        roofTypeView.addSubview(imageView1)
        
        let label1 = UILabel.init(frame: CGRect(x: imageView1.frame.origin.x, y: (imageView1.frame).maxY, width: imageWidth, height: 20))
        label1.text = "别墅"
        label1.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        label1.textAlignment = NSTextAlignment.center
        roofTypeView.addSubview(label1)
        
        imageView2 = UIImageView.init(frame: CGRect(x: offSet * 2 + imageWidth, y: offSet, width: imageWidth, height: imageHeight))
        imageView2.image = UIImage(named: "ic_wuding_changf")
        imageView2.tag = 1
        imageView2.layer.borderColor = Colors.installColor.cgColor
        roofTypeView.addSubview(imageView2)
        
        let label2 = UILabel.init(frame: CGRect(x: imageView2.frame.origin.x, y: (imageView2.frame).maxY, width: imageWidth, height: 20))
        label2.text = "厂房"
        label2.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        label2.textAlignment = NSTextAlignment.center
        roofTypeView.addSubview(label2)
        
        imageView3 = UIImageView.init(frame: CGRect(x: offSet * 3 + imageWidth * 2, y: offSet, width: imageWidth, height: imageHeight))
        imageView3.image = UIImage(named: "ic_wuding_nongc")
        imageView3.tag = 2
        imageView3.layer.borderColor = Colors.installColor.cgColor
        roofTypeView.addSubview(imageView3)
        
        let label3 = UILabel.init(frame: CGRect(x: imageView3.frame.origin.x, y: (imageView1.frame).maxY, width: imageWidth, height: 20))
        label3.text = "民房"
        label3.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        label3.textAlignment = NSTextAlignment.center
        roofTypeView.addSubview(label3)
        
        let tapGesture1 = UITapGestureRecognizer.init(target: self, action: #selector(self.imageSelected(_:)))
        let tapGesture2 = UITapGestureRecognizer.init(target: self, action: #selector(self.imageSelected(_:)))
        let tapGesture3 = UITapGestureRecognizer.init(target: self, action: #selector(self.imageSelected(_:)))
        
        imageView1.isUserInteractionEnabled = true
        imageView2.isUserInteractionEnabled = true
        imageView3.isUserInteractionEnabled = true
        
        imageView1.addGestureRecognizer(tapGesture1)
        imageView2.addGestureRecognizer(tapGesture2)
        imageView3.addGestureRecognizer(tapGesture3)
        
        let clearButton = UIButton.init(frame: CGRect(x: 0, y: (label1.frame).maxY + 5, width: PhoneUtils.kScreenWidth, height: 35))
        clearButton.layer.borderColor = UIColor.lightGray.cgColor
        clearButton.layer.borderWidth = 0.5
        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        clearButton.setTitle("清除所有选择", for: UIControlState.normal)
        clearButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        clearButton.addTarget(self, action: #selector(self.clearAllSelected), for: UIControlEvents.touchUpInside)
        roofTypeView.addSubview(clearButton)
    }
    
    func clearAllSelected() {
        imageView1.layer.borderWidth = 0
        imageView2.layer.borderWidth = 0
        imageView3.layer.borderWidth = 0
        
        roofTypeIndex = 0
        typeButton.setTitle("屋顶类型", for: UIControlState.normal)
        
        hideTypeView()
        loadInstallerList()
    }
    
    func imageSelected(_ gesture : UITapGestureRecognizer) {
        let index = gesture.view!.tag
        imageView1.layer.borderWidth = 0
        imageView2.layer.borderWidth = 0
        imageView3.layer.borderWidth = 0
        if (index == 0) {
            imageView1.layer.borderWidth = 2
            typeButton.setTitle("屋顶类型：" + "别墅", for: UIControlState.normal)
            roofTypeIndex = 1
        } else if (index == 1) {
            imageView2.layer.borderWidth = 2
            typeButton.setTitle("屋顶类型：" + "厂房", for: UIControlState.normal)
            roofTypeIndex = 2
        } else if (index == 2) {
            imageView3.layer.borderWidth = 2
            typeButton.setTitle("屋顶类型：" + "民房", for: UIControlState.normal)
            roofTypeIndex = 3
        }
        
        hideTypeView()
        loadInstallerList()
    }
    
    func initTopMenuButton() {
        let buttonWidth = PhoneUtils.kScreenWidth / 3
        let buttonHeight = topView.frame.size.height
        
        locationButton = UIButton.init(type: UIButtonType.custom)
        locationButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        locationButton.setTitle("所有区域", for: UIControlState.normal)
        locationButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        locationButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        locationButton.tag = 0
        locationButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        locationButton.setImage(UIImage(named: "ic_arrow_down_black"), for: UIControlState.normal)
        topView.addSubview(locationButton)
        
        sizeButton = UIButton.init(type: UIButtonType.custom)
        sizeButton.frame = CGRect(x: buttonWidth, y: 0, width: buttonWidth, height: buttonHeight)
        sizeButton.setTitle("屋顶面积", for: UIControlState.normal)
        sizeButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        sizeButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        sizeButton.tag = 1
        sizeButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        sizeButton.setImage(UIImage(named: "ic_arrow_down_black"), for: UIControlState.normal)
        topView.addSubview(sizeButton)
        
        typeButton = UIButton.init(type: UIButtonType.custom)
        typeButton.frame = CGRect(x: buttonWidth * 2, y: 0, width: buttonWidth, height: buttonHeight)
        typeButton.setTitle("屋顶类型", for: UIControlState.normal)
        typeButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        typeButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        typeButton.tag = 2
        typeButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        typeButton.setImage(UIImage(named: "ic_arrow_down_black"), for: UIControlState.normal)
        topView.addSubview(typeButton)
    }
    
    func topButtonClicked(_ sender: UIButton) {
        sizeView.isHidden = true
        typeView.isHidden = true
        if (sender.tag == 0) {
            locationButtonClicked()
        } else if (sender.tag == 1) {
            sizeView.isHidden = false
        } else {
            typeView.isHidden = false
        }
    }
    
    func locationButtonClicked() {
        let vc = ProviceCityViewController()
        vc.delegate = self
        vc.hasAll = true
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func proviceAndCity(_ provice: ProvinceModel, city: CityModel, area: AreaModel) {
        provinceInfo = provice
        cityInfo = city
        var location = provinceInfo!.name! + " " + cityInfo!.name!
        if (provinceInfo!.name! == cityInfo!.name!) {
            location = provinceInfo!.name!
        }
        self.locationButton.setTitle(location, for: UIControlState.normal)
        
        loadInstallerList()
    }
    
    func loadMore() {
        currentPage = currentPage + 1
        var province_id = NSNumber.init(value: 0)
        var city_id = NSNumber.init(value: 0)
        if (provinceInfo != nil) {
            province_id = provinceInfo.province_id!
        }
        if (cityInfo != nil) {
            city_id = cityInfo.city_id!
        }
        let start = startTextField.text!
        let end = endTextField.text!
        
        API.sharedInstance.getRoofList(currentPage, pagesize: 10, status: 1, province_id: province_id, city_id: city_id, min_area_size: start, max_area_size: end, type: roofTypeIndex as NSNumber?, success: { (userInfos) in
            self.installTableView.mj_footer.endRefreshing()
            if (userInfos.count > 0) {
                self.installerArray.addObjects(from: userInfos as [AnyObject])
            }
            if (userInfos.count < 10) {
                self.installTableView.mj_footer.isHidden = true
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
        self.installTableView.mj_footer.isHidden = false
        self.showHud(in: self.view, hint: "加载中...")
        
        var province_id = NSNumber.init(value: 0)
        var city_id = NSNumber.init(value: 0)
        if (provinceInfo != nil) {
            province_id = provinceInfo.province_id!
        }
        if (cityInfo != nil) {
            city_id = cityInfo.city_id!
        }
        let start = startTextField.text!
        let end = endTextField.text!
        
        API.sharedInstance.getRoofList(currentPage, pagesize: 10, status: 1, province_id: province_id, city_id: city_id, min_area_size: start, max_area_size: end, type: roofTypeIndex as NSNumber?, success: { (userInfos) in
            self.installTableView.mj_header.endRefreshing()
            self.hideHud()
            self.installerArray.removeAllObjects()
            if (userInfos.count > 0) {
                self.installerArray.addObjects(from: userInfos as [AnyObject])
            }
            if (userInfos.count < 10) {
                self.installTableView.mj_footer.isHidden = true
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "附近屋顶", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.nearByRoof))
        
        installTableView.register(InstallerCell.self, forCellReuseIdentifier: installerCellReuseIdentifier)
    }
    
    func nearByRoof() {
        let vc = NearByRoofViewController()
        self.pushViewController(vc)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return installerArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return InstallerCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: installerCellReuseIdentifier, for: indexPath as IndexPath) as! InstallerCell
        cell.initCell()
        let userInfo = installerArray[indexPath.row] as! RoofInfo
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if (shouldShowLogin()) {
            return
        }
        let userInfo = installerArray[indexPath.row] as! RoofInfo
        let vc = InstallBuyViewController()
        vc.roofId = userInfo.id!
        self.pushViewController(vc)
    }
}
