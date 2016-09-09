//
//  SafeDetailViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/9.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class SafeDetailViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView : UITableView!
    var info : InsuranceDetail?
    var insuranceId : NSNumber?
    var footImageView : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的保险"
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        initView()
        initFootView()
        loadDetail()
    }
    
    func initFootView() {
        footImageView = UIImageView.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight * 0.5))
        footImageView?.contentMode = UIViewContentMode.ScaleAspectFit
        tableView.tableFooterView = footImageView
    }
    
    func loadDetail() {
        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.insuranceDetail(insuranceId!, success: { (insuranceInfo) in
            self.hideHud()
            self.info = insuranceInfo
            if (self.info!.status != nil) {
                if (self.info!.status! == 2) {
                    self.footImageView?.af_setImageWithURL(NSURL.init(string: self.info!.server_contract_img!)!)
                }
            }
            self.tableView.reloadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    let cellReuseIdentifier = "cellReuseIdentifier"
    func initView() {
        tableView = UITableView.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight), style: UITableViewStyle.Grouped)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, 1))
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
        cell.textLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        if (info != nil) {
            if (indexPath.row == 0) {
                var type = "保险类型:"
                if (info?.size != nil) {
                    type = type + info!.size!
                }
                cell.textLabel?.text = type
            } else if (indexPath.row == 1) {
                var years = "保险年限:"
                if (info?.years != nil) {
                    years = years + String(info!.years!)
                }
                cell.textLabel?.text = years
            } else if (indexPath.row == 2) {
                var price = "保险金额"
                if (info?.insured_price != nil) {
                    price = price + String(info!.insured_price!) + "元"
                }
                cell.textLabel?.text = price
            } else if (indexPath.row == 3) {
                var date = "有限期:"
                if (info?.insured_from != nil && info?.insured_end != nil) {
                    date = date + info!.insured_from! + "至" + info!.insured_end!
                }
                cell.textLabel?.text = date
            } else if (indexPath.row == 4) {
                var status = "审核状态:"
                if (info?.status != nil) {
                    if (info!.status! == 1) {
                        status = status + "审核中"
                    }
                    if (info!.status! == 2) {
                        status = status + "已受理"
                    }
                }
                cell.textLabel?.text = status
            } else if (indexPath.row == 5) {
                cell.textLabel?.text = "合同图片:"
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
