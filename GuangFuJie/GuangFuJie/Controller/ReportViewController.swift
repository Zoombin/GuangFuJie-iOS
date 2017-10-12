//
//  ReportViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/2.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class ReportViewController: BaseViewController {

    var scrollView : UIScrollView!
    var phoneTextField : UITextField!
    var reportTimeTextField : UITextField!
    var commentTextField : UITextField!
    
    var device_id : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "报修"
        childViews()
    }
    
    func childViews() -> Void {
        let textFieldHeight = PhoneUtils.kScreenHeight / 12
        
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight)
        scrollView.contentSize = CGSize(width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight)
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        phoneTextField = UITextField.init(frame: CGRect(x: 5, y: 5, width: PhoneUtils.kScreenWidth - 5 * 2, height: textFieldHeight))
        phoneTextField.placeholder = "请输入手机号"
        phoneTextField.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        phoneTextField.layer.borderWidth = 0.5
        phoneTextField.layer.borderColor = UIColor.black.cgColor
        phoneTextField.backgroundColor = UIColor.white
        scrollView.addSubview(phoneTextField)

        
        reportTimeTextField = UITextField.init(frame: CGRect(x: 5, y: (phoneTextField.frame).maxY + 5, width: PhoneUtils.kScreenWidth - 5 * 2, height: textFieldHeight))
        reportTimeTextField.placeholder = "请输入预约时间"
        reportTimeTextField.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        reportTimeTextField.layer.borderWidth = 0.5
        reportTimeTextField.layer.borderColor = UIColor.black.cgColor
        reportTimeTextField.backgroundColor = UIColor.white
        scrollView.addSubview(reportTimeTextField)
        
        commentTextField = UITextField.init(frame: CGRect(x: 5, y: (reportTimeTextField.frame).maxY + 5, width: PhoneUtils.kScreenWidth - 5 * 2, height: textFieldHeight))
        commentTextField.placeholder = "请输入备注"
        commentTextField.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        commentTextField.layer.borderWidth = 0.5
        commentTextField.layer.borderColor = UIColor.black.cgColor
        commentTextField.backgroundColor = UIColor.white
        scrollView.addSubview(commentTextField)
        
        let reportButton = UIButton.init(type: UIButtonType.custom)
        reportButton.frame = CGRect(x: 15, y: (commentTextField.frame).maxY + 10, width: PhoneUtils.kScreenWidth - 15 * 2, height: textFieldHeight * 0.7)
        reportButton.setTitle("报修", for: UIControlState.normal)
        reportButton.backgroundColor = Colors.lightBlue
        reportButton.addTarget(self, action: #selector(self.report), for: UIControlEvents.touchUpInside)
        scrollView.addSubview(reportButton)
    }
    
    func hidenAllKeyboard() {
        phoneTextField.resignFirstResponder()
        reportTimeTextField.resignFirstResponder()
    }
    
    func report() {
        hidenAllKeyboard()
        if (phoneTextField.text!.isEmpty) {
            self.showHint("请输入手机号")
            return
        }
        if (reportTimeTextField.text!.isEmpty) {
            self.showHint("请输入预约时间")
            return
        }
        if (commentTextField.text!.isEmpty) {
            self.showHint("请输入备注")
            return
        }
        self.showHud(in: self.view, hint: "申请中...")
        API.sharedInstance.bookRepair(reportTimeTextField.text!, phone: phoneTextField.text!, comments: commentTextField.text!, device_id: device_id, success: { (commonModel) in
            self.hideHud()
            self.showHint("报修成功!")
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
}
