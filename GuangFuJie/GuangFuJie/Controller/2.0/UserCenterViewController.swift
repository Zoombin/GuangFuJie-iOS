//
//  UserCenterViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/7.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class UserCenterViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "用户主页"
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
        
        let bottomView = UIView.init(frame: CGRectMake(0, CGRectGetMaxY(tableView.frame), PhoneUtils.kScreenWidth, 50))
        bottomView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(bottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 10 * 2
        let buttonHeight = bottomView.frame.size.height - 5 * 2
        
        let logOutButton = UIButton.init(type: UIButtonType.Custom)
        logOutButton.frame = CGRectMake(10, 5, buttonWidth, buttonHeight)
        logOutButton.setTitle("退出", forState: UIControlState.Normal)
        logOutButton.backgroundColor = UIColor.lightGrayColor()
        logOutButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        logOutButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge2)
        logOutButton.addTarget(self, action: #selector(self.logOut), forControlEvents: UIControlEvents.TouchUpInside)
        bottomView.addSubview(logOutButton)
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
        return 2;
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
        if (indexPath.section == 0) {
            cell.imageView?.image = UIImage(named: "ic_avstar")
            cell.textLabel?.text = UserDefaultManager.getUser()?.user_name
            
            let typeButtpn = UIButton.init(type: UIButtonType.Custom)
            if (UserDefaultManager.getUser()!.is_installer?.integerValue == 0) {
                typeButtpn.setTitle("业主", forState: UIControlState.Normal)
            } else {
                typeButtpn.setTitle("安装商", forState: UIControlState.Normal)
            }
            
            typeButtpn.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
            typeButtpn.frame = CGRectMake(PhoneUtils.kScreenWidth - 80 - 5, 28, 80, 24)
            typeButtpn.layer.borderWidth = 0.5
            typeButtpn.layer.borderColor = Colors.installColor.CGColor
            typeButtpn.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
            typeButtpn.addTarget(self, action: #selector(self.typeButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
            cell.contentView.addSubview(typeButtpn)
        } else {
            cell.textLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            if (indexPath.row == 0) {
                cell.imageView?.image = UIImage(named: "ic_my_roof")
                cell.textLabel?.text = "我的屋顶"
            } else if (indexPath.row == 1) {
                cell.imageView?.image = UIImage(named: "ic_my_insure")
                cell.textLabel?.text = "我的保险"
            }
        }
        return cell
    }
    
    func typeButtonClicked() {
        if (UserDefaultManager.getUser()!.is_installer?.integerValue == 0) {
            let alertView = UIAlertView.init(title: "提示", message: "申请成为安装商", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alertView.show()
        } else {
            let vc = InstallerDetailViewController()
            self.pushViewController(vc)
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (alertView.cancelButtonIndex ==  buttonIndex) {
            return
        }
        let vc = ToBeInstallerViewController()
        self.pushViewController(vc)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                let vc = GFJMyRoofsViewController()
                self.pushViewController(vc)
            } else if (indexPath.row == 1) {
                let vc = MySafeListViewController()
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
