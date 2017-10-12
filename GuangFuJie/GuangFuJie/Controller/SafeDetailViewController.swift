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
        self.view.backgroundColor = UIColor.white
        initView()
        initFootView()
        loadDetail()
    }
    
    func initFootView() {
        footImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight * 0.5))
        footImageView?.contentMode = UIViewContentMode.scaleAspectFit
        tableView.tableFooterView = footImageView
    }
    
    func loadDetail() {
        self.showHud(in: self.view, hint: "加载中...")
        API.sharedInstance.insuranceDetail(insuranceId!, success: { (insuranceInfo) in
            self.hideHud()
            self.info = insuranceInfo
            if (self.info!.order_status != nil) {
                if (self.info!.order_status! == 2) {
                    self.footImageView?.setImageWith(NSURL.init(string: self.info!.server_contract_img!)! as URL)
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
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight), style: UITableViewStyle.grouped)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 1))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: cellReuseIdentifier)
        cell.textLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        if (info != nil) {
            cell.detailTextLabel?.textColor = UIColor.lightGray
            if (indexPath.row == 0) {
                var orderNo = "保单号："
                if (info!.insured_sn != nil) {
                    orderNo = orderNo + info!.insured_sn!
                }
                cell.textLabel?.text = orderNo
                cell.detailTextLabel?.textColor = Colors.installColor
                
                if (info!.order_status?.int32Value == 2) {
                    cell.detailTextLabel?.text = "已成功投保"
                } else if (info!.order_status?.int32Value == 1){
                    cell.detailTextLabel?.text = "已投保"
                } else {
                    cell.detailTextLabel?.text = "未付款"
                }
            } else if (indexPath.row == 1) {
                var name = "受益人姓名："
                if (info!.beneficiary_name != nil) {
                    name = name + info!.beneficiary_name!
                }
                cell.textLabel?.text = name
            } else if (indexPath.row == 2) {
                var phone = "受益人电话："
                if (info!.beneficiary_phone != nil) {
                    phone = phone + info!.beneficiary_phone!
                }
                cell.textLabel?.text = phone
            } else if (indexPath.row == 3) {
                var idNum = "受益人身份证："
                if (info!.beneficiary_name != nil) {
                    idNum = idNum + info!.beneficiary_id_no!
                }
                cell.textLabel?.text = idNum
            } else if (indexPath.row == 4) {
                var type = "保险类型："
                if (info!.size != nil) {
                    type = type + YCStringUtils.getString(info!.label)
                }
                cell.textLabel?.text = type
            } else if (indexPath.row == 5) {
                //金额
                var price = "保险金额："
                if (info?.price != nil) {
                    price = price + String(describing: info!.insured_price!) + "元"
                }
                cell.textLabel?.text = price
            } else if (indexPath.row == 6) {
                //保额
                var baoeValue = "保额："
                if (info!.size != nil) {
                    baoeValue = baoeValue  + YCStringUtils.getString(info!.baoe) + "万/年"
                }
                cell.textLabel?.text = baoeValue
            } else if (indexPath.row == 7) {
                var time = "投保年限："
                if (info!.years != nil) {
                    time = time + String(describing: info!.years!) + "年"
                }
                cell.textLabel?.text = time
                
                var range = ""
                if (info!.insured_from != nil && info!.insured_end != nil) {
                    range = info!.insured_from! + "至" + info!.insured_end!
                    cell.detailTextLabel?.text = range
                }
            } else if (indexPath.row == 8) {
                var address = "电站地址："
                if (info?.station_address != nil) {
                    address = address + info!.station_address!
                }
                cell.textLabel?.text = address
            } else if (indexPath.row == 9) {
                cell.textLabel?.text = "合同图片："
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
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

