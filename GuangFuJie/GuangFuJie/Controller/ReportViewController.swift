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
        scrollView.frame = CGRectMake(0, 0, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight)
        scrollView.contentSize = CGSizeMake(PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight)
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        phoneTextField = UITextField.init(frame: CGRectMake(5, 5, PhoneUtils.kScreenWidth - 5 * 2, textFieldHeight))
        phoneTextField.placeholder = "请输入手机号"
        phoneTextField.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        phoneTextField.layer.borderWidth = 0.5
        phoneTextField.layer.borderColor = UIColor.blackColor().CGColor
        phoneTextField.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(phoneTextField)

        
        reportTimeTextField = UITextField.init(frame: CGRectMake(5, CGRectGetMaxY(phoneTextField.frame) + 5, PhoneUtils.kScreenWidth - 5 * 2, textFieldHeight))
        reportTimeTextField.placeholder = "请输入预约时间"
        reportTimeTextField.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        reportTimeTextField.layer.borderWidth = 0.5
        reportTimeTextField.layer.borderColor = UIColor.blackColor().CGColor
        reportTimeTextField.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(reportTimeTextField)
        
        commentTextField = UITextField.init(frame: CGRectMake(5, CGRectGetMaxY(reportTimeTextField.frame) + 5, PhoneUtils.kScreenWidth - 5 * 2, textFieldHeight))
        commentTextField.placeholder = "请输入备注"
        commentTextField.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        commentTextField.layer.borderWidth = 0.5
        commentTextField.layer.borderColor = UIColor.blackColor().CGColor
        commentTextField.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(commentTextField)
        
        let reportButton = UIButton.init(type: UIButtonType.Custom)
        reportButton.frame = CGRectMake(15, CGRectGetMaxY(commentTextField.frame) + 10, PhoneUtils.kScreenWidth - 15 * 2, textFieldHeight * 0.7)
        reportButton.setTitle("报修", forState: UIControlState.Normal)
        reportButton.backgroundColor = Colors.lightBule
        reportButton.addTarget(self, action: #selector(self.report), forControlEvents: UIControlEvents.TouchUpInside)
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
        self.showHudInView(self.view, hint: "申请中...")
        API.sharedInstance.bookRepair(reportTimeTextField.text!, phone: phoneTextField.text!, comments: commentTextField.text!, device_id: device_id, success: { (commonModel) in
            self.hideHud()
            self.showHint("报修成功!")
            self.navigationController?.popViewControllerAnimated(true)
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
