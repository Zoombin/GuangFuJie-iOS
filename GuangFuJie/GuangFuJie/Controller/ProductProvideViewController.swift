//
//  ProductProvideViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/9/8.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class ProductProvideViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var newsArray = NSMutableArray()
    var productTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        loadBrandList()
    }
    
    let cellIdentifier = "NewsCell"
    func initView() {
        self.title = "产品供求"
        productTableView = UITableView.init(frame: CGRect(x: 0, y: self.navigationBarAndStatusBarHeight(), width: YCPhoneUtils.screenWidth, height: YCPhoneUtils.screenHeight - self.navigationBarAndStatusBarHeight()))
        productTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        productTableView.delegate = self
        productTableView.dataSource = self
        self.view.addSubview(productTableView)
        productTableView.register(BrandCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    func loadBrandList() {
        self.showHud(in: self.view, hint: "加载中...")
        API.sharedInstance.brandList(start: 0, pagesize: 10, success: { (count, array) in
            self.hideHud()
            self.newsArray.removeAllObjects()
            if (array.count > 0) {
                self.newsArray.addObjects(from: array as! [Any])
            }
            self.productTableView.reloadData()
        }) { (msg) in
            self.hideHud()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BrandCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let data = self.newsArray.object(at: indexPath.row) as! BrandInfo
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NewsListViewController") as! NewsListViewController
        vc.title = YCStringUtils.getString(data.name)
        vc.type = data.type_id
        vc.isProduct = true
        vc.webSite = YCStringUtils.getString(data.website)
        self.pushViewController(vc)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.newsArray.object(at: indexPath.row) as! BrandInfo
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! BrandCell
        cell.initCell()
        cell.setData(brandInfo: data)
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
