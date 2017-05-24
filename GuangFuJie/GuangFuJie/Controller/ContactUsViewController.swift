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
    let titles = ["江苏省苏州市工业园区仁爱路1号", "\(Constants.projectName)电话 4006229666", "邮箱地址 server@pvsr.cn"]
    let icons = ["ic_h_address", "ic_h_call", "ic_h_email"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "联系客服"
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight), style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 5))
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath as IndexPath)
        cell.textLabel?.text = titles[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        cell.imageView?.image = UIImage(named: icons[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        //拨号功能
        if (indexPath.row == 1) {
            let tel =  "tel://4006229666"
            UIApplication.shared.openURL(URL.init(string: tel)! as URL)
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
