//
//  AddNoteViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/15.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class AddNoteViewController: BaseViewController {
    var nameTextField: UITextField!
    var timeTextField: UITextField!
    var phoneTextField: UITextField!
    var addressTextField: UITextField!
    var noteTextView: FSTextView!
    var contentScrollView: UIScrollView!
    let times = YCPhoneUtils.screenWidth / 375
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "添加笔记"
        initView()
    }
    
    func initView() {
        contentScrollView = UIScrollView.init(frame: CGRect(x: 0, y: self.navigationBarAndStatusBarHeight(), width: YCPhoneUtils.screenWidth, height: YCPhoneUtils.screenHeight - self.navigationBarAndStatusBarHeight()))
        self.view.addSubview(contentScrollView)
        
        let offSetY: CGFloat = 10 * times
        var currentY: CGFloat = 0
        nameTextField = UITextField.init(frame: CGRect(x: 0, y: currentY, width: YCPhoneUtils.screenWidth, height: 50 * times))
        nameTextField.placeholder = "请输入标题"
        self.addNoteCustomParams(textField: nameTextField)
        contentScrollView.addSubview(nameTextField)
        currentY = nameTextField.frame.maxY + offSetY
        
        timeTextField = UITextField.init(frame: CGRect(x: 0, y: currentY, width: YCPhoneUtils.screenWidth, height: 50 * times))
        timeTextField.placeholder = "请输入日期"
        self.addNoteCustomParams(textField: timeTextField)
        contentScrollView.addSubview(timeTextField)
        currentY = timeTextField.frame.maxY + offSetY
        
        phoneTextField = UITextField.init(frame: CGRect(x: 0, y: currentY, width: YCPhoneUtils.screenWidth, height: 50 * times))
        phoneTextField.placeholder = "请输入电话"
        self.addNoteCustomParams(textField: phoneTextField)
        contentScrollView.addSubview(phoneTextField)
        currentY = phoneTextField.frame.maxY + offSetY
        
        addressTextField = UITextField.init(frame: CGRect(x: 0, y: currentY, width: YCPhoneUtils.screenWidth, height: 50 * times))
        addressTextField.placeholder = "请输入地址"
        self.addNoteCustomParams(textField: addressTextField)
        contentScrollView.addSubview(addressTextField)
        currentY = addressTextField.frame.maxY + offSetY
        
        noteTextView = FSTextView.init(frame: CGRect(x: 0, y: currentY, width: YCPhoneUtils.screenWidth, height: 150 * times))
        noteTextView.placeholder = "请输入备注"
        noteTextView.font = UIFont.systemFont(ofSize: 15)
        noteTextView.layer.borderColor = UIColor.lightGray.cgColor
        noteTextView.layer.borderWidth = 0.5
        contentScrollView.addSubview(noteTextView)
        currentY = noteTextView.frame.maxY + offSetY
        
        let submitButton = UIButton.init(type: UIButtonType.custom)
        submitButton.setTitle("保存", for: UIControlState.normal)
        submitButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        submitButton.backgroundColor = Colors.appBlue
        submitButton.frame = CGRect(x: (YCPhoneUtils.screenWidth - 340 * times) / 2, y: currentY, width: 340 * times, height: 50 * times)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        submitButton.addTarget(self, action: #selector(self.submit), for: UIControlEvents.touchUpInside)
        contentScrollView.addSubview(submitButton)
        
        contentScrollView.contentSize = CGSize(width: 0, height: currentY)
    }
    
    func addNoteCustomParams(textField: UITextField) {
        textField.backgroundColor = UIColor.white
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        let leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 5 * times, height: textField.frame.size.height))
        textField.leftViewMode = UITextFieldViewMode.always
        textField.leftView = leftView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func submit() {
        if (nameTextField.text!.isEmpty) {
            self.showHint(nameTextField.placeholder)
            return
        }
        if (timeTextField.text!.isEmpty) {
            self.showHint(timeTextField.placeholder)
            return
        }
        if (phoneTextField.text!.isEmpty) {
            self.showHint(phoneTextField.placeholder)
            return
        }
        if (addressTextField.text!.isEmpty) {
            self.showHint(addressTextField.placeholder)
            return
        }
        if (noteTextView.text!.isEmpty) {
            self.showHint(noteTextView.placeholder)
            return
        }
        self.showHud(in: self.view, hint: "提交中...")
        API.sharedInstance.groundAddnote(nameTextField.text!, phone: phoneTextField.text!, address: addressTextField.text!, msg: noteTextView.text!, success: { (model) in
            self.hideHud()
            self.showHint("提交成功")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
