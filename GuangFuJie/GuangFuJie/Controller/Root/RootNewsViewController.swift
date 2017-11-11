//
//  RootNewsViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/6.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootNewsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ProviceCityViewDelegate {
    var newsArray = NSMutableArray()
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    @IBOutlet weak var line4: UIView!
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    
    var index = 0
    
    var pageSize = 10
    var currentPage = 0
    var type = 16
    
    var cellReuseIdentifier = "cellReuseIdentifier"
    var provinceId: NSNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "政策资讯"
        
        //newsTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.loadData))
        newsTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMore))
        newsTableView.register(NewsV2Cell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshLocation), name: NSNotification.Name(rawValue: "RefreshLocation"), object: nil)
        self.getCurrentLocation()
        
        if (index == 0) {
            self.topButtonClicked(firstButton)
        } else if (index == 1) {
            self.topButtonClicked(secondButton)
        } else if (index == 2) {
            self.topButtonClicked(thirdButton)
        } else if (index == 3) {
            self.topButtonClicked(fourthButton)
        }
    }
    
    func refreshLocation() {
        if (UserDefaultManager.getLocation() != nil) {
            let location = UserDefaultManager.getLocation()
            locationButton.setTitle("\(YCStringUtils.getString(location!.city_name))\(YCStringUtils.getString(location!.area_name))", for: UIControlState.normal)
            provinceId = location!.province_id
            getNewsList()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = nil
    }
    
    @IBAction func locationSetting() {
        let vc = ProviceCityViewController()
        vc.delegate = self
        
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func proviceAndCity(_ provice: ProvinceModel, city: CityModel, area: AreaModel) {
        provinceId = provice.province_id
        locationButton.setTitle("\(YCStringUtils.getString(provice.name))\(YCStringUtils.getString(city.name))", for: UIControlState.normal)
        
        loadData()
    }
    
    func hideAllLine() {
        line1.isHidden = true
        line2.isHidden = true
        line3.isHidden = true
        line4.isHidden = true
    }
    
    @IBAction func topButtonClicked(_ sender: UIButton) {
        hideAllLine()
        if (sender.tag == 0) {
            type = 16
            line1.isHidden = false
        } else if (sender.tag == 1) {
            type = 15
            line2.isHidden = false
        } else if (sender.tag == 2) {
            type = 17
            line3.isHidden = false
        } else {
            type = 18
            line4.isHidden = false
        }
        loadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let vc = SearchNewsViewController()
        self.pushViewController(vc)
    }
    
    @IBAction func searchButtonClicked() {
        let vc = SearchNewsViewController()
        self.pushViewController(vc)
    }
    
    func loadMore() {
        currentPage = currentPage + 1
        getNewsList()
    }
    
    func loadData() {
        currentPage = 0
        self.newsTableView.mj_footer.isHidden = false
        self.showHud(in: self.view, hint: "加载中...")
        getNewsList()
    }
    
    func getNewsList() {
        API.sharedInstance.articlesList(currentPage, pagesize: pageSize, key: nil, provinceId: provinceId, cityId: nil, areaId: nil, type: NSNumber.init(value: type), success: { (count, array) in
            if (self.currentPage == 0) {
                //self.newsTableView.mj_header.endRefreshing()
                self.hideHud()
                self.newsArray.removeAllObjects()
            } else {
                self.newsTableView.mj_footer.endRefreshing()
            }
            if (array.count > 0) {
                self.newsArray.addObjects(from: array as [AnyObject])
            }
            if (array.count < self.pageSize) {
                self.newsTableView.mj_footer.isHidden = true
            }
            self.newsTableView.reloadData()
        }) { (msg) in
            self.newsTableView.mj_footer.endRefreshing()
            //self.newsTableView.mj_header.endRefreshing()
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.navigationController?.tabBarItem.selectedImage = self.tabBarItem.selectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsV2Cell.cellHeight()
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
        vc.title = "资讯"
        vc.addShareInfoButton(info: shareInfo)
        self.pushViewController(vc)
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
