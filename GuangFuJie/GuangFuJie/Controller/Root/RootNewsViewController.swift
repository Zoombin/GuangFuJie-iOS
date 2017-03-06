//
//  RootNewsViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/2/22.
//  Copyright © 2017年 颜超. All rights reserved.
//

import UIKit

class RootNewsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var newsArray = NSMutableArray()
    var newsTableView: UITableView!
    
    var pageSize = 10
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Texts.tab5
        initView()
        loadData()
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
        API.sharedInstance.newsList(currentPage, pagesize: pageSize, success: { (count, array) in
            if (self.currentPage == 0) {
                self.newsTableView.mj_header.endRefreshing()
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
            self.newsTableView.mj_header.endRefreshing()
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    let cellReuseIdentifier = "deviceCellReuseIdentifier"
    func initView() {
        newsTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - 50), style: UITableViewStyle.plain)
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.backgroundColor = Colors.bkgColor
        newsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(newsTableView)
        
        newsTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.loadData))
        newsTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMore))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cellIdentifier"
        let data = self.newsArray.object(at: indexPath.row) as! NewsInfo
        let cell = NewsCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        cell.setData(model: data)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let data = self.newsArray.object(at: indexPath.row) as! NewsInfo
        let vc = GFJWebViewController()
        vc.url = StringUtils.getString(data.link)
        vc.title = "资讯"
        self.pushViewController(vc)
    }
    
}
