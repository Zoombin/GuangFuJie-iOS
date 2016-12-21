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
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight), style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.register(InstallHeaderCell.self, forCellReuseIdentifier: installerReuseIdentifier)
    }
    
    func logOut() {
        UserDefaultManager.logOut()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1;
        }
        return 3;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 1))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: installerReuseIdentifier, for: indexPath as IndexPath) as! InstallHeaderCell
            cell.initCell()
            cell.noticeButton.addTarget(self, action: #selector(self.remindButtonClicked), for: UIControlEvents.touchUpInside)
            return cell
        } else {
            let cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: cellReuseIdentifier)
            cell.detailTextLabel?.textColor = UIColor.black
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
            
            cell.textLabel?.textColor = UIColor.lightGray
            cell.textLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
}
