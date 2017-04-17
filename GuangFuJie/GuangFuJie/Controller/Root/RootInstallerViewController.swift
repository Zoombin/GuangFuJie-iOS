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
        self.title = Texts.tab1
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        //MARK: 如果是root的话必须初始化这三个
        initRightNavButton()
        initLeftNavButton()
        
        initInstallerView()
        
        loadUserList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshButtonStatus()
    }
    
    //MARK: 屋顶列表
    func loadUserList() {
//        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.getRoofList(0, pagesize: 10, province_id: nil, city_id: nil, is_suggest: 1, success: { (userInfos) in
            self.hideHud()
            self.installerArray.removeAllObjects()
            if (userInfos.count > 0) {
                self.installerArray.add(userInfos.firstObject!)
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
        installView = UIView.init(frame: CGRect(x: 0, y: 64, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - 64))
        installView.backgroundColor = UIColor.white
        self.view.addSubview(installView)
        
        let installViewBottomView = UIView.init(frame: CGRect(x: 0, y: PhoneUtils.kScreenHeight - 50 * 2 - 64, width: PhoneUtils.kScreenWidth, height: 50))
        installViewBottomView.backgroundColor = UIColor.white
        installView.addSubview(installViewBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = installViewBottomView.frame.size.height - 5 * 2
        
        installerButton = GFJBottomButton.init(type: UIButtonType.custom)
        installerButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        installerButton.setTitle("申请成为安装商", for: UIControlState.normal)
        installerButton.backgroundColor = Colors.installColor
        installerButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        installerButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        installerButton.addTarget(self, action: #selector(self.wantToBeInstaller), for: UIControlEvents.touchUpInside)
        installViewBottomView.addSubview(installerButton)
        
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
        
        installerPageControl = UIPageControl.init(frame: CGRect(x: 0, y: footerView.frame.size.height - 20 - 15, width: scrollView.frame.size.width, height: 20))
        installerPageControl.numberOfPages = images.count
        footerView.addSubview(installerPageControl)
        
        let tableViewHeight = installViewBottomView.frame.minY
        installTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: tableViewHeight), style: UITableViewStyle.plain)
        installTableView.delegate = self
        installTableView.dataSource = self
        installTableView.backgroundColor = Colors.bkgColor
        installTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        installView.addSubview(installTableView)
        
        installTableView.tableHeaderView = footerView
        
        installTableView.register(InstallerCell.self, forCellReuseIdentifier: installerCellReuseIdentifier)
    }
    
    func refreshButtonStatus() {
        if (!UserDefaultManager.isLogin()) {
            installerButton.setTitle("申请成为安装商", for: UIControlState.normal)
            return
        }
        API.sharedInstance.checkIsInstaller({ (msg, commonModel) in
            if (commonModel.is_installer == 0) {
                self.installerButton.setTitle("申请成为安装商", for: UIControlState.normal)
            } else {
                self.installerButton.setTitle("查看详情", for: UIControlState.normal)
            }
        }) { (msg) in

        }
    }
    
    func wantToBeInstaller() {
        if (shouldShowLogin()) {
            return
        }
        self.showHud(in: self.view, hint: "加载中...")
        API.sharedInstance.checkIsInstaller({ (msg, commonModel) in
            self.hideHud()
            let vc = ToBeInstallerViewController(nibName: "ToBeInstallerViewController", bundle: nil)
            self.pushViewController(vc)
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
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
        cell.viewMoreButton.addTarget(self, action: #selector(self.viewMoreButtonClicked), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    func viewMoreButtonClicked() {
        let vc = GFJRoofListViewController(nibName: "GFJRoofListViewController", bundle: nil)
        self.pushViewController(vc)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        installerPageControl.currentPage = Int(page)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: false)
        if (shouldShowLogin()) {
            return
        }
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
