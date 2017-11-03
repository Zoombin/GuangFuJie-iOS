//
//  ExperienceShopViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/9/9.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class ExperienceShopViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var newsTableView: UITableView!
    let cellReuseIdentifier = "cellReuseIdentifier"
    let newsArray = NSMutableArray()
    let times = YCPhoneUtils.screenWidth / 375
    var topView: UIView!
    
    var hotButton: UIButton!
    var newButton: UIButton!
    var niceButton: UIButton!
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "体验店"
        initTopView()
        initView()
        loadBroadCastList()
    }
    
    func initTopView() {
        topView = UIView.init(frame: CGRect(x: 0, y: self.navigationBarAndStatusBarHeight(), width: YCPhoneUtils.screenWidth, height: 42 * times))
        topView.backgroundColor = UIColor.white
        self.view.addSubview(topView)
        
        let titles = ["品牌街咨询", "店面展示", "品牌街支持"]
        let btnWidth = YCPhoneUtils.screenWidth / 3
        for i in 0..<titles.count {
            let btn = UIButton.init(type: UIButtonType.custom)
            btn.frame = CGRect(x: CGFloat(i) * btnWidth, y: 0, width: btnWidth, height: topView.frame.size.height)
            btn.setTitle(titles[i], for: UIControlState.normal)
            btn.setTitleColor(Colors.appBlue, for: UIControlState.selected)
            btn.setTitleColor(UIColor.black, for: UIControlState.normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
            btn.tag = i
            btn.addTarget(self, action: #selector(self.topButtonClicked(button:)), for: UIControlEvents.touchUpInside)
            self.addBottomLine(view: btn, color: i == 0 ? Colors.appBlue : UIColor.white)
            topView.addSubview(btn)
            
            if (i == 0) {
                btn.isSelected = true
                hotButton = btn
            } else if (i == 1) {
                newButton = btn
            } else {
                niceButton = btn
            }
        }
    }
    
    func topButtonClicked(button: UIButton) {
        resetAllBottomColors()
        if (button.tag == 0) {
            currentIndex = 0
            let bottomLayer = hotButton.layer.sublayers![1]
            bottomLayer.backgroundColor = Colors.appBlue.cgColor
            hotButton.isSelected = true
        } else if (button.tag == 1) {
            currentIndex = 1
            let bottomLayer = newButton.layer.sublayers![1]
            bottomLayer.backgroundColor = Colors.appBlue.cgColor
            newButton.isSelected = true
        } else {
            currentIndex = 2
            let bottomLayer = niceButton.layer.sublayers![1]
            bottomLayer.backgroundColor = Colors.appBlue.cgColor
            niceButton.isSelected = true
        }
        loadBroadCastList()
    }
    
    func addBottomLine(view: UIView, color: UIColor) {
        let bottomBorder = CALayer()
        let height = view.frame.size.height - 2.0
        let width = view.frame.size.width
        bottomBorder.frame = CGRect(x: 0, y: height, width: width, height: 2)
        bottomBorder.backgroundColor = color.cgColor
        view.layer.addSublayer(bottomBorder)
    }
    
    func resetAllBottomColors() {
        hotButton.isSelected = false
        newButton.isSelected = false
        niceButton.isSelected = false
        if (hotButton.layer.sublayers!.count > 0 && newButton.layer.sublayers!.count > 0 && niceButton.layer.sublayers!.count > 0) {
            let bottomLayer1 = hotButton.layer.sublayers![1]
            bottomLayer1.backgroundColor = UIColor.white.cgColor
            
            let bottomLayer2 = newButton.layer.sublayers![1]
            bottomLayer2.backgroundColor = UIColor.white.cgColor
            
            let bottomLayer3 = niceButton.layer.sublayers![1]
            bottomLayer3.backgroundColor = UIColor.white.cgColor
        }
    }
    
    func loadBroadCastList() {
        var type = 0
        if (currentIndex == 0) {
            type = 27
        } else if (currentIndex == 1) {
            type = 13
        } else {
            type = 28
        }
        API.sharedInstance.articlesList(0, pagesize: 10, key: nil, provinceId: nil, cityId: nil, areaId: nil, type: NSNumber.init(value: type), success: { (count, array) in
            self.hideHud()
            self.newsArray.removeAllObjects()
            if (array.count > 0) {
                self.newsArray.addObjects(from: array as [AnyObject])
            }
            self.newsTableView.reloadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    func initView() {
        newsTableView = UITableView.init(frame: CGRect(x: 0, y: topView.frame.maxY, width: YCPhoneUtils.screenWidth, height: YCPhoneUtils.screenHeight - self.navigationBarAndStatusBarHeight() - topView.frame.size.height), style: UITableViewStyle.plain)
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.backgroundColor = Colors.bkgColor
        newsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(newsTableView)
        
        newsTableView.register(NewsV2Cell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsV2Cell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.newsArray.object(at: indexPath.row) as! ArticleInfo
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! NewsV2Cell
        cell.setData(model: data)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = self.newsArray.object(at: indexPath.row) as! ArticleInfo
        
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
    
}
