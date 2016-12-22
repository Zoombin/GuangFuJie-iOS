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
        safeView = UIView.init(frame: CGRect(x: 0, y: topMenuView.frame.maxY, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - topMenuView.frame.size.height - 64))
        self.view.addSubview(safeView)
        
        let safeViewBottomView = UIView.init(frame: CGRect(x: 0, y: safeView.frame.size.height - 50, width: PhoneUtils.kScreenWidth, height: 50))
        safeViewBottomView.backgroundColor = UIColor.white
        safeView.addSubview(safeViewBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = safeViewBottomView.frame.size.height - 5 * 2
        
        let safeButton = GFJBottomButton.init(type: UIButtonType.custom)
        safeButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        safeButton.setTitle("立即购买", for: UIControlState.normal)
        safeButton.backgroundColor = Colors.installColor
        safeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        safeButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        safeButton.addTarget(self, action: #selector(self.buySafeNow), for: UIControlEvents.touchUpInside)
        safeViewBottomView.addSubview(safeButton)
        
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
        
        safePageControl = UIPageControl.init(frame: CGRect(x: 0, y: footerView.frame.size.height - 20 - 15, width: scrollView.frame.size.width, height: 20))
        safePageControl.numberOfPages = images.count
        footerView.addSubview(safePageControl)
        
        let tableViewHeight = safeViewBottomView.frame.minY
        safeTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: safeView.frame.size.width, height: tableViewHeight), style: UITableViewStyle.plain)
        safeTableView.delegate = self
        safeTableView.dataSource = self
        safeTableView.backgroundColor = Colors.bkgColor
        safeTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        safeView.addSubview(safeTableView)
        
        safeTableView.tableHeaderView = footerView
        
        safeTableView.register(SafeCell.self, forCellReuseIdentifier: safeCellReuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return safeArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SafeCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: safeCellReuseIdentifier, for: indexPath as IndexPath) as! SafeCell
        cell.initCell()
        let userInfo = safeArray[indexPath.row] as! InsuranceInfo
        cell.setData(userInfo, isSelf: false)
        cell.viewMoreButton.addTarget(self, action: #selector(self.viewMoreSafeList), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    func viewMoreSafeList() {
        let vc = MoreSafeViewController()
        self.pushViewController(vc)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: false)
    }
    
    func loadSafeList() {
//        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.usersHaveInsuranceList(0, pagesize: 10, is_suggest: 1, success: { (insuranceList) in
            self.hideHud()
            self.safeArray.removeAllObjects()
            if (insuranceList.count > 0) {
                self.safeArray.add(insuranceList.firstObject!)
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
