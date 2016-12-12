//
//  InstallerDetailViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/11.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class InstallerDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安装商"
        // Do any additional setup after loading the view.
        initView()
    }
    
    let cellReuseIdentifier = "cellReuseIdentifier"
    func initView() {
        let tableView = UITableView.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - 50), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
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
            return 80
        } else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.Value1, reuseIdentifier: cellReuseIdentifier)
        if (indexPath.section == 0) {
            cell.imageView?.image = UIImage(named: "ic_avstar")
            cell.textLabel?.text = UserDefaultManager.getUser()?.user_name
        } else {
            cell.textLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
            if (indexPath.row == 0) {
                cell.imageView?.image = UIImage(named: "ic_installer_company")
                cell.textLabel?.text = "我的公司"
                cell.detailTextLabel?.text = UserDefaultManager.getUser()?.company_name
            } else if (indexPath.row == 1) {
                cell.imageView?.image = UIImage(named: "ic_installer_team")
                cell.textLabel?.text = "公司规模"
                cell.detailTextLabel?.text = UserDefaultManager.getUser()?.company_size
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
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
