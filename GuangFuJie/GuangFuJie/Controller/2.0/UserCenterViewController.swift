//
//  UserCenterViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/7.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class UserCenterViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {
    var tableView: UITableView!
    var typeButtpn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "用户主页"
        // Do any additional setup after loading the view.
        initView()
    }

    let cellReuseIdentifier = "cellReuseIdentifier"
    func initView() {
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - 50), style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        let bottomView = UIView.init(frame: CGRect(x: 0, y: tableView.frame.maxY, width: PhoneUtils.kScreenWidth, height: 50))
        bottomView.backgroundColor = UIColor.clear
        self.view.addSubview(bottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 10 * 2
        let buttonHeight = bottomView.frame.size.height - 5 * 2
        
        let logOutButton = GFJBottomButton.init(type: UIButtonType.custom)
        logOutButton.frame = CGRect(x: 10, y: 5, width: buttonWidth, height: buttonHeight)
        logOutButton.setTitle("退出", for: UIControlState.normal)
        logOutButton.backgroundColor = UIColor.lightGray
        logOutButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        logOutButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        logOutButton.addTarget(self, action: #selector(self.logOut), for: UIControlEvents.touchUpInside)
        bottomView.addSubview(logOutButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshUserInfo()
    }
    
    func refreshUserInfo() {
        if (!UserDefaultManager.isLogin()) {
            return
        }
        API.sharedInstance.getUserInfo({ (userinfo) in
            UserDefaultManager.saveString(UserDefaultManager.USER_INFO, value: userinfo.mj_JSONString())
            self.tableView.reloadData()
        }) { (msg) in
            print(msg)
        }
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
           return 80
        } else {
           return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath as IndexPath)
        if (indexPath.section == 0) {
            cell.imageView?.image = UIImage(named: "ic_avstar")
            cell.textLabel?.text = UserDefaultManager.getUser()?.user_name
            
            typeButtpn = UIButton.init(type: UIButtonType.custom)
            if (UserDefaultManager.getUser()!.is_installer?.int32Value == 0) {
                typeButtpn.setTitle("业主", for: UIControlState.normal)
            } else {
                typeButtpn.setTitle("安装商", for: UIControlState.normal)
            }
            
            typeButtpn.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
            typeButtpn.frame = CGRect(x: PhoneUtils.kScreenWidth - 80 - 5, y: 28, width: 80, height: 24)
            typeButtpn.layer.borderWidth = 0.5
            typeButtpn.layer.borderColor = Colors.installColor.cgColor
            typeButtpn.backgroundColor = UIColor.white
            typeButtpn.setTitleColor(Colors.installColor, for: UIControlState.normal)
            typeButtpn.addTarget(self, action: #selector(self.typeButtonClicked), for: UIControlEvents.touchUpInside)
            cell.contentView.addSubview(typeButtpn)
        } else {
            cell.textLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            if (indexPath.row == 0) {
                cell.imageView?.image = UIImage(named: "ic_my_roof")
                cell.textLabel?.text = "我的屋顶"
            } else if (indexPath.row == 1) {
                cell.imageView?.image = UIImage(named: "ic_my_insure")
                cell.textLabel?.text = "我的保险"
            } else if (indexPath.row == 2) {
                cell.imageView?.image = UIImage(named: "ic_my_favor")
                cell.textLabel?.text = "我的收藏"
            }
        }
        return cell
    }
    
    func typeButtonClicked() {
        if (UserDefaultManager.getUser()!.is_installer?.int32Value == 0) {
            let alertView = UIAlertView.init(title: "提示", message: "申请成为安装商", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alertView.show()
        } else {
            let vc = MyInstallerDetailViewController()
            self.pushViewController(vc)
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if (alertView.cancelButtonIndex ==  buttonIndex) {
            return
        }
        let vc = ToBeInstallerViewController()
        self.pushViewController(vc)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                let vc = GFJMyRoofsViewController()
                self.pushViewController(vc)
            } else if (indexPath.row == 1) {
                let vc = MySafeListViewController()
                self.pushViewController(vc)
            } else if (indexPath.row == 2) {
                let vc = MyFavViewController()
                self.pushViewController(vc)
            }
        }
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
