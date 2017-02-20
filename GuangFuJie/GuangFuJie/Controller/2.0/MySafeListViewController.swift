//
//  MySafeListViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/9.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class MySafeListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var safeTableView : UITableView!
    var safeArray : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的保险列表"
        // Do any additional setup after loading the view.
        initView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadUserList()
    }
    
    func loadUserList() {
        self.showHud(in: self.view, hint: "加载中...")
        API.sharedInstance.myInsuranceList({ (insuranceList) in
            self.hideHud()
            self.safeArray.removeAllObjects()
            if (insuranceList.count > 0) {
                self.safeArray.addObjects(from: insuranceList as [AnyObject])
            }
            self.safeTableView.reloadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    let safeCellReuseIdentifier = "safeCellReuseIdentifier"
    func initView() {
        safeTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight), style: UITableViewStyle.plain)
        safeTableView.delegate = self
        safeTableView.dataSource = self
        safeTableView.backgroundColor = Colors.bkgColor
        safeTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(safeTableView)
        
        safeTableView.register(SafeCell.self, forCellReuseIdentifier: safeCellReuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return safeArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SafeCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: safeCellReuseIdentifier, for: indexPath as IndexPath) as! SafeCell
        cell.initCell()
        let userInfo = safeArray[indexPath.row] as! InsuranceInfo
        cell.setData(userInfo, isSelf: true)
        cell.viewMoreButton.setTitle("查看详情", for: UIControlState.normal)
        cell.viewMoreButton.isUserInteractionEnabled = false
        cell.payButton.tag = indexPath.row
        cell.payButton.addTarget(self, action: #selector(self.payButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    func payButtonClicked(_ button : UIButton) {
        let index = button.tag
        let userInfo = safeArray[index] as! InsuranceInfo
        
        let title = "保险类型:" + String(userInfo.size!) + " " + String(describing: userInfo.years!) + "年";
        let currentPrice = Float(userInfo.years!) * userInfo.price!.floatValue * 100
        
        self.selectPayType(userInfo.insured_sn!, title: title, totalFee: String(format: "%.0f", currentPrice), type: String(userInfo.type!))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userInfo = safeArray[indexPath.row] as! InsuranceInfo
        let vc = SafeDetailViewController()
        vc.insuranceId = userInfo.id
        self.pushViewController(vc)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
}
