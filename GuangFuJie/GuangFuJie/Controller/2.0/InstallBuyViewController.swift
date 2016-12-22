//
//  InstallBuyViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/10.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class InstallBuyViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var roofId : NSNumber!
    var tableView : UITableView!
    var rInfo : RoofInfo?
    var imageView : UIImageView!
    var isSelf = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安装商接单"
        // Do any additional setup after loading the view.
        initView()
        loadRoofInfo()
    }
    
    func loadRoofInfo() {
        self.showHud(in: self.view, hint: "加载中...")
        API.sharedInstance.getRoofInfo(roofId, success: { (roofInfo) in
                self.hideHud()
                self.rInfo = roofInfo
                self.title = roofInfo.fullname!
                self.addHeaderView()
                self.tableView.reloadData()
            }) { (msg) in
                self.hideHud()
                self.showHint(msg)
        }
    }
    
    func addHeaderView() {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight * 0.35))
        
        let titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: headerView.frame.size.height * 0.15))
        titleLabel.text = " 屋顶类似图片"
        titleLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        titleLabel.textColor = UIColor.black
        headerView.addSubview(titleLabel)
        
        imageView = UIImageView.init(frame: CGRect(x: 0, y: titleLabel.frame.maxY, width: PhoneUtils.kScreenWidth, height: headerView.frame.size.height * 0.85))
        imageView.setImageWith(URL.init(string: rInfo!.area_image!)! as URL)
        headerView.addSubview(imageView)
        
        tableView.tableHeaderView = headerView
    }
    
    let cellReuseIdentifier = "cellReuseIdentifier"
    func initView() {
        let buyBottomView = UIView.init(frame: CGRect(x: 0, y: self.view.frame.size.height - 50, width: PhoneUtils.kScreenWidth, height: 50))
        buyBottomView.backgroundColor = UIColor.white
        self.view.addSubview(buyBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = buyBottomView.frame.size.height - 5 * 2
        
        let buyNowButton = GFJBottomButton.init(type: UIButtonType.custom)
        buyNowButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        buyNowButton.setTitle("立即接单", for: UIControlState.normal)
        buyNowButton.backgroundColor = Colors.installColor
        buyNowButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        buyNowButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        buyNowButton.addTarget(self, action: #selector(self.orderNowButtonClicked), for: UIControlEvents.touchUpInside)
        buyBottomView.addSubview(buyNowButton)
        
        var offSetY : CGFloat = 0
        if (isSelf) {
            buyBottomView.isHidden = true
            offSetY = buyBottomView.frame.size.height - 100
        }
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 64, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - offSetY - 64 - 50), style: UITableViewStyle.grouped)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    func orderNowButtonClicked() {
        if (shouldShowLogin()) {
            return
        }
        self.showHud(in: self.view, hint: "提交中...")
        API.sharedInstance.orderRoof(roofId, success: { (commonModel) in
                self.hideHud()
                self.showHint("接单成功!")
                self.navigationController?.popViewController(animated: true)
            }) { (msg) in
                self.hideHud()
                self.showHint(msg)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 2
        } else if (section == 1) {
            return 3
        } else if (section == 2) {
            return 1
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 1))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath as IndexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        cell.textLabel?.textColor = UIColor.black
        if (rInfo != nil) {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    cell.imageView?.image = UIImage(named: "ic_calc_a")
                    cell.textLabel?.text = "业主地址"
                } else if (indexPath.row == 1) {
                    var address = ""
                    if (rInfo!.province_label != nil) {
                        address = address + rInfo!.province_label!
                    }
                    if (rInfo!.city_label != nil) {
                        address = address + rInfo!.city_label!
                    }
                    if (rInfo!.address != nil) {
                        address = address + rInfo!.address!
                    }
                    cell.textLabel?.text = address
                }
            } else if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    cell.textLabel?.text = "屋顶信息"
                } else if (indexPath.row == 1) {
                    cell.textLabel?.text = "屋顶面积:" + String(describing: rInfo!.area_size!) + "㎡"
                } else {
                    cell.textLabel?.text = "屋顶类型:" + (rInfo!.type! == 2 ? "斜面" : "平面")
                }
            } else if (indexPath.section == 2) {
                cell.textLabel?.text = "出租单价:" + String(describing: rInfo!.price!) + "元/㎡"
            } else {
                if (indexPath.row == 0) {
                    cell.textLabel?.text = "联系人信息"
                } else if (indexPath.row == 1) {
                    cell.textLabel?.text = "联系人:" + rInfo!.fullname!
                } else if (indexPath.row == 2) {
                    cell.textLabel?.text = "联系方式:****"
                } else {
                    cell.textLabel?.text = "连续时间:" + rInfo!.contact_time!
                }
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
