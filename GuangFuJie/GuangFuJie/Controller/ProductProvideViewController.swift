//
//  ProductProvideViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/9/8.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class ProductProvideViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var pageSize = 10
    var currentPage = 0
    var newsArray = NSMutableArray()
    var key: String?
    var type: NSNumber?
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    
    @IBOutlet weak var newsListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = 20
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        self.title = "产品供求"
        newsListTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMore))
        getNewsList()
    }
    
    func loadMore() {
        currentPage = currentPage + 1
        getNewsList()
    }
    
    func hideAllLine() {
        line1.isHidden = true
        line2.isHidden = true
    }
    
    @IBAction func topButtonClicked(_ sender: UIButton) {
        hideAllLine()
        if (sender.tag == 0) {
            type = 20
            line1.isHidden = false
        } else if (sender.tag == 1) {
            type = 19
            line2.isHidden = false
        }
        loadData()
    }
    
    func loadData() {
        currentPage = 0
        self.newsListTableView.mj_footer.isHidden = false
        self.showHud(in: self.view, hint: "加载中...")
        getNewsList()
    }
    
    func getNewsList() {
        API.sharedInstance.articlesList(currentPage, pagesize: pageSize, key: key, provinceId: nil, cityId: nil, areaId: nil, type: type, success: { (count, array) in
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NewsCell"
        let data = self.newsArray.object(at: indexPath.row) as! ArticleInfo
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NewsCell
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
