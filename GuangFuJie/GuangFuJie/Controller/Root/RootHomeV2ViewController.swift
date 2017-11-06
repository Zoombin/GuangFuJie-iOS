//
//  RootHomeV2ViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/10/27.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootHomeV2ViewController: BaseViewController, UIScrollViewDelegate, UITextFieldDelegate, ProviceCityViewDelegate, UITableViewDelegate, UITableViewDataSource {
    var contentScroll: UIScrollView!
    
    var pageControl: UIPageControl!
    var bannerScrollView: UIScrollView!
    var menuView: UIView!
    var exampleView: UIView!
    var locationButton: UIButton!
    
    var bannerData = NSMutableArray()
    var exampleData = NSMutableArray()
    
    var installerArray = NSMutableArray() //业主
    var yezhuArray = NSMutableArray() //安装商
    
    var bottomTableView: UITableView!
    var currentIndex = 0
    
    var headerButton1: UIButton!
    var headerButton2: UIButton!
    var headerButton3: UIButton!
    var headerButton4: UIButton!
    var headerLine: UIView!
    
    let times = YCPhoneUtils.screenWidth / 375
    
    
    let installerCellReuseIdentifier = "installerCellReuseIdentifier" //业主 //TODO: 这里命名是反的
    let yezhuCellReuseIdentifier = "yezhuCellReuseIdentifier" //安装商
    let touziCellReuseIdentifier = "touziCellReuseIdentifier" //投资
    let gongqiuCellReuseIdentifier = "gongqiuCellReuseIdentifier" //供求
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
        
        contentScroll = UIScrollView.init(frame: CGRect(x: 0, y: self.navigationBarAndStatusBarHeight(), width: YCPhoneUtils.screenWidth, height: YCPhoneUtils.screenHeight - self.navigationBarAndStatusBarHeight()))
        contentScroll.backgroundColor = UIColor.white
        self.view.addSubview(contentScroll)
        
        initView()
        bottomTableView.register(HInstallerCell.self, forCellReuseIdentifier: installerCellReuseIdentifier)
        bottomTableView.register(HYeZhuCell.self, forCellReuseIdentifier: yezhuCellReuseIdentifier)
        bottomTableView.register(HInvestAndOfferCell.self, forCellReuseIdentifier: touziCellReuseIdentifier)
        bottomTableView.register(HInvestAndOfferCell.self, forCellReuseIdentifier: gongqiuCellReuseIdentifier)
        
        loadBannerData()
        loadExampleData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshLocation), name: NSNotification.Name(rawValue: "RefreshLocation"), object: nil)
        self.getCurrentLocation()
        
        loadInstallerList()
    }
    
    func refreshLocation() {
        if (UserDefaultManager.getLocation() != nil) {
            let location = UserDefaultManager.getLocation()
            locationButton.setTitle("\(YCStringUtils.getString(location!.city_name))\(YCStringUtils.getString(location!.area_name))", for: UIControlState.normal)
        }
    }
    
    func proviceAndCity(_ provice: ProvinceModel, city: CityModel, area: AreaModel) {
        locationButton.setTitle("\(YCStringUtils.getString(city.name))\(YCStringUtils.getString(area.name))", for: UIControlState.normal)
    }
    
    func locationSetting() {
        let vc = ProviceCityViewController()
        vc.delegate = self
        
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func initView() {
        self.navigationController?.tabBarItem.selectedImage = self.tabBarItem.selectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        locationButton = UIButton.init(type: UIButtonType.custom)
        locationButton.frame = CGRect(x: 0, y: 0, width: 120 * times, height: 50 * times)
        locationButton.setTitle("选择地区", for: UIControlState.normal)
        locationButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        locationButton.setImage(UIImage(named: "ic_home_location"), for: UIControlState.normal)
        locationButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5 * times, 0, 0)
        locationButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 14))
        locationButton.addTarget(self, action: #selector(self.locationSetting), for: UIControlEvents.touchUpInside)
        contentScroll.addSubview(locationButton)
        
        let searchTextField = UITextField.init(frame: CGRect(x: locationButton.frame.maxX + 10 * times, y: 10 * times, width: 240 * times, height: 28 * times))
        searchTextField.backgroundColor = self.view.backgroundColor
        searchTextField.layer.cornerRadius = searchTextField.frame.size.height / 2
        searchTextField.layer.masksToBounds = true
        searchTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 14))
        searchTextField.placeholder = "光伏信息"
        searchTextField.delegate = self
        searchTextField.leftViewMode = UITextFieldViewMode.always
        searchTextField.tintColor = UIColor.clear
        contentScroll.addSubview(searchTextField)
        
        let leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 35 * times, height: 28 * times))
        
        let leftIconImage = UIImageView.init(frame: CGRect(x: 10 * times, y: 6.5 * times, width: 15 * times, height: 15 * times))
        leftIconImage.image = UIImage(named: "ic_home_search")
        leftView.addSubview(leftIconImage)
        
        searchTextField.leftView = leftView
        
        let line1 = UILabel.init(frame: CGRect(x: 0, y: locationButton.frame.maxY, width: YCPhoneUtils.screenWidth, height: 0.5))
        line1.backgroundColor = self.view.backgroundColor
        contentScroll.addSubview(line1)
        
        //#MARK: 角色选择
        let roleTitle = UILabel.init(frame: CGRect(x: 0, y: line1.frame.maxY, width: 75 * times, height: 35 * times))
        roleTitle.text = "你想成为"
        roleTitle.textAlignment = NSTextAlignment.center
        roleTitle.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 14))
        contentScroll.addSubview(roleTitle)
        var currentY = roleTitle.frame.maxY
        
        let rolesImg = ["ic_home_jiameng", "ic_home_anzhuang", "ic_home_dimian", "ic_home_yezhu"]
        let roleImgOffSet = (YCPhoneUtils.screenWidth - 85 * times * 4) / 5
        for i in 0..<rolesImg.count {
            let button = UIButton.init(type: UIButtonType.custom)
            button.frame = CGRect(x: roleImgOffSet * CGFloat(i + 1) + 85 * times * CGFloat(i), y: currentY, width: 85 * times, height: 100 * times)
            button.tag = i
            button.addTarget(self, action: #selector(self.roleHomeButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
            button.setBackgroundImage(UIImage(named: rolesImg[i]), for: UIControlState.normal)
            contentScroll.addSubview(button)
            if (i == rolesImg.count - 1) {
                currentY = button.frame.maxY
            }
        }
        
        //#MARK: 广告banner
        bannerScrollView = UIScrollView.init(frame: CGRect(x: 0, y: currentY + 5 * times, width: YCPhoneUtils.screenWidth, height: 145 * times))
        bannerScrollView.backgroundColor = UIColor.white
        bannerScrollView.delegate = self
        bannerScrollView.isPagingEnabled = true
        contentScroll.addSubview(bannerScrollView)
        
        pageControl = UIPageControl.init(frame: CGRect(x: 0, y: bannerScrollView.frame.maxY - 20 * times, width: YCPhoneUtils.screenWidth, height: 20 * times))
        pageControl.backgroundColor = UIColor.clear
        contentScroll.addSubview(pageControl)
        
        currentY = bannerScrollView.frame.maxY
        
        let line2 = UILabel.init(frame: CGRect(x: 0, y: currentY, width: YCPhoneUtils.screenWidth, height: 5 * times))
        line2.backgroundColor = self.view.backgroundColor
        contentScroll.addSubview(line2)
        
        //#MARK: 菜单栏
        menuView = UIView.init(frame: CGRect(x: 0, y: currentY + 5 * times, width: YCPhoneUtils.screenWidth, height: 160 * times))
        menuView.backgroundColor = UIColor.white
        contentScroll.addSubview(menuView)
        currentY = menuView.frame.maxY
        
        loadMenusView()
        
        let line3 = UILabel.init(frame: CGRect(x: 0, y: currentY, width: YCPhoneUtils.screenWidth, height: 5 * times))
        line3.backgroundColor = self.view.backgroundColor
        contentScroll.addSubview(line3)
        
        //#MARK: 推荐案例
        let exampleTitle = UILabel.init(frame: CGRect(x: 0, y: currentY + 5 * times, width: 75 * times, height: 35 * times))
        exampleTitle.text = "推荐案例"
        exampleTitle.textAlignment = NSTextAlignment.center
        exampleTitle.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 14))
        contentScroll.addSubview(exampleTitle)
        
        let moreButton = UIButton.init(type: UIButtonType.custom)
        moreButton.setTitle("更多", for: UIControlState.normal)
        moreButton.frame = CGRect(x: YCPhoneUtils.screenWidth - 45 * times, y: exampleTitle.frame.minY, width: 45 * times, height: 35 * times)
        moreButton.setTitleColor(Colors.appBlue, for: UIControlState.normal)
        moreButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 14))
        moreButton.addTarget(self, action: #selector(self.moreExampleButtonClicked), for: UIControlEvents.touchUpInside)
        contentScroll.addSubview(moreButton)
        currentY = exampleTitle.frame.maxY
        
        exampleView = UIView.init(frame: CGRect(x: 0, y: currentY, width: YCPhoneUtils.screenWidth, height: 120 * times))
        exampleView.backgroundColor = UIColor.white
        contentScroll.addSubview(exampleView)
        currentY = exampleView.frame.maxY
        
        let line4 = UILabel.init(frame: CGRect(x: 0, y: currentY, width: YCPhoneUtils.screenWidth, height: 5 * times))
        line4.backgroundColor = self.view.backgroundColor
        contentScroll.addSubview(line4)
        
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: YCPhoneUtils.screenWidth, height: 50 * times))
        headerView.backgroundColor = UIColor.white
        
        let headerTitles = ["业主", "安装商", "投资", "供求"]
        let headerBtnWidth = headerView.frame.size.width / 4
        let headerBtnHeight = headerView.frame.size.height
        
        for i in 0..<headerTitles.count {
            let headerButton = UIButton.init(type: UIButtonType.custom)
            headerButton.frame = CGRect(x: CGFloat(i) * headerBtnWidth, y: 0, width: headerBtnWidth, height: headerBtnHeight)
            headerButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
            headerButton.setTitle(headerTitles[i], for: UIControlState.normal)
            headerButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            headerButton.tag = i
            headerButton.addTarget(self, action: #selector(self.headerButtonClicked(button:)), for: UIControlEvents.touchUpInside)
            headerView.addSubview(headerButton)
        }
        headerLine = UIView.init(frame: CGRect(x: 0, y: headerBtnHeight - 2, width: headerBtnWidth, height: 2))
        headerLine.backgroundColor = Colors.appBlue
        headerView.addSubview(headerLine)
        
        bottomTableView = UITableView.init(frame: CGRect(x: 0, y: currentY + 5 * times, width: YCPhoneUtils.screenWidth, height: HInstallerCell.cellHeight() + headerView.frame.size.height))
        bottomTableView.delegate = self
        bottomTableView.dataSource = self
        bottomTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        contentScroll.addSubview(bottomTableView)
        bottomTableView.backgroundColor = UIColor.white
        bottomTableView.tableHeaderView = headerView
        currentY = bottomTableView.frame.maxY
        
        contentScroll.contentSize = CGSize(width: 0, height: currentY + 20 * times)
    }
    
    func loadMenusView() {
        let icons = ["ic_home_menu1", "ic_home_menu2", "ic_home_menu3", "ic_home_menu4", "ic_home_menu5", "ic_home_menu6", "ic_home_menu7", "ic_home_menu8"]
        let names = ["体验店", "政策咨询", "安装运维", "光伏保险", "光伏问答", "公司介绍", "活动通告", "客服"]
        
        let btnWidth = PhoneUtils.kScreenWidth / 4
        let btnHeight = menuView.frame.size.height / 2
        var index: CGFloat = 0
        var line: CGFloat = 0
        for i in 0..<icons.count {
            if (i != 0 && i%4==0) {
                index = 0
                line += 1
            }
            let button = ImageTitleButton.init(type: UIButtonType.custom)
            button.frame = CGRect(x: btnWidth * index, y: btnHeight * line , width:btnWidth , height: btnHeight)
            button.setImage(UIImage(named: icons[i]), for: UIControlState.normal)
            button.setTitle(names[i], for: UIControlState.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 14))
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.tag = i
            button.addTarget(self, action: #selector(self.menuButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
            button.verticalImageAndTitle(2)
            menuView.addSubview(button)
            
            index += 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadBannerData() {
        API.sharedInstance.articlesList(0, pagesize: 10, key: nil, provinceId: nil, cityId: nil, areaId: nil, type: 10, success: { (count, array) in
            if (array.count > 0) {
                self.bannerData.addObjects(from: array as! [Any])
                self.initBannerImageView()
            }
        }) { (msg) in
            
        }
    }
    
    func loadExampleData() {
        API.sharedInstance.articlesList(0, pagesize: 10, key: nil, provinceId: nil, cityId: nil, areaId: nil, type: 2, success: { (count, array) in
            if (array.count > 0) {
                self.exampleData.addObjects(from: array as! [Any])
                self.refreshExampleButtons()
            }
        }) { (msg) in
            
        }
    }
    
    func refreshExampleButtons() {
        let times = YCPhoneUtils.screenWidth / 375
        let offSetX = (YCPhoneUtils.screenWidth - 120 * times * 3) / 4
        let width = 120 * times
        for i in 0..<exampleData.count {
            let info = exampleData[i] as! ArticleInfo
            let exampleButton = UIButton.init(type: UIButtonType.custom)
            exampleButton.frame = CGRect(x: offSetX * CGFloat(i + 1) + width * CGFloat(i), y: 0, width: width, height: width)
            exampleButton.setBackgroundImageFor(UIControlState.normal, with: URL.init(string: info.image!)!)
            exampleButton.tag = i
            exampleButton.addTarget(self, action: #selector(self.exampleButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
            exampleView.addSubview(exampleButton)
        }
    }
    
    func exampleButtonClicked(sender: UIButton) {
        let data = exampleData[sender.tag] as! ArticleInfo
        
        let shareInfo = ShareInfo()
        shareInfo.shareImg = YCStringUtils.getString(data.image)
        shareInfo.shareTitle = YCStringUtils.getString("资讯")
        shareInfo.shareDesc = YCStringUtils.getString(data.title)
        shareInfo.shareLink = Constants.httpHost.replacingOccurrences(of: "/api/", with: "") + "/articles/\(data.id!)"
        
        let vc = GFJWebViewController()
        vc.url = Constants.httpHost.replacingOccurrences(of: "/api/", with: "") + "/articles/\(data.id!)"
        vc.title = YCStringUtils.getString(data.title)
        vc.addShareInfoButton(info: shareInfo)
        self.pushViewController(vc)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = PhoneUtils.kScreenWidth
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        pageControl.currentPage = Int(page)
    }
    
    //#MARK: 刷新banner数据
    func initBannerImageView() {
        if (bannerScrollView.subviews.count > 0) {
            for view in bannerScrollView.subviews {
                view.removeFromSuperview()
            }
        }
        for i in 0..<bannerData.count {
            let info = bannerData[i] as! ArticleInfo
            let imageView = UIImageView.init(frame: CGRect(x: CGFloat(i) * PhoneUtils.kScreenWidth, y: 0, width: PhoneUtils.kScreenWidth, height: bannerScrollView.frame.size.height))
            imageView.setImageWith(URL.init(string: YCStringUtils.getString(info.image))!)
            imageView.tag = i
            imageView.isUserInteractionEnabled = true
            bannerScrollView.addSubview(imageView)
            
            let gesture = UITapGestureRecognizer()
            gesture.addTarget(self, action: #selector(self.bannerClicked(gesture:)))
            imageView.addGestureRecognizer(gesture)
            
        }
        pageControl.numberOfPages = bannerData.count
        bannerScrollView.contentSize = CGSize(width: PhoneUtils.kScreenWidth * CGFloat(bannerData.count), height: 0)
    }
    
    //#MARK: 跳转到role的首页
    func roleHomeButtonClicked(sender: UIButton) {
        if (sender.tag == 0) {
            let vc = JiaMengHomeV2ViewController()
            self.pushViewController(vc)
        } else if (sender.tag == 1) {
            let vc = AnZhuangHomeV2ViewController()
            self.pushViewController(vc)
        } else if (sender.tag == 2) {
            let vc = DiTuiHomeV2ViewController()
            self.pushViewController(vc)
        } else if (sender.tag == 3) {
            let vc = YeZhuHomeV2ViewController()
            self.pushViewController(vc)
        }
    }
    
    //#MARK: banner点击
    func bannerClicked(gesture: UITapGestureRecognizer) {
        let index = gesture.view?.tag
        if (index == 0) {
            self.tabBarController?.selectedIndex = 3
        } else if (index == 1) {
            self.tabBarController?.selectedIndex = 2
        } else if (index == 2) {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            self.pushViewController(sb.instantiateViewController(withIdentifier: "RootInsuranceViewController"))
        }
    }
    
    //#MARK: 菜单按钮点击
    func menuButtonClicked(sender: UIButton) {
        if (sender.tag == 0) {
            //体验店
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ExperienceShopViewController")
            self.pushViewController(vc)
        } else if (sender.tag == 1) {
            //政策资讯
            self.tabBarController?.selectedIndex = 3
        } else if (sender.tag == 2) {
            //安装运维
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "NewsListViewController") as! NewsListViewController
            vc.type = 7
            vc.title = "安装运维"
            self.pushViewController(vc)
        } else if (sender.tag == 3) {
            //光伏保险
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            self.pushViewController(sb.instantiateViewController(withIdentifier: "RootInsuranceViewController"))
        } else if (sender.tag == 4) {
            //光伏问答
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            self.pushViewController(sb.instantiateViewController(withIdentifier: "GuangFuAskViewController"))
        } else if (sender.tag == 5) {
            //公司介绍
            API.sharedInstance.articlesList(0, pagesize: 1, key: nil, provinceId: nil, cityId: nil, areaId: nil, type: 8, success: { (count, array) in
                if (array.count >= 1) {
                    let article = array[0] as! ArticleInfo
                    let vc = GFJWebViewController()
                    vc.title = "公司介绍"
                    vc.url = Constants.httpHost.replacingOccurrences(of: "/api/", with: "") + "/articles/\(article.id!)"
                    self.pushViewController(vc)
                }
            }) { (msg) in
                self.showHint(msg)
            }
        } else if (sender.tag == 6) {
            //活动通告
            self.showHint("我们正在筹备中，暂未开放")
        } else if (sender.tag == 7) {
            //客服
            self.chat()
        }
    }
    
    //#MARK: 更多案例
    func moreExampleButtonClicked() {
//        //更多案例
//        let sb = UIStoryboard.init(name: "Main", bundle: nil)
//        let vc = sb.instantiateViewController(withIdentifier: "NewsListViewController") as! NewsListViewController
//        vc.type = 2
//        vc.title = "成功案例"
//        self.pushViewController(vc)
        let vc = RootMapV2ViewController()
        self.pushViewController(vc)
    }
    
    //textField delegate method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        self.tabBarController?.selectedIndex = 3
    }
    
    //#MARK: 底部tableview
    
    //业主列表
    func loadInstallerList() {
        API.sharedInstance.getRoofList(0, pagesize: 1, status: 1, province_id: nil, city_id: nil, min_area_size: nil, max_area_size: nil, type: nil, success: { (userInfos) in
            self.hideHud()
            self.installerArray.removeAllObjects()
            self.installerArray.addObjects(from: userInfos as [AnyObject])
            self.bottomTableView.reloadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    //安装商列表
    func loadYezhuList() {
        API.sharedInstance.installerSuggest(success: { (array) in
            self.hideHud()
            self.yezhuArray.removeAllObjects()
            self.yezhuArray.addObjects(from: array as [AnyObject])
            self.bottomTableView.reloadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    //投资列表
    func loadTouziList() {
        self.bottomTableView.reloadData()
    }
    
    //供求立碑
    func loadGongqiuList() {
         self.bottomTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (currentIndex == 0) {
            return installerArray.count
        } else if (currentIndex == 1) {
            return yezhuArray.count
        } else if (currentIndex == 2) {
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (currentIndex == 0) {
            return HInstallerCell.cellHeight()
        } else if (currentIndex == 1) {
            return HYeZhuCell.cellHeight()
        } else {
            return HInvestAndOfferCell.cellHeight()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (currentIndex == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: installerCellReuseIdentifier, for: indexPath as IndexPath) as! HInstallerCell
            cell.initCell()
            cell.viewMoreButton.addTarget(self, action: #selector(self.moreRoofList), for: UIControlEvents.touchUpInside)
            let userInfo = installerArray[indexPath.row] as! RoofInfo
            cell.setData(userInfo: userInfo)
            return cell
        } else if (currentIndex == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: yezhuCellReuseIdentifier, for: indexPath as IndexPath) as! HYeZhuCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none;
            cell.initCell()
            cell.viewMoreButton.addTarget(self, action: #selector(self.moreInstallerList), for: UIControlEvents.touchUpInside)
            let userInfo = yezhuArray[indexPath.row] as! InstallInfo
            cell.setData(userInfo: userInfo)
            return cell
        } else if (currentIndex == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: touziCellReuseIdentifier, for: indexPath as IndexPath) as! HInvestAndOfferCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none;
            cell.initCell()
            cell.bkgImageView.image = UIImage(named: "ic_touzi_info")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: gongqiuCellReuseIdentifier, for: indexPath as IndexPath) as! HInvestAndOfferCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none;
            cell.initCell()
            cell.bkgImageView.image = UIImage(named: "ic_image_gongqiu")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if (currentIndex == 2) {
            let vc = InvestAddViewController()
            self.pushViewController(vc)
        } else if (currentIndex == 3){
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ProductProvideViewController")
            self.pushViewController(vc)
        }
    }
    
    //更多业主
    func moreRoofList() {
        let vc = GFJRoofListViewController(nibName: "GFJRoofListViewController", bundle: nil)
        self.pushViewController(vc)
    }
    
    //更多安装商
    func moreInstallerList() {
        let vc = MoreInstallerViewController(nibName: "MoreInstallerViewController", bundle: nil)
        self.pushViewController(vc)
    }
    
    func headerButtonClicked(button: UIButton) {
        let width = YCPhoneUtils.screenWidth / 4
        let height: CGFloat = 2
        if (button.tag == 0) {
            currentIndex = 0
            headerLine.frame = CGRect(x: 0, y: headerLine.frame.origin.y, width: width, height: height)
            loadInstallerList()
        } else if (button.tag == 1) {
            currentIndex = 1
            loadYezhuList()
            headerLine.frame = CGRect(x: width, y: headerLine.frame.origin.y, width: width, height: height)
        } else if (button.tag == 2) {
            currentIndex = 2
            loadTouziList()
            headerLine.frame = CGRect(x: width * 2, y: headerLine.frame.origin.y, width: width, height: height)
        } else {
            currentIndex = 3
            loadGongqiuList()
            headerLine.frame = CGRect(x: width * 3, y: headerLine.frame.origin.y, width: width, height: height)
        }
    }
}
