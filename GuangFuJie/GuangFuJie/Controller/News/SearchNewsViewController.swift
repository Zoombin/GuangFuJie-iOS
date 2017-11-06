//
//  SearchNewsViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/11/6.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class SearchNewsViewController: BaseViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var pageSize = 10
    var currentPage = 0
    var newsArray = NSMutableArray()
    var key: String?
    
    var hotSearchLabel: UILabel!
    var keyWord1Button: UIButton!
    var keyWord2Button: UIButton!
    var keyWord3Button: UIButton!
    var historyLabel: UILabel!
    var historyWord1Button: UIButton!
    
    var newsListTableView: UITableView!
    let times = YCPhoneUtils.screenWidth / 375
    let cellReuseIdentifier = "cellReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        self.title = "搜索资讯"
        self.view.backgroundColor = UIColor.white
        
        let searchTextField = UITextField.init(frame: CGRect(x: 10 * times, y: 10 * times + self.navigationBarAndStatusBarHeight(), width: 290 * times, height: 35 * times))
        searchTextField.backgroundColor = Colors.bkgColor
        searchTextField.layer.cornerRadius = searchTextField.frame.size.height / 2
        searchTextField.layer.masksToBounds = true
        searchTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        searchTextField.placeholder = "光伏补贴"
        searchTextField.delegate = self
        searchTextField.leftViewMode = UITextFieldViewMode.always
        searchTextField.tintColor = UIColor.clear
        searchTextField.returnKeyType = UIReturnKeyType.search
        self.view.addSubview(searchTextField)
        
        let leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 35 * times, height: 35 * times))
        
        let leftIconImage = UIImageView.init(frame: CGRect(x: 10 * times, y: 7.5 * times, width: 20 * times, height: 20 * times))
        leftIconImage.image = UIImage(named: "ic_home_search")
        leftView.addSubview(leftIconImage)
        
        searchTextField.leftView = leftView
        
        let cancelButton = UIButton.init(type: .custom)
        cancelButton.frame = CGRect(x: searchTextField.frame.maxX, y: searchTextField.frame.minY, width: 75 * times, height: 35 * times)
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        cancelButton.backgroundColor = UIColor.white
        cancelButton.addTarget(self, action: #selector(self.cancelButtonClicked), for: UIControlEvents.touchUpInside)
        self.view.addSubview(cancelButton)
        
        hotSearchLabel = UILabel.init(frame: CGRect(x: 0, y: cancelButton.frame.maxY + 20 * times, width: 100, height: 30))
        hotSearchLabel.text = "  热门搜索"
        self.addLeftLine(view: hotSearchLabel)
        hotSearchLabel.font = UIFont.systemFont(ofSize: 17)
        self.view.addSubview(hotSearchLabel)
        
        keyWord1Button = UIButton.init(type: UIButtonType.custom)
        keyWord1Button.frame = CGRect(x: 0, y: hotSearchLabel.frame.maxY, width: 110, height: 30)
        keyWord1Button.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        keyWord1Button.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        keyWord1Button.setTitle("最新补贴政策", for: UIControlState.normal)
        keyWord1Button.tag = 0
        keyWord1Button.addTarget(self, action: #selector(self.keyButtonClick(btn:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(keyWord1Button)
        
        keyWord2Button = UIButton.init(type: UIButtonType.custom)
        keyWord2Button.frame = CGRect(x: keyWord1Button.frame.maxX, y: hotSearchLabel.frame.maxY, width: 110, height: 30)
        keyWord2Button.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        keyWord2Button.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        keyWord2Button.setTitle("怎么安装电站", for: UIControlState.normal)
        keyWord2Button.tag = 1
        keyWord2Button.addTarget(self, action: #selector(self.keyButtonClick(btn:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(keyWord2Button)
        
        keyWord3Button = UIButton.init(type: UIButtonType.custom)
        keyWord3Button.frame = CGRect(x: keyWord2Button.frame.maxX, y: hotSearchLabel.frame.maxY, width: 95, height: 30)
        keyWord3Button.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        keyWord3Button.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        keyWord3Button.setTitle("光伏贷款", for: UIControlState.normal)
        keyWord3Button.tag = 3
        keyWord3Button.addTarget(self, action: #selector(self.keyButtonClick(btn:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(keyWord3Button)
        
        historyLabel = UILabel.init(frame: CGRect(x: 0, y: keyWord3Button.frame.maxY + 20 * times, width: 100, height: 30))
        historyLabel.text = "  搜索历史"
        self.addLeftLine(view: historyLabel)
        historyLabel.font = UIFont.systemFont(ofSize: 17)
        self.view.addSubview(historyLabel)
        
        historyWord1Button = UIButton.init(type: UIButtonType.custom)
        historyWord1Button.frame = CGRect(x: 0, y: historyLabel.frame.maxY, width: 110, height: 30)
        historyWord1Button.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        historyWord1Button.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        historyWord1Button.setTitle("暂无搜索历史", for: UIControlState.normal)
        self.view.addSubview(historyWord1Button)
        
        newsListTableView = UITableView.init(frame: CGRect(x: 0, y:  searchTextField.frame.maxY + 5 * times, width: YCPhoneUtils.screenWidth, height: YCPhoneUtils.screenHeight - searchTextField.frame.maxY + 5 * times), style: UITableViewStyle.plain)
        newsListTableView.delegate = self
        newsListTableView.dataSource = self
        newsListTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        newsListTableView.backgroundColor = UIColor.clear
        self.view.addSubview(newsListTableView)
    
        newsListTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMore))
        newsListTableView.register(NewsV2Cell.self, forCellReuseIdentifier: cellReuseIdentifier)
        newsListTableView.isHidden = true
    }
    
    func hideAllIcons() {
        hotSearchLabel.isHidden = true
        keyWord1Button.isHidden = true
        keyWord2Button.isHidden = true
        keyWord3Button.isHidden = true
        historyLabel.isHidden = true
        historyWord1Button.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        key = textField.text!
        loadData()
        return true
    }
    
    func cancelButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func keyButtonClick(btn: UIButton) {
        if (btn.tag == 0) {
            key = "政策"
        } else if (btn.tag == 1) {
            key = "安装"
        } else {
            key = "贷款"
        }
        loadData()
    }
    
    func addLeftLine(view: UIView) {
        let leftBorder = CALayer()
        let height = view.frame.size.height
        let width = 3 * times
        leftBorder.frame = CGRect(x: 0, y: height * 0.1, width: width, height: height * 0.8);
        leftBorder.backgroundColor = UIColor.red.cgColor
        view.layer.addSublayer(leftBorder)
    }
    
    func loadMore() {
        currentPage = currentPage + 1
        getNewsList()
    }
    
    func loadData() {
        hideAllIcons()
        newsListTableView.isHidden = false
        currentPage = 0
        self.newsListTableView.mj_footer.isHidden = false
        self.showHud(in: self.view, hint: "加载中...")
        getNewsList()
    }
    
    func getNewsList() {
        API.sharedInstance.articlesList(currentPage, pagesize: pageSize, key: key, provinceId: nil, cityId: nil, areaId: nil, type: nil, success: { (count, array) in
            if (self.currentPage == 0) {
                //self.newsTableView.mj_header.endRefreshing()
                self.hideHud()
                self.newsArray.removeAllObjects()
            } else {
                self.newsListTableView.mj_footer.endRefreshing()
            }
            if (array.count > 0) {
                self.newsArray.addObjects(from: array as [AnyObject])
            }
            if (array.count < self.pageSize) {
                self.newsListTableView.mj_footer.isHidden = true
            }
            self.newsListTableView.reloadData()
        }) { (msg) in
            self.newsListTableView.mj_footer.endRefreshing()
            //self.newsTableView.mj_header.endRefreshing()
            self.hideHud()
            self.showHint(msg)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
