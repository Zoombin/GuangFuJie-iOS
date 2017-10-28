//
//  InvestAddViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/10/28.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class InvestAddViewController: BaseViewController {
    var contentScroll: UIScrollView!
    
    var nameTextField: UITextField!
    var phoneTextField: UITextField!
    var sizeTextField: UITextField!
    
    var typeButton1: UIButton! //集中式地面电站
    var typeButton2: UIButton! //分布式屋顶电站
    var typeButton3: UIButton! //分布式地面电站
    
    var describeTextView: FSTextView!
    var type = "1"
    
    var times = YCPhoneUtils.screenWidth / 375
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "注册投资信息"
        initView()
    }
    
    func initView() {
        contentScroll = UIScrollView.init(frame: CGRect(x: 0, y: self.navigationBarAndStatusBarHeight(), width: YCPhoneUtils.screenWidth, height: YCPhoneUtils.screenHeight - self.navigationBarAndStatusBarHeight()))
        contentScroll.backgroundColor = UIColor.clear
        self.view.addSubview(contentScroll)
        
        let textFieldWidth = YCPhoneUtils.screenWidth
        let textFieldHeight = 50 * times
        
        let topView = UIView.init(frame: CGRect(x: 0, y: 10 * times, width: textFieldWidth, height: textFieldHeight * 2))
        topView.backgroundColor = UIColor.white
        contentScroll.addSubview(topView)
        
        nameTextField = UITextField.init(frame: CGRect(x: 0, y: 0, width: textFieldWidth, height: textFieldHeight))
        nameTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        nameTextField.placeholder = "请输入投资方姓名"
        nameTextField.textAlignment = NSTextAlignment.right
        self.addLeftView(title: " 投资方姓名", textField: nameTextField)
        self.addRightView(textField: nameTextField)
        YCLineUtils.addBottomLine(nameTextField, color: self.view.backgroundColor, percent: 100)
        topView.addSubview(nameTextField)
        
        phoneTextField = UITextField.init(frame: CGRect(x: 0, y: nameTextField.frame.maxY, width: textFieldWidth, height: textFieldHeight))
        phoneTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        phoneTextField.placeholder = "请输入投资方手机号"
        phoneTextField.textAlignment = NSTextAlignment.right
        self.addLeftView(title: " 投资方手机号", textField: phoneTextField)
        self.addRightView(textField: phoneTextField)
        YCLineUtils.addBottomLine(phoneTextField, color: self.view.backgroundColor, percent: 100)
        topView.addSubview(phoneTextField)
        
        let middleView = UIView.init(frame: CGRect(x: 0, y: topView.frame.maxY + 10 * times, width: textFieldWidth, height: 140 * times))
        middleView.backgroundColor = UIColor.white
        contentScroll.addSubview(middleView)
        
        sizeTextField = UITextField.init(frame: CGRect(x: 0, y: 0, width: textFieldWidth, height: textFieldHeight))
        sizeTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        sizeTextField.placeholder = "请输入投资电站规模"
        sizeTextField.textAlignment = NSTextAlignment.right
        self.addLeftView(title: " 电站规模(MW)", textField: sizeTextField)
        self.addRightView(textField: sizeTextField)
        YCLineUtils.addBottomLine(sizeTextField, color: self.view.backgroundColor, percent: 100)
        middleView.addSubview(sizeTextField)
        
        let typeTitleLabel = UILabel.init(frame: CGRect(x: 0, y: sizeTextField.frame.maxY, width: textFieldWidth, height: textFieldHeight))
        typeTitleLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        typeTitleLabel.text = " 电站类型"
        middleView.addSubview(typeTitleLabel)
        
        let titles = ["集中式地面电站", "分布式屋顶电站", "分布式地面电站"]
        for i in 0..<titles.count {
            let checkBox = UIButton.init(frame: CGRect(x: CGFloat(i) * YCPhoneUtils.screenWidth / 3, y: typeTitleLabel.frame.maxY, width: YCPhoneUtils.screenWidth / 3, height: 40 * times))
            checkBox.setTitleColor(UIColor.black, for: UIControlState.normal)
            checkBox.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
            checkBox.setTitle(titles[i], for: UIControlState.normal)
            checkBox.setImage(UIImage(named: "checkbox_hl"), for: UIControlState.selected)
            checkBox.setImage(UIImage(named: "checkbox"), for: UIControlState.normal)
            checkBox.addTarget(self, action: #selector(self.checkBoxButtonClicked), for: UIControlEvents.touchUpInside)
            checkBox.tag = i
            middleView.addSubview(checkBox)
            if (i == 0) {
               checkBox.isSelected = true
               typeButton1 = checkBox
            } else if (i == 1) {
                typeButton2 = checkBox
            } else {
                typeButton3 = checkBox
            }
            
        }
        
        let bottomView = UIView.init(frame: CGRect(x: 0, y: middleView.frame.maxY + 10 * times, width: textFieldWidth, height: textFieldHeight * 4))
        bottomView.backgroundColor = UIColor.white
        contentScroll.addSubview(bottomView)
        
        let describeTitleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: textFieldWidth, height: textFieldHeight))
        describeTitleLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        describeTitleLabel.text = " 其他说明"
        YCLineUtils.addBottomLine(describeTitleLabel, color: self.view.backgroundColor, percent: 100)
        bottomView.addSubview(describeTitleLabel)
        
        describeTextView = FSTextView.init(frame: CGRect(x: 0, y: describeTitleLabel.frame.maxY, width: textFieldWidth, height: textFieldHeight * 3))
        describeTextView.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        describeTextView.placeholder = "请输入其他说明"
        bottomView.addSubview(describeTextView)
        
        let submitButton = UIButton.init(type: UIButtonType.custom)
        submitButton.frame = CGRect(x: (YCPhoneUtils.screenWidth - 340 * times) / 2, y: bottomView.frame.maxY + 10 * times, width: 340 * times, height: 50 * times)
        submitButton.setTitle("提交", for: UIControlState.normal)
        submitButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        submitButton.backgroundColor = Colors.appBlue
        submitButton.addTarget(self, action: #selector(self.submitButtonClicked), for: UIControlEvents.touchUpInside)
        contentScroll.addSubview(submitButton)
        
        contentScroll.contentSize = CGSize(width: 0, height: submitButton.frame.maxY + 20 * times) 
    }
    
    func addLeftView(title: String, textField: UITextField) {
        textField.leftViewMode = UITextFieldViewMode.always
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width * 0.6, height: textField.frame.size.height))
        label.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        label.text = title
        textField.leftView = label
    }
    
    func checkBoxButtonClicked(button: UIButton) {
        typeButton1.isSelected = false
        typeButton2.isSelected = false
        typeButton3.isSelected = false
        if (button.tag == 0) {
            type = "1"
            typeButton1.isSelected = true
        } else if (button.tag == 1) {
            type = "2"
            typeButton2.isSelected = true
        } else {
            type = "3"
            typeButton3.isSelected = true
        }
    }
    
    func addRightView(textField: UITextField) {
        textField.rightViewMode = UITextFieldViewMode.always
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 5 * times, height: textField.frame.size.height))
        textField.rightView = label
    }
    
    func submitButtonClicked() {
        if (YCStringUtils.getString(nameTextField.text).isEmpty) {
            self.showHint(nameTextField.placeholder)
            return
        }
        if (YCStringUtils.getString(phoneTextField.text).isEmpty) {
            self.showHint(phoneTextField.placeholder)
            return
        }
        if (YCStringUtils.getString(sizeTextField.text).isEmpty) {
            self.showHint(sizeTextField.placeholder)
            return
        }
        if (YCStringUtils.getString(describeTextView.text).isEmpty) {
            self.showHint(describeTextView.placeholder)
            return
        }
        self.showHud(in: self.view, hint: "提交中...")
        API.sharedInstance.investorAdd(nameTextField.text!, phone: phoneTextField.text!, size: sizeTextField.text!, type: type, mark: describeTextView.text, success: { (model) in
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
