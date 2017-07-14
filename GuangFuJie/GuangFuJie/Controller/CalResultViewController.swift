//
//  CalResultViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/12.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class CalResultViewController: BaseViewController {
    var calModel : CalcModel!
    var nameTextField : UITextField!
    var phoneTextField : UITextField!
    var eInfo : ElectricInfo!
    var polygon = ""
    var cityName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "预计收益"
        // Do any additional setup after loading the view.
        loadData()
    }
    
    func loadData() {
        self.showHud(in: self.view, hint: "加载中...")
        API.sharedInstance.caluateElectric(String(describing: calModel.type!), area_size: calModel.area!, province_id: calModel.province_id!, city_id: calModel.city_id!, polygon: polygon, success: { (electricInfo) in
                self.hideHud()
                self.eInfo = electricInfo
                self.initView()
            }) { (msg) in
                self.hideHud()
                self.showHint(msg)
                self.navigationController?.popViewController(animated: false)
        }
    }
    
    func submitButtonClicked() {
        if (nameTextField.text!.isEmpty) {
            self.showHint("请输入姓名")
            return
        }
        if (phoneTextField.text!.isEmpty) {
            self.showHint("请输入手机号")
            return
        }
         self.showHud(in: self.view, hint: "提交中...")
        API.sharedInstance.caluateSave(phoneTextField.text!, fullname: nameTextField.text!, type: calModel.type!, province_id: calModel.province_id!, city_id: calModel.city_id!, area_size: calModel.area!, success: { (commonModel) in
                self.hideHud()
                self.showHint("提交成功!")
                self.navigationController?.popViewController(animated: true)
            }) { (msg) in
                self.hideHud()
                self.showHint(msg)
        }
    }
    
    func initView() {
        var maxY: CGFloat = 0
        let icons = ["ic_cala_city", "ic_cala_size", "ic_cala_cost", "ic_cala_gov", "ic_cala_local", "ic_cala_rate", "ic_cala_ele", "ic_cala_year"]
        let names = ["所在城市", "屋顶面积", "造价", "政府每瓦补贴", "当地每瓦补贴", "年投资回报率", "预计年发电量", "预计年收益"]
        
        var titleStrs = [String]()
        titleStrs.append(cityName)
        titleStrs.append("\(StringUtils.getString(eInfo.area_size)) ㎡")
        titleStrs.append("\(StringUtils.getString(eInfo.costExpect)) 元")
        titleStrs.append("\(StringUtils.getString(eInfo.sGovernment)) 元")
        titleStrs.append("\(StringUtils.getString(eInfo.sLocal)) 元")
        titleStrs.append("\(StringUtils.getString(eInfo.costReturn)) %")
        titleStrs.append(String(format: "%.2f 度", StringUtils.getNumber(eInfo.year_du).floatValue))
        titleStrs.append("\(String(format: "%.2f", StringUtils.getNumber(eInfo.year_money).floatValue)) 元")
        
        let submitBottomView = UIView.init(frame: CGRect(x: 0, y: self.view.frame.size.height - 50, width: PhoneUtils.kScreenWidth, height: 50))
        submitBottomView.backgroundColor = UIColor.white
        self.view.addSubview(submitBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = submitBottomView.frame.size.height - 5 * 2
        
        let submitButton = UIButton.init(type: UIButtonType.custom)
        submitButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        submitButton.setTitle("提交", for: UIControlState.normal)
        submitButton.backgroundColor = Colors.appBlue
        submitButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: FontUtils.getFontSize(size: 17))
        submitButton.addTarget(self, action: #selector(self.submitButtonClicked), for: UIControlEvents.touchUpInside)
        submitBottomView.addSubview(submitButton)

        let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 64, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - submitBottomView.frame.size.height - 64))
        scrollView.backgroundColor = Colors.bkgColor
        self.view.addSubview(scrollView)
        
        var line: CGFloat = 0
        let resultBtnWidth = PhoneUtils.kScreenWidth / 2
        let resultBtnHeight = CGFloat(NSString(format: "%.0f", PhoneUtils.kScreenHeight / 14).floatValue)
        for i in 0..<icons.count {
            let button = UIButton.init(frame: CGRect(x: 0, y: line * resultBtnHeight, width: resultBtnWidth, height: resultBtnHeight))
            button.setImage(UIImage(named: icons[i]), for: UIControlState.normal)
            button.setTitle(names[i], for: UIControlState.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: FontUtils.getFontSize(size: 15))
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.backgroundColor = UIColor.white
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            button.contentEdgeInsets = UIEdgeInsetsMake(0, buttonWidth / 8, 0, 0)
            scrollView.addSubview(button)
            
            let label = UILabel.init(frame: CGRect(x: resultBtnWidth, y: line * resultBtnHeight, width: resultBtnWidth, height: resultBtnHeight))
            label.textAlignment = NSTextAlignment.center
            label.text = titleStrs[i]
            label.textColor = UIColor.lightGray
            label.font = UIFont.systemFont(ofSize: FontUtils.getFontSize(size: 15))
            label.backgroundColor = UIColor.white
            scrollView.addSubview(label)
            
            maxY = label.frame.maxY
            line += 1
        }
        
        nameTextField = UITextField.init(frame: CGRect(x: 0, y: maxY + 10, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight / 15))
        nameTextField.backgroundColor = UIColor.white
        nameTextField.leftViewMode = UITextFieldViewMode.always
        nameTextField.font = UIFont.systemFont(ofSize: FontUtils.getFontSize(size: 15))
        nameTextField.placeholder = "输入姓名"
        scrollView.addSubview(nameTextField)
        
        let nameLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth / 4, height: PhoneUtils.kScreenHeight / 15))
        nameLabel.text = "姓名"
        nameLabel.textAlignment = NSTextAlignment.center
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.systemFont(ofSize: FontUtils.getFontSize(size: 15))
        nameTextField.leftView = nameLabel
        
        phoneTextField = UITextField.init(frame: CGRect(x: 0, y: nameTextField.frame.maxY + 1, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight / 15))
        phoneTextField.backgroundColor = UIColor.white
        phoneTextField.leftViewMode = UITextFieldViewMode.always
        phoneTextField.font = UIFont.systemFont(ofSize: FontUtils.getFontSize(size: 15))
        phoneTextField.placeholder = "输入手机号"
        phoneTextField.keyboardType = UIKeyboardType.numberPad
        scrollView.addSubview(phoneTextField)
        
        let phoneLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth / 4, height: PhoneUtils.kScreenHeight / 15))
        phoneLabel.text = "手机号"
        phoneLabel.textAlignment = NSTextAlignment.center
        phoneLabel.textColor = UIColor.black
        phoneLabel.font = UIFont.systemFont(ofSize: FontUtils.getFontSize(size: 15))
        phoneTextField.leftView = phoneLabel
        
        let tipsLabel = UILabel.init(frame: CGRect(x: 0, y: phoneTextField.frame.maxY + 5, width: PhoneUtils.kScreenWidth, height: 20))
        tipsLabel.text = "请提交您的联系方式，马上需要预约工作人员上门安装！"
        tipsLabel.textAlignment = NSTextAlignment.center
        tipsLabel.adjustsFontSizeToFitWidth = true
        tipsLabel.backgroundColor = UIColor.clear
        scrollView.addSubview(tipsLabel)
        
        scrollView.contentSize = CGSize(width: 0, height: tipsLabel.frame.maxY + 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
