//
//  RootNewsViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/6.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootNewsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var newsArray = NSMutableArray()
    @IBOutlet weak var newsTableView: UITableView!
    
    var pageSize = 10
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "政策资讯"
        
        //newsTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.loadData))
        newsTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMore))
        
        getNewsList()
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
        API.sharedInstance.articlesList(currentPage, pagesize: pageSize, key: nil, provinceId: nil, cityId: nil, areaId: nil, type: 1, success: { (count, array) in
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
//        API.sharedInstance.newsList(currentPage, pagesize: pageSize, success: { (count, array) in
//            if (self.currentPage == 0) {
//                //self.newsTableView.mj_header.endRefreshing()
//                self.hideHud()
//                self.newsArray.removeAllObjects()
//            } else {
//                self.newsTableView.mj_footer.endRefreshing()
//            }
//            if (array.count > 0) {
//                self.newsArray.addObjects(from: array as [AnyObject])
//            }
//            if (array.count < self.pageSize) {
//                self.newsTableView.mj_footer.isHidden = true
//            }
//            self.newsTableView.reloadData()
//        }) { (msg) in
//            self.newsTableView.mj_footer.endRefreshing()
//            //self.newsTableView.mj_header.endRefreshing()
//            self.hideHud()
//            self.showHint(msg)
//        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let data = self.newsArray.object(at: indexPath.row) as! NewsInfo
        
        let shareInfo = ShareInfo()
        shareInfo.shareImg = StringUtils.getString(data.titleImage)
        shareInfo.shareTitle = StringUtils.getString("新闻资讯")
        shareInfo.shareDesc = StringUtils.getString(data.intro)
        shareInfo.shareLink = StringUtils.getString(data.link)
        
        let vc = GFJWebViewController()
        vc.url = StringUtils.getString(data.link)
        vc.title = "资讯"
        vc.addShareInfoButton(info: shareInfo)
        self.pushViewController(vc)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NewsCell"
        let data = self.newsArray.object(at: indexPath.row) as! ArticleInfo
//        let cell = NewsCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
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
