//
//  InstallerSearchResultViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/3/14.
//  Copyright © 2017年 颜超. All rights reserved.
//

import UIKit

class InstallerSearchResultViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var dir = 10 * (PhoneUtils.kScreenWidth / 750)
    var times = PhoneUtils.kScreenWidth / 750
    
    var searchArray = NSMutableArray()
    var installerTableView: UITableView!
    var searchView = UIView()
    var searchTextField = UITextField()
    
    var pageSize = 10
    var currentPage = 1
    var searchValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Texts.tab2
        
        //TODO: 这句话挺重要
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        initView()
        loadData()
    }
    
    func loadMore() {
        currentPage = currentPage + 1
        getSearchResult()
    }
    
    func loadData() {
        currentPage = 1
        self.installerTableView.mj_footer.isHidden = false
        self.showHud(in: self.view, hint: "加载中...")
        getSearchResult()
    }
    
    func getSearchResult() {
        API.sharedInstance.searchInstaller(currentPage, pagesize: pageSize, searchValue: searchValue, success: { (count, array) in
            if (self.currentPage == 1) {
                self.installerTableView.mj_header.endRefreshing()
                self.hideHud()
                self.searchArray.removeAllObjects()
            } else {
                self.installerTableView.mj_footer.endRefreshing()
            }
            if (array.count > 0) {
                self.searchArray.addObjects(from: array as [AnyObject])
            }
            if (array.count < self.pageSize) {
                self.installerTableView.mj_footer.isHidden = true
            }
            self.installerTableView.reloadData()
        }) { (msg) in
            self.installerTableView.mj_footer.endRefreshing()
            self.installerTableView.mj_header.endRefreshing()
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    let cellReuseIdentifier = "deviceCellReuseIdentifier"
    func initView() {
        initSearchView()
        
        installerTableView = UITableView.init(frame: CGRect(x: 0, y: searchView.frame.maxY, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - 64 - searchView.frame.size.height), style: UITableViewStyle.plain)
        installerTableView.delegate = self
        installerTableView.dataSource = self
        installerTableView.backgroundColor = Colors.bkgColor
        installerTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(installerTableView)
        
        installerTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.loadData))
        installerTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMore))
    }
    
    func initSearchView() {
        searchView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 80 * times))
        searchView.backgroundColor = UIColor.white
        self.view.addSubview(searchView)
        
        let searchLeft = UIButton.init(frame: CGRect(x: 0, y: 0, width: (80 * times) * 0.8, height: (80 * times) * 0.8))
        searchLeft.setImage(UIImage(named: "ic_installer_search"), for: UIControlState.normal)
        
        searchTextField.frame = CGRect(x: dir * 4, y: (80 * times) * 0.1, width: (PhoneUtils.kScreenWidth - 6 * dir) - (80 * times) * 1.3, height: (80 * times) * 0.8)
        searchTextField.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        searchTextField.leftView = searchLeft
        searchTextField.leftViewMode = UITextFieldViewMode.always
        searchTextField.backgroundColor = UIColor.white
        searchTextField.returnKeyType = UIReturnKeyType.search
        searchTextField.delegate = self
        searchTextField.text = searchValue
        searchTextField.placeholder = "请输入安装商企业名称"
        searchTextField.clearButtonMode = UITextFieldViewMode.whileEditing
        searchView.addSubview(searchTextField)
        
        let searchRight = UIButton.init(frame: CGRect(x: searchTextField.frame.maxX + (80 * times) * 0.1, y: (80 * times) * 0.2, width: (80 * times) * 1.2, height: (80 * times) * 0.6))
        searchRight.setTitle("搜索", for: UIControlState.normal)
        searchRight.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        searchRight.addTarget(self, action: #selector(self.topSearchButtonClicked), for: UIControlEvents.touchUpInside)
        searchRight.backgroundColor = Colors.installColor
        searchView.addSubview(searchRight)
        
        let line = UILabel.init(frame: CGRect(x: searchTextField.frame.minX, y: searchTextField.frame.maxY, width: searchTextField.frame.size.width - dir, height: 0.5))
        line.backgroundColor = UIColor.lightGray
        searchView.addSubview(line)
    }
    
    func topSearchButtonClicked() {
        searchValue = StringUtils.getString(searchTextField.text)
        self.loadData()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.topSearchButtonClicked()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        topSearchButtonClicked()
        return true
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
        let data = self.searchArray.object(at: indexPath.row) as! InstallInfo
        let cell = InstallerResultCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        cell.setData(model: data)
        cell.rzLabel.addTarget(self, action: #selector(self.wantToBeInstaller), for: UIControlEvents.touchUpInside)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let data = self.searchArray.object(at: indexPath.row) as! InstallInfo
        let vc = InstallerDetailViewController()
        vc.installerInfo = data
        self.pushViewController(vc)
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

}
