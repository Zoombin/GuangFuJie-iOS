//
//  RootYeZhuViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/3.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

//业主
class RootYeZhuViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var yezhuTableView : UITableView!
    var yezhuPageControl : UIPageControl!
    var yezhuView : UIView!
    
    var yezhuArray = NSMutableArray()
    
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
        
        initYeZhuView()
        
        loadUserList()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("业主")
    }
    
    //MARK: 业主列表
    func loadUserList() {
        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.userlist(2, province_id: nil, city_id: nil, is_suggest: 1, success: { (userInfos) in
            self.hideHud()
            self.yezhuArray.removeAllObjects()
            if (userInfos.count > 0) {
                self.yezhuArray.addObjectsFromArray(userInfos as [AnyObject])
            }
            self.yezhuTableView.reloadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    //MARK: 业主
    let yezhuCellReuseIdentifier = "yezhuCellReuseIdentifier"
    func initYeZhuView() {
        yezhuView = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(topMenuView.frame), PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - topMenuView.frame.size.height - 64))
        self.view.addSubview(yezhuView)
        
        let buttonWidth = (PhoneUtils.kScreenWidth) / 3
        let buttonHeight = PhoneUtils.kScreenHeight / 14
        
        let yezhuBottomView = UIView.init(frame: CGRectMake(0, yezhuView.frame.size.height - buttonHeight, PhoneUtils.kScreenWidth, buttonHeight))
        yezhuBottomView.backgroundColor = Colors.installColor
        yezhuView.addSubview(yezhuBottomView)
        
        let calRoomButton = UIButton.init(type: UIButtonType.Custom)
        calRoomButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight)
        calRoomButton.setTitle("屋顶评估", forState: UIControlState.Normal)
        calRoomButton.backgroundColor = UIColor.clearColor()
        calRoomButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        calRoomButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge)
        calRoomButton.addTarget(self, action: #selector(self.calRoomButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        yezhuBottomView.addSubview(calRoomButton)
        
        let soldRoomButton = UIButton.init(type: UIButtonType.Custom)
        soldRoomButton.frame = CGRectMake(buttonWidth, 0, buttonWidth, buttonHeight)
        soldRoomButton.setTitle("屋顶出租", forState: UIControlState.Normal)
        soldRoomButton.backgroundColor = UIColor.clearColor()
        soldRoomButton.addTarget(self, action: #selector(self.soldRoomButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        soldRoomButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        soldRoomButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge)
        yezhuBottomView.addSubview(soldRoomButton)
        
        let mapAreaButton = UIButton.init(type: UIButtonType.Custom)
        mapAreaButton.frame = CGRectMake(buttonWidth * 2, 0, buttonWidth, buttonHeight)
        mapAreaButton.setTitle("屋顶地图", forState: UIControlState.Normal)
        mapAreaButton.backgroundColor = UIColor.clearColor()
        mapAreaButton.addTarget(self, action: #selector(self.mapAreaButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        mapAreaButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        mapAreaButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge)
        yezhuBottomView.addSubview(mapAreaButton)
        
        let line1 = UIView.init(frame: CGRectMake(buttonWidth, 0.25 * buttonHeight, 1, buttonHeight * 0.5))
        line1.backgroundColor = UIColor.whiteColor()
        yezhuBottomView.addSubview(line1)
        
        let line2 = UIView.init(frame: CGRectMake(buttonWidth * 2, 0.25 * buttonHeight, 1, buttonHeight * 0.5))
        line2.backgroundColor = UIColor.whiteColor()
        yezhuBottomView.addSubview(line2)
        
        let offSetY : CGFloat = 8
        let scrollViewWidth = PhoneUtils.kScreenWidth
        let scrollViewHeight = offSetY + (520 * scrollViewWidth) / 750
        
        let footerView = UIView.init(frame: CGRectMake(0, 0, scrollViewWidth, scrollViewHeight))
        
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
        
        yezhuPageControl = UIPageControl.init(frame: CGRectMake(0, footerView.frame.size.height - 20, scrollView.frame.size.width, 20))
        yezhuPageControl.numberOfPages = images.count
        footerView.addSubview(yezhuPageControl)
        
        let tableViewHeight = CGRectGetMinY(yezhuBottomView.frame)
        yezhuTableView = UITableView.init(frame: CGRectMake(0, 0, yezhuView.frame.size.width, tableViewHeight), style: UITableViewStyle.Plain)
        yezhuTableView.delegate = self
        yezhuTableView.dataSource = self
        yezhuTableView.backgroundColor = Colors.bkgColor
        yezhuTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        yezhuView.addSubview(yezhuTableView)
        
        yezhuTableView.tableHeaderView = footerView
        
        yezhuTableView.registerClass(YeZhuCell.self, forCellReuseIdentifier: yezhuCellReuseIdentifier)
    }
    
    func calRoomButtonClicked() {
        let vc = RoofPriceViewController()
        self.pushViewController(vc)
    }
    
    func mapAreaButtonClicked() {
        let vc = MapViewController()
        self.pushViewController(vc)
    }
    
    func soldRoomButtonClicked() {
        if (shouldShowLogin()) {
            return
        }
        let vc = LeaseViewController(nibName: "LeaseViewController", bundle: nil)
        self.pushViewController(vc)
    }
    
    func moreInstaller() {
        let vc = MoreInstallerViewController()
        self.pushViewController(vc)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yezhuArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return YeZhuCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(yezhuCellReuseIdentifier, forIndexPath: indexPath) as! YeZhuCell
        cell.initCell()
        let userInfo = yezhuArray[indexPath.row] as! InstallInfo
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
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        yezhuPageControl.currentPage = Int(page)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
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
