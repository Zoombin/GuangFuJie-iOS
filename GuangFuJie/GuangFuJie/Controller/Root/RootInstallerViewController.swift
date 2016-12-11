//
//  RootInstallerViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/3.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

//安装商
class RootInstallerViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var installTableView : UITableView!
    var installerPageControl : UIPageControl!
    var installView : UIView!
    var installerButton : UIButton!
    
    var installerArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        //MARK: 如果是root的话必须初始化这三个
        showTopMenu(self.tabBarController!.selectedIndex)
        initRightNavButton()
        initLeftNavButton()
        initLoginView()
        
        initInstallerView()
        
        loadUserList()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refreshButtonStatus()
    }
    
    //MARK: 屋顶列表
    func loadUserList() {
        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.getRoofList(0, pagesize: 10, province_id: nil, city_id: nil, is_suggest: 1, success: { (userInfos) in
            self.hideHud()
            self.installerArray.removeAllObjects()
            if (userInfos.count > 0) {
                self.installerArray.addObject(userInfos.firstObject!)
            }
            self.installTableView.reloadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    //MARK: 屋顶
    let installerCellReuseIdentifier = "installerCellReuseIdentifier"
    func initInstallerView() {
        installView = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(topMenuView.frame), PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - topMenuView.frame.size.height - 64))
        installView.backgroundColor = UIColor.yellowColor()
        self.view.addSubview(installView)
        
        let installViewBottomView = UIView.init(frame: CGRectMake(0, installView.frame.size.height - 50, PhoneUtils.kScreenWidth, 50))
        installViewBottomView.backgroundColor = UIColor.whiteColor()
        installView.addSubview(installViewBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = installViewBottomView.frame.size.height - 5 * 2
        
        installerButton = UIButton.init(type: UIButtonType.Custom)
        installerButton.frame = CGRectMake(5, 5, buttonWidth, buttonHeight)
        installerButton.setTitle("申请成为安装商", forState: UIControlState.Normal)
        installerButton.backgroundColor = Colors.installColor
        installerButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        installerButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge2)
        installerButton.addTarget(self, action: #selector(self.wantToBeInstaller), forControlEvents: UIControlEvents.TouchUpInside)
        installViewBottomView.addSubview(installerButton)
        
        let offSetY : CGFloat = 8
        let scrollViewWidth = PhoneUtils.kScreenWidth
        let scrollViewHeight = offSetY + (520 * scrollViewWidth) / 750
        
        let footerView = UIView.init(frame: CGRectMake(0, 0, scrollViewWidth, scrollViewHeight + 15))
        
        let scrollView = UIScrollView.init(frame: CGRectMake(0, 0, scrollViewWidth, scrollViewHeight))
        let images = ["ic_test_ad001", "ic_test_ad002", "ic_test_ad003", "ic_test_ad004"]
        
        scrollView.contentSize = CGSizeMake(scrollViewWidth * CGFloat(images.count), 0)
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        footerView.addSubview(scrollView)
        
        for i in 0..<images.count {
            let imageView = UIImageView.init(frame: CGRectMake(CGFloat(i) * scrollViewWidth, offSetY, scrollViewWidth, scrollViewHeight))
            imageView.image = UIImage(named: images[i])
            scrollView.addSubview(imageView)
        }
        
        installerPageControl = UIPageControl.init(frame: CGRectMake(0, footerView.frame.size.height - 20 - 15, scrollView.frame.size.width, 20))
        installerPageControl.numberOfPages = images.count
        footerView.addSubview(installerPageControl)
        
        let tableViewHeight = CGRectGetMinY(installViewBottomView.frame)
        installTableView = UITableView.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, tableViewHeight), style: UITableViewStyle.Plain)
        installTableView.delegate = self
        installTableView.dataSource = self
        installTableView.backgroundColor = Colors.bkgColor
        installTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        installView.addSubview(installTableView)
        
        installTableView.tableHeaderView = footerView
        
        installTableView.registerClass(InstallerCell.self, forCellReuseIdentifier: installerCellReuseIdentifier)
    }
    
    func refreshButtonStatus() {
        if (!UserDefaultManager.isLogin()) {
            installerButton.setTitle("申请成为安装商", forState: UIControlState.Normal)
            return
        }
        API.sharedInstance.checkIsInstaller({ (msg, commonModel) in
            if (commonModel.is_installer == 0) {
                self.installerButton.setTitle("申请成为安装商", forState: UIControlState.Normal)
            } else {
                self.installerButton.setTitle("查看详情", forState: UIControlState.Normal)
            }
        }) { (msg) in

        }
    }
    
    func wantToBeInstaller() {
        if (shouldShowLogin()) {
            return
        }
        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.checkIsInstaller({ (msg, commonModel) in
            self.hideHud()
            if (commonModel.is_installer == 0) {
                let vc = ToBeInstallerViewController(nibName: "ToBeInstallerViewController", bundle: nil)
                self.pushViewController(vc)
            } else {
                //2的时候是安装商了
                let vc = UserCenterViewController()
                self.pushViewController(vc)
            }
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
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
        cell.viewMoreButton.addTarget(self, action: #selector(self.viewMoreButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    func viewMoreButtonClicked() {
        let vc = GFJRoofListViewController()
        self.pushViewController(vc)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        installerPageControl.currentPage = Int(page)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let userInfo = installerArray[indexPath.row] as! RoofInfo
        let vc = InstallBuyViewController()
        vc.roofId = userInfo.id!
        self.pushViewController(vc)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
