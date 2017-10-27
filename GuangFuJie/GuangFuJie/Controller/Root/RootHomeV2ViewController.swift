//
//  RootHomeV2ViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/10/27.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootHomeV2ViewController: BaseViewController, UIScrollViewDelegate, UITextFieldDelegate, ProviceCityViewDelegate {
    var contentScroll: UIScrollView!
    
    var pageControl: UIPageControl!
    var bannerScrollView: UIScrollView!
    var menuView: UIView!
    var exampleView: UIView!
    var locationButton: UIButton!
    
    var bannerData = NSMutableArray()
    var exampleData = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
        
        contentScroll = UIScrollView.init(frame: CGRect(x: 0, y: self.navigationBarAndStatusBarHeight(), width: YCPhoneUtils.screenWidth, height: YCPhoneUtils.screenHeight - self.navigationBarAndStatusBarHeight()))
        contentScroll.backgroundColor = UIColor.white
        self.view.addSubview(contentScroll)
        
        initView()
        loadBannerData()
        loadExampleData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshLocation), name: NSNotification.Name(rawValue: "RefreshLocation"), object: nil)
        self.getCurrentLocation()
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
        let times = YCPhoneUtils.screenWidth / 375
        
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
        searchTextField.textAlignment = NSTextAlignment.center
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
        contentScroll.addSubview(moreButton)
        currentY = exampleTitle.frame.maxY
        
        exampleView = UIView.init(frame: CGRect(x: 0, y: currentY, width: YCPhoneUtils.screenWidth, height: 120 * times))
        exampleView.backgroundColor = UIColor.white
        contentScroll.addSubview(exampleView)
        currentY = exampleView.frame.maxY
        
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
        API.sharedInstance.articlesList(0, pagesize: 0, key: nil, provinceId: nil, cityId: nil, areaId: nil, type: 10, success: { (count, array) in
            if (array.count > 0) {
                self.bannerData.addObjects(from: array as! [Any])
                self.initBannerImageView()
            }
        }) { (msg) in
            
        }
    }
    
    func loadExampleData() {
        API.sharedInstance.articlesList(0, pagesize: 0, key: nil, provinceId: nil, cityId: nil, areaId: nil, type: 2, success: { (count, array) in
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
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            self.pushViewController(sb.instantiateViewController(withIdentifier: "JoinUsViewController"))
        } else if (sender.tag == 1) {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            self.pushViewController(sb.instantiateViewController(withIdentifier: "InstallerHomeViewController"))
        } else if (sender.tag == 2) {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            self.pushViewController(sb.instantiateViewController(withIdentifier: "DiTuiHomeViewController"))
        } else if (sender.tag == 3) {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            self.pushViewController(sb.instantiateViewController(withIdentifier: "YeZhuViewController"))
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
    
    //textField delegate method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        self.tabBarController?.selectedIndex = 3
    }
}
