//
//  RootMyViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/6.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootMyViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var footView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的"
        loadMyCount()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (UserDefaultManager.isLogin()) {
            userName.text = UserDefaultManager.getUser()?.user_name
            footView.isHidden = false
        } else {
            userName.text = "点击登录"
            footView.isHidden = true
        }
    }
    
    func loadMyCount() {
        API.sharedInstance.userAllCount(success: { (model) in
            print(model.deviceCount!)
            print(model.favorCount!)
            print(model.insuranceCount!)
            print(model.roofCount!)
        }) { (msg) in
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.tabBarItem.selectedImage = self.tabBarItem.selectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell_\(indexPath.row + 1)")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.row == 0) {
            //分享光伏街
            shareApp()
        } else if (indexPath.row == 1) {
            //技术支持
            let vc = GFJWebViewController()
            vc.url = "http://zoombin.com"
            vc.title = "技术支持"
            self.pushViewController(vc)
        } else if (indexPath.row == 2) {
            //关于我们
            let vc = GFJWebViewController()
            vc.title = "关于我们"
            vc.urlTag = 0
            self.pushViewController(vc)
        } else if (indexPath.row == 3) {
            //设置
        }
    }
    
    @IBAction func loginButtonClicked() {
        if (UserDefaultManager.isLogin() == true) {
            return
        }
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        self.pushViewController(sb.instantiateViewController(withIdentifier: "LoginViewController"))
    }
    
    @IBAction func logOutButtonClicked() {
        UserDefaultManager.logOut()
        userName.text = "点击登录"
        footView.isHidden = true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
