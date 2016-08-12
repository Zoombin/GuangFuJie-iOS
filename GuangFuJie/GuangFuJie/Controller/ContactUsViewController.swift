//
//  ContactUsViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/8/12.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class ContactUsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView : UITableView!
    
    let cellReuseIdentifier = "UITableViewCell"
    let titles = ["江苏省苏州市工业园区仁爱路1号", "光伏街电话 4006229666", "邮箱地址 server@pvsr.cn"]
    let icons = ["ic_h_address", "ic_h_call", "ic_h_email"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "联系客服"
        tableView = UITableView.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight), style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView)
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, 5))
        return view
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        cell.textLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        cell.imageView?.image = UIImage(named: icons[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //拨号功能
        if (indexPath.row == 1) {
            let tel =  "tel://4006229666"
            UIApplication.sharedApplication().openURL(NSURL.init(string: tel)!)
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
