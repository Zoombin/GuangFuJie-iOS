//
//  InstallerSearchResultViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/3/14.
//  Copyright © 2017年 颜超. All rights reserved.
//

import UIKit

class InstallerSearchResultViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var searchArray = NSMutableArray()
    var newsTableView: UITableView!
    
    var pageSize = 10
    var currentPage = 0
    var searchValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Texts.tab2
        initView()
        loadData()
    }
    
    func loadMore() {
        currentPage = currentPage + 1
        getSearchResult()
    }
    
    func loadData() {
        currentPage = 0
        self.newsTableView.mj_footer.isHidden = false
        self.showHud(in: self.view, hint: "加载中...")
        getSearchResult()
    }
    
    func getSearchResult() {
        API.sharedInstance.searchInstaller(currentPage, pagesize: pageSize, searchValue: searchValue, success: { (count, array) in
            if (self.currentPage == 0) {
                self.newsTableView.mj_header.endRefreshing()
                self.hideHud()
                self.searchArray.removeAllObjects()
            } else {
                self.newsTableView.mj_footer.endRefreshing()
            }
            if (array.count > 0) {
                self.searchArray.addObjects(from: array as [AnyObject])
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
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return InstallerResultCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cellIdentifier"
//        let data = self.newsArray.object(at: indexPath.row) as! NewsInfo
        let cell = InstallerResultCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
//        cell.setData(model: data)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        //安装商详情
    }

}
