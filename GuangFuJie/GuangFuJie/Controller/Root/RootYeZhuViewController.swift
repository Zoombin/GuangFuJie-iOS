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
        self.title = Texts.tab2
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        //MARK: 如果是root的话必须初始化这三个
        initRightNavButton()
        initLeftNavButton()
        initYeZhuView()
        
        loadUserList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("业主")
    }
    
    //MARK: 业主列表
    func loadUserList() {
//        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.userlist(0, pagesize: 10, type: 2, province_id: nil, city_id: nil, is_suggest: 1, success: { (totalCount, userInfos) in
            self.hideHud()
            self.yezhuArray.removeAllObjects()
            if (userInfos.count > 0) {
                self.yezhuArray.add(userInfos.firstObject!)
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
        yezhuView = UIView.init(frame: CGRect(x: 0, y: 64, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - 64))
        self.view.addSubview(yezhuView)
        
        let yezhuBottomView = UIView.init(frame: CGRect(x: 0, y: PhoneUtils.kScreenHeight - 50 * 2 - 64, width: PhoneUtils.kScreenWidth, height: 50))
        yezhuBottomView.backgroundColor = UIColor.white
        yezhuView.addSubview(yezhuBottomView)
        
        let buttonWidth = (PhoneUtils.kScreenWidth - 5 * 4) / 3
        let buttonHeight = yezhuBottomView.frame.size.height - 5 * 2
        
        let calRoomButton = GFJBottomButton.init(type: UIButtonType.custom)
        calRoomButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        calRoomButton.setTitle("屋顶评估", for: UIControlState.normal)
        calRoomButton.backgroundColor = Colors.installColor
        calRoomButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        calRoomButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        calRoomButton.addTarget(self, action: #selector(self.calRoomButtonClicked), for: UIControlEvents.touchUpInside)
        yezhuBottomView.addSubview(calRoomButton)
        
        let soldRoomButton = GFJBottomButton.init(type: UIButtonType.custom)
        soldRoomButton.frame = CGRect(x: 5 * 2 + buttonWidth, y: 5, width: buttonWidth, height: buttonHeight)
        soldRoomButton.setTitle("屋顶出租", for: UIControlState.normal)
        soldRoomButton.backgroundColor = Colors.installColor
        soldRoomButton.addTarget(self, action: #selector(self.soldRoomButtonClicked), for: UIControlEvents.touchUpInside)
        soldRoomButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        soldRoomButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        soldRoomButton.layer.borderColor = Colors.installColor.cgColor
        soldRoomButton.layer.borderWidth = 0.5
        yezhuBottomView.addSubview(soldRoomButton)
        
        let mapAreaButton = GFJBottomButton.init(type: UIButtonType.custom)
        mapAreaButton.frame = CGRect(x: 5 * 3 + buttonWidth * 2, y: 5, width: buttonWidth, height: buttonHeight)
        mapAreaButton.setTitle("屋顶地图", for: UIControlState.normal)
        mapAreaButton.backgroundColor = Colors.installColor
        mapAreaButton.addTarget(self, action: #selector(self.mapAreaButtonClicked), for: UIControlEvents.touchUpInside)
        mapAreaButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        mapAreaButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        mapAreaButton.layer.borderColor = Colors.installColor.cgColor
        mapAreaButton.layer.borderWidth = 0.5
        yezhuBottomView.addSubview(mapAreaButton)
        
        let offSetY : CGFloat = 8
        let scrollViewWidth = PhoneUtils.kScreenWidth
        let scrollViewHeight = offSetY + (520 * scrollViewWidth) / 750
        
        let footerView = UIView.init(frame: CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight + 15))
        
        let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight))
        let images = ["ic_test_ad001", "ic_test_ad002", "ic_test_ad003", "ic_test_ad004"]
        
        scrollView.contentSize = CGSize(width: scrollViewWidth * CGFloat(images.count), height: 0)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        footerView.addSubview(scrollView)
        
        for i in 0..<images.count {
            let imageView = UIImageView.init(frame: CGRect(x: CGFloat(i) * scrollViewWidth, y: offSetY, width: scrollViewWidth, height: scrollViewHeight))
            imageView.image = UIImage(named: images[i])
            scrollView.addSubview(imageView)
        }
        
        yezhuPageControl = UIPageControl.init(frame: CGRect(x: 0, y: footerView.frame.size.height - 20 - 15, width: scrollView.frame.size.width, height: 20))
        yezhuPageControl.numberOfPages = images.count
        footerView.addSubview(yezhuPageControl)
        
        let tableViewHeight = yezhuBottomView.frame.minY
        yezhuTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: yezhuView.frame.size.width, height: tableViewHeight), style: UITableViewStyle.plain)
        yezhuTableView.delegate = self
        yezhuTableView.dataSource = self
        yezhuTableView.backgroundColor = Colors.bkgColor
        yezhuTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        yezhuView.addSubview(yezhuTableView)
        
        yezhuTableView.tableHeaderView = footerView
        
        yezhuTableView.register(YeZhuCell.self, forCellReuseIdentifier: yezhuCellReuseIdentifier)
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
        let vc = MoreInstallerViewController(nibName: "MoreInstallerViewController", bundle: nil)
        self.pushViewController(vc)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yezhuArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return YeZhuCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: yezhuCellReuseIdentifier, for: indexPath as IndexPath) as! YeZhuCell
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
        cell.viewMoreButton.addTarget(self, action: #selector(self.viewMoreButtonClicked), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    func viewMoreButtonClicked() {
        let vc = MoreInstallerViewController(nibName: "MoreInstallerViewController", bundle: nil)
        self.pushViewController(vc)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        yezhuPageControl.currentPage = Int(page)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: false)
        if (shouldShowLogin()) {
            return
        }
        let userInfo = yezhuArray[indexPath.row] as! InstallInfo
        let vc = InstallerDetailOldViewController(nibName: "InstallerDetailOldViewController", bundle: nil)
        vc.installer_id = userInfo.user_id!
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
