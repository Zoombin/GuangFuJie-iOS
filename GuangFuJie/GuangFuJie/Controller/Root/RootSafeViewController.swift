//
//  RootSafeViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/3.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

//保险
class RootSafeViewController: BaseViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    var safeView : UIView!
    var safeTableView : UITableView!
    var safePageControl : UIPageControl!
    
    var safeArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        showTopMenu(self.tabBarController!.selectedIndex)
        initRightNavButton()
        initLeftNavButton()
        initLoginView()
        
        initSafeView()
        loadSafeList()
    }
    
    //MARK: 保险
    let safeCellReuseIdentifier = "safeCellReuseIdentifier"
    func initSafeView() {
        safeView = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(topMenuView.frame), PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - topMenuView.frame.size.height - 64))
        self.view.addSubview(safeView)
        
        let safeViewBottomView = UIView.init(frame: CGRectMake(0, safeView.frame.size.height - 50, PhoneUtils.kScreenWidth, 50))
        safeViewBottomView.backgroundColor = UIColor.whiteColor()
        safeView.addSubview(safeViewBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = safeViewBottomView.frame.size.height - 5 * 2
        
        let safeButton = UIButton.init(type: UIButtonType.Custom)
        safeButton.frame = CGRectMake(5, 5, buttonWidth, buttonHeight)
        safeButton.setTitle("立即购买", forState: UIControlState.Normal)
        safeButton.backgroundColor = Colors.installColor
        safeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        safeButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge2)
        safeButton.addTarget(self, action: #selector(self.buySafeNow), forControlEvents: UIControlEvents.TouchUpInside)
        safeViewBottomView.addSubview(safeButton)
        
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
        
        safePageControl = UIPageControl.init(frame: CGRectMake(0, footerView.frame.size.height - 20 - 15, scrollView.frame.size.width, 20))
        safePageControl.numberOfPages = images.count
        footerView.addSubview(safePageControl)
        
        let tableViewHeight = CGRectGetMinY(safeViewBottomView.frame)
        safeTableView = UITableView.init(frame: CGRectMake(0, 0, safeView.frame.size.width, tableViewHeight), style: UITableViewStyle.Plain)
        safeTableView.delegate = self
        safeTableView.dataSource = self
        safeTableView.backgroundColor = Colors.bkgColor
        safeTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        safeView.addSubview(safeTableView)
        
        safeTableView.tableHeaderView = footerView
        
        safeTableView.registerClass(SafeCell.self, forCellReuseIdentifier: safeCellReuseIdentifier)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return safeArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SafeCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(safeCellReuseIdentifier, forIndexPath: indexPath) as! SafeCell
        cell.initCell()
        let userInfo = safeArray[indexPath.row] as! InsuranceInfo
        cell.setData(userInfo, isSelf: false)
        cell.viewMoreButton.addTarget(self, action: #selector(self.viewMoreSafeList), forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    func viewMoreSafeList() {
        let vc = MoreSafeViewController()
        self.pushViewController(vc)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func loadSafeList() {
        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.usersHaveInsuranceList(0, pagesize: 10, is_suggest: 1, success: { (insuranceList) in
            self.hideHud()
            self.safeArray.removeAllObjects()
            if (insuranceList.count > 0) {
                self.safeArray.addObject(insuranceList.firstObject!)
            }
            self.safeTableView.reloadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    func buySafeNow() {
        if (shouldShowLogin()) {
            return
        }
        let vc = BuySafeViewController()
        self.pushViewController(vc)
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
