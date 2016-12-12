//
//  MyInstallerDetailViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/11.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class MyInstallerDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安装商"
        // Do any additional setup after loading the view.
        initView()
    }
    
    let cellReuseIdentifier = "cellReuseIdentifier"
    let installerReuseIdentifier = "installerReuseIdentifier"
    func initView() {
        let tableView = UITableView.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.registerClass(InstallHeaderCell.self, forCellReuseIdentifier: installerReuseIdentifier)
    }
    
    func logOut() {
        UserDefaultManager.logOut()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1;
        }
        return 3;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, 1))
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return InstallHeaderCell.cellHeight()
        } else {
            return 44
        }
    }
    
    func remindButtonClicked() {
        API.sharedInstance.remindAuth({ (commonModel) in
                self.showHint("提醒成功")
            }) { (msg) in
                self.showHint(msg)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier(installerReuseIdentifier, forIndexPath: indexPath) as! InstallHeaderCell
            cell.initCell()
            cell.noticeButton.addTarget(self, action: #selector(self.remindButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
            return cell
        } else {
            let cell = UITableViewCell.init(style: UITableViewCellStyle.Value1, reuseIdentifier: cellReuseIdentifier)
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            cell.detailTextLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
            
            cell.textLabel?.textColor = UIColor.lightGrayColor()
            cell.textLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
            if (indexPath.row == 0) {
                var company_name = ""
                if (UserDefaultManager.getUser()!.company_name != nil) {
                    company_name = UserDefaultManager.getUser()!.company_name!
                }
                cell.imageView?.image = UIImage(named: "ic_installer_company")
                cell.textLabel?.text = "我的公司"
                cell.detailTextLabel?.text = company_name
            } else if (indexPath.row == 1) {
                var company_size = ""
                if (UserDefaultManager.getUser()!.company_size != nil) {
                    company_size = UserDefaultManager.getUser()!.company_size!
                }
                cell.imageView?.image = UIImage(named: "ic_installer_team")
                cell.textLabel?.text = "公司规模"
                cell.detailTextLabel?.text = company_size + "人"
            } else if (indexPath.row == 2) {
                cell.imageView?.image = UIImage(named: "ic_installer_location")
                cell.textLabel?.text = "公司地址"
                var province = ""
                var city = ""
                var address = ""
                if (UserDefaultManager.getUser()!.province_label != nil) {
                    province = UserDefaultManager.getUser()!.province_label!
                }
                if (UserDefaultManager.getUser()!.city_label != nil) {
                    city = UserDefaultManager.getUser()!.city_label!
                }
                if (UserDefaultManager.getUser()!.address != nil) {
                    address = UserDefaultManager.getUser()!.address!
                }
                cell.detailTextLabel?.text = province + city + address
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
