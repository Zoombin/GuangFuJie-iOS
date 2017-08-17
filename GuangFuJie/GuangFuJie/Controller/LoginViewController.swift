//
//  LoginViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/11.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var loginTableView: UITableView!
    var phoneTextField: UITextField!
    var codeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginCell_\(indexPath.row + 1)") as! LoginCell
        if (indexPath.row == 0) {
            self.phoneTextField = cell.contentTextField
        } else {
            self.codeTextField = cell.contentTextField
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /**
     登录页面代理方法--获取验证码
     */
    @IBAction func getCodeButtonClicked() {
        let phone = StringUtils.getString(phoneTextField.text)
        
        if (phone.isEmpty) {
            self.showHint("请输入手机号!")
            return
        }
        self.showHud(in: self.view, hint: "验证码获取中...")
        API.sharedInstance.userCaptcha(phone, success: { (commonModel) in
            self.hideHud()
            self.showHint("验证码将发送到您的手机!")
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    /**
     登录页面代理方法--登录按钮
     
     - parameter phone
     - parameter code
     */
    @IBAction func loginButtonClicked() {
        let phone = phoneTextField.text!
        let code = codeTextField.text!
        
        if (phone.isEmpty) {
            self.showHint("请输入手机号!")
            return
        }
        if (code.isEmpty) {
            self.showHint("请输入验证码!")
            return
        }
        self.showHud(in: self.view, hint: "登录中...")
        API.sharedInstance.login(phone, captcha: code, success: { (userinfo) in
            self.hideHud()
            self.showHint("登录成功!")
            UserDefaultManager.saveString(UserDefaultManager.USER_INFO, value: userinfo.mj_JSONString())
            self.backButtonClicked()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
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
