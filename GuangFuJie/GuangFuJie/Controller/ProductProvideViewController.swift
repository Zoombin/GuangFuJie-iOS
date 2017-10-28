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
    
    func initView() {
        self.title = "产品供求"
        productTableView = UITableView.init(frame: CGRect(x: 0, y: self.navigationBarAndStatusBarHeight(), width: YCPhoneUtils.screenWidth, height: YCPhoneUtils.screenHeight - self.navigationBarAndStatusBarHeight()))
        productTableView.delegate = self
        productTableView.dataSource = self
        self.view.addSubview(productTableView)
    }
    
    func loadBrandList() {
        self.showHud(in: self.view, hint: "加载中...")
        API.sharedInstance.brandList(start: 0, pagesize: 10, success: { (count, array) in
            self.newsArray.removeAllObjects()
            if (array.count > 0) {
                self.newsArray.addObjects(from: array)
            }
            self.productTableView.reloadData()
        }) { (msg) in
            
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
