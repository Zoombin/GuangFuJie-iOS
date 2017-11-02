//
//  AnZhuangApplyViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/11/2.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class AnZhuangHomeV2ViewController: BaseViewController, UIScrollViewDelegate {
    var loginButton: UIButton!
    var userNameLabel: UILabel!
    var statusButton: UIButton!
    
    var pageControl: UIPageControl!
    var bannerScrollView: UIScrollView!
    
    var bannerData = NSMutableArray()
    
    var dituiButton: UIButton!
    var yezhuButton: UIButton!
    var anzhuangButton: UIButton!
    var jiamengButton: UIButton!
    
    var contentScrollView: UIScrollView!
    var headerView: UIView!
    
    let titles = ["本地市场　", "本地业主　", "光伏政策　", "光伏保险　", "光伏贷款　", "供电局　", "安装运维　", "实战模式　", "产品供求　", "客服　　　"]
    let images = ["ic_menu_bdsc", "ic_menu_bdyz", "ic_menu_gfzc", "ic_menu_gfbx", "ic_menu_gfdk", "ic_menu_gdj", "ic_menu_azyw", "ic_menu_szms", "ic_menu_cpgq", "ic_menu_kf"]
    
    let times = YCPhoneUtils.screenWidth / 375
    var startY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安装商"
        initView()
        addHeaderView()
        addMenus()
        initBannerImageView()
        
        loadBannerData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "安装商列表", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.installerList))
    }
    
    func installerList() {
        let vc = MoreInstallerViewController()
        self.pushViewController(vc)
    }
    
    func initView() {
        contentScrollView = UIScrollView.init(frame: CGRect(x: 0, y: self.navigationBarAndStatusBarHeight(), width: YCPhoneUtils.screenWidth, height: YCPhoneUtils.screenHeight - self.navigationBarAndStatusBarHeight()))
        self.view.addSubview(contentScrollView)
    }
    
    func addHeaderView() {
        headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 163 * times))
        headerView.backgroundColor = self.view.backgroundColor
        contentScrollView.addSubview(headerView)
        
        let topView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 163 * times))
        topView.backgroundColor = Colors.appBlue
        headerView.addSubview(topView)
        
        let imgs = ["ic_my_role_jiamengshang", "ic_my_role_anzhuangshang", "ic_my_role_yezhu", "ic_my_role_ditui"]
        let titles = ["加盟商", "安装商", "业主", "地推"]
        for i in 0..<imgs.count {
            let button = UIButton.init(type: UIButtonType.custom)
            button.frame = CGRect(x: PhoneUtils.kScreenWidth - 70 * times, y: CGFloat(i) * 28 * times, width: 70 * times, height: 28 * times)
            button.setBackgroundImage(UIImage(named: imgs[i]), for: UIControlState.normal)
            button.setTitle(titles[i], for: UIControlState.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
            button.setTitleColor(UIColor.white, for: UIControlState.normal)
            button.isHidden = true
            headerView.addSubview(button)
            
            if (i == 0) {
                jiamengButton = button
            } else if (i == 1) {
                anzhuangButton = button
            } else if (i == 2) {
                yezhuButton = button
            } else {
                dituiButton = button
            }
        }
        
        let avatarImage = UIImageView.init(frame: CGRect(x: 10 * times, y: (163 - 74) / 2 * times, width: 74 * times, height: 74 * times))
        avatarImage.image = UIImage(named: "ic_avatar")
        topView.addSubview(avatarImage)
        
        userNameLabel = UILabel.init(frame: CGRect(x: avatarImage.frame.maxX + 10 * times, y: 57 * times, width: 100 * times, height: 27 * times))
        userNameLabel.textColor = UIColor.white
        userNameLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        userNameLabel.isHidden = true
        topView.addSubview(userNameLabel)
        
        loginButton = UIButton.init(frame: CGRect(x: avatarImage.frame.maxX + 10 * times, y: (163 - 27) * times / 2, width: 100 * times, height: 27 * times))
        loginButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 17))
        loginButton.setTitle("点击登录", for: UIControlState.normal)
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: UIControlEvents.touchUpInside)
        loginButton.isHidden = true
        topView.addSubview(loginButton)
        
        statusButton = UIButton.init(frame: CGRect(x: avatarImage.frame.maxX + 10 * times, y: 86 * times, width: 110 * times, height: 27 * times))
        statusButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        statusButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        statusButton.setTitle("申请成为地推", for: UIControlState.normal)
        statusButton.addTarget(self, action: #selector(self.statusButtonClicked), for: UIControlEvents.touchUpInside)
        statusButton.backgroundColor = Colors.applyGreen
        statusButton.isHidden = true
        topView.addSubview(statusButton)
    }
    
    func addMenus() {
        startY = headerView.frame.maxY + 5 * times
        let btnWidth = YCPhoneUtils.screenWidth / 2
        let btnHeight = 50 * times
        var index = 0
        var line = 0
        for i in 0..<titles.count {
            if (i % 2 == 0 && i != 0) {
                line += 1
                index = 0
            }
            let menuButton = UIButton.init(type: UIButtonType.custom)
            menuButton.frame = CGRect(x: CGFloat(index) * btnWidth, y: startY + CGFloat(line) * btnHeight, width: btnWidth, height: btnHeight)
            menuButton.setImage(UIImage(named: images[i]), for: UIControlState.normal)
            menuButton.setTitle(titles[i], for: UIControlState.normal)
            menuButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            menuButton.backgroundColor = UIColor.white
            menuButton.layer.borderColor = Colors.bkgColor.cgColor
            menuButton.layer.borderWidth = 0.5
            menuButton.tag = i
            menuButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
            menuButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            menuButton.contentEdgeInsets = UIEdgeInsetsMake(0, 40 * times, 0, 0)
            menuButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10 * times, 0, 0)
            menuButton.addTarget(self, action: #selector(self.menuButtonClicked(button:)), for: UIControlEvents.touchUpInside)
            contentScrollView.addSubview(menuButton)
            index += 1
        }
        startY = startY + CGFloat(line + 1) * btnHeight
    }
    
    func menuButtonClicked(button: UIButton) {
        let title = titles[button.tag]
        self.goToPageByTitle(title: title)
    }
    
    func statusButtonClicked() {
        let role = YCStringUtils.getNumber(UserDefaultManager.getUser()!.identity)
        if (role == 0) {
            //普通人
            print("申请地推")
            applyDiTui()
        } else if (role == 3) {
            //地推
            print("申请业主")
            applyYeZhu()
        } else if (role == 4) {
            //业主
            print("申请安装商")
            applyAnZhuang()
        } else if (role == 1) {
            //安装商
            print("申请加盟商")
            applyJiaMeng()
        }
    }
    
    func loginButtonClicked() {
        if (UserDefaultManager.isLogin() == true) {
            return
        }
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        self.pushViewController(sb.instantiateViewController(withIdentifier: "LoginViewController"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshUserInfo()
    }
    
    func refreshUserInfo() {
        if (!UserDefaultManager.isLogin()) {
            self.refreshUserStatus()
            return
        }
        API.sharedInstance.getUserInfo({ (userinfo) in
            UserDefaultManager.saveString(UserDefaultManager.USER_INFO, value: userinfo.mj_JSONString())
            self.refreshUserStatus()
        }) { (msg) in
            
        }
    }
    
    func refreshUserStatus() {
        resetRolesBtn()
        if (UserDefaultManager.isLogin()) {
            loginButton.isHidden = true
            userNameLabel.text = UserDefaultManager.getUser()?.user_name
            userNameLabel.isHidden = false
            statusButton.isHidden = false
            //身份  普通人 --> 地推(3)-->  业主(4)  --> 安装商(1)  --> 加盟商(2)
            let role = YCStringUtils.getNumber(UserDefaultManager.getUser()!.identity)
            userNameLabel.frame = CGRect(x: userNameLabel.frame.origin.x, y: 57 * times, width: userNameLabel.frame.size.width, height: userNameLabel.frame.size.height)
            if (role == 0) {
                //普通人
                statusButton.setTitle("申请成为地推", for: UIControlState.normal)
            } else if (role == 3) {
                //地推
                statusButton.setTitle("申请成为业主", for: UIControlState.normal)
            } else if (role == 4) {
                //业主
                statusButton.setTitle("申请成为安装商", for: UIControlState.normal)
            } else if (role == 1) {
                //安装商
                statusButton.setTitle("申请成为加盟商", for: UIControlState.normal)
            } else if (role == 2) {
                //加盟商
                statusButton.isHidden = true
                userNameLabel.frame = CGRect(x: userNameLabel.frame.origin.x, y: (163 * times - userNameLabel.frame.size.height) / 2, width: userNameLabel.frame.size.width, height: userNameLabel.frame.size.height)
            }
        } else {
            loginButton.isHidden = false
            userNameLabel.text = ""
            userNameLabel.isHidden = true
            statusButton.isHidden = true
        }
    }
    
    func resetRolesBtn() {
        dituiButton.isHidden = true
        yezhuButton.isHidden = true
        anzhuangButton.isHidden = true
        jiamengButton.isHidden = true
        if (!UserDefaultManager.isLogin()) {
            return
        }
        let role = YCStringUtils.getNumber(UserDefaultManager.getUser()!.identity)
        if (role == 0) {
            //普通人
        } else if (role == 3) {
            //地推
            dituiButton.isHidden = false
            dituiButton.frame = CGRect(x: dituiButton.frame.minX, y: (163 * times - dituiButton.frame.height) / 2, width: dituiButton.frame.width, height: dituiButton.frame.height)
        } else if (role == 4) {
            //业主
            dituiButton.isHidden = false
            yezhuButton.isHidden = false
            yezhuButton.frame = CGRect(x: dituiButton.frame.minX, y: (163 * times - dituiButton.frame.height * 2) / 2, width: dituiButton.frame.width, height: dituiButton.frame.height)
            dituiButton.frame = CGRect(x: dituiButton.frame.minX, y: yezhuButton.frame.maxY, width: dituiButton.frame.width, height: dituiButton.frame.height)
        } else if (role == 1) {
            //安装商
            dituiButton.isHidden = false
            yezhuButton.isHidden = false
            anzhuangButton.isHidden = false
            anzhuangButton.frame = CGRect(x: dituiButton.frame.minX, y: (163 * times - dituiButton.frame.height * 3) / 2, width: dituiButton.frame.width, height: dituiButton.frame.height)
            yezhuButton.frame = CGRect(x: dituiButton.frame.minX, y: anzhuangButton.frame.maxY, width: dituiButton.frame.width, height: dituiButton.frame.height)
            dituiButton.frame = CGRect(x: dituiButton.frame.minX, y: yezhuButton.frame.maxY, width: dituiButton.frame.width, height: dituiButton.frame.height)
        } else if (role == 2) {
            //加盟商
            dituiButton.isHidden = false
            yezhuButton.isHidden = false
            anzhuangButton.isHidden = false
            jiamengButton.isHidden = false
            jiamengButton.frame = CGRect(x: dituiButton.frame.minX, y: (163 * times - dituiButton.frame.height * 4) / 2, width: dituiButton.frame.width, height: dituiButton.frame.height)
            anzhuangButton.frame = CGRect(x: dituiButton.frame.minX, y: jiamengButton.frame.maxY, width: dituiButton.frame.width, height: dituiButton.frame.height)
            yezhuButton.frame = CGRect(x: dituiButton.frame.minX, y: anzhuangButton.frame.maxY, width: dituiButton.frame.width, height: dituiButton.frame.height)
            dituiButton.frame = CGRect(x: dituiButton.frame.minX, y: yezhuButton.frame.maxY, width: dituiButton.frame.width, height: dituiButton.frame.height)
        }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = PhoneUtils.kScreenWidth
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        pageControl.currentPage = Int(page)
    }
    
    //#MARK: 刷新banner数据
    func initBannerImageView() {
        bannerScrollView = UIScrollView.init(frame: CGRect(x: 0, y: startY + 5 * times, width: YCPhoneUtils.screenWidth, height: 145 * times))
        bannerScrollView.backgroundColor = UIColor.white
        bannerScrollView.delegate = self
        bannerScrollView.isPagingEnabled = true
        contentScrollView.addSubview(bannerScrollView)
        
        pageControl = UIPageControl.init(frame: CGRect(x: 0, y: bannerScrollView.frame.maxY - 20 * times, width: YCPhoneUtils.screenWidth, height: 20 * times))
        pageControl.backgroundColor = UIColor.clear
        contentScrollView.addSubview(pageControl)
        
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
        
        contentScrollView.contentSize = CGSize(width: 0, height: bannerScrollView.frame.maxY + 5 * times)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
