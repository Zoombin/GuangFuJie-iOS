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
                self.navigationController?.popViewController(animated: true)
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
        let titleStrs = NSMutableArray()
        titleStrs.add("节约用煤\n" + String(format: "%.1f", eInfo.c!.floatValue) + "吨/年")
        titleStrs.add("减排二氧化硫\n" + String(format: "%.1f", eInfo.so2!.floatValue) + "吨/年")
        titleStrs.add("减排粉尘\n" + String(format: "%.1f", eInfo.dust!.floatValue) + "吨/年")
        titleStrs.add("减排二氧化碳\n" + String(format: "%.1f", eInfo.co2!.floatValue) + "吨/年")
        titleStrs.add("种植植物\n" + String(format: "%.1f", eInfo.plant!.floatValue) + "棵")
        titleStrs.add("行驶里程\n" + String(format: "%.1f", eInfo.mileage!.floatValue) + "公里")
        
        let areaSize = "屋顶面积:" +  String(format: "%.2f", NSString.init(string: eInfo.area_size!).floatValue) + "㎡"
        let electricDu = "预计发电:" + String(describing: eInfo.year_du!) + "度/年"
        let earnMoney = "预计收益:" + String(describing: eInfo.year_money!) + "元/年"
        
        let submitBottomView = UIView.init(frame: CGRect(x: 0, y: self.view.frame.size.height - 50, width: PhoneUtils.kScreenWidth, height: 50))
        submitBottomView.backgroundColor = UIColor.white
        self.view.addSubview(submitBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = submitBottomView.frame.size.height - 5 * 2
        
        let submitButton = UIButton.init(type: UIButtonType.custom)
        submitButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        submitButton.setTitle("提交", for: UIControlState.normal)
        submitButton.backgroundColor = Colors.installColor
        submitButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        submitButton.addTarget(self, action: #selector(self.submitButtonClicked), for: UIControlEvents.touchUpInside)
        submitBottomView.addSubview(submitButton)
        
        let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 64, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - submitBottomView.frame.size.height - 64))
        scrollView.backgroundColor = Colors.bkgGray
        self.view.addSubview(scrollView)
        
        let iconView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight * 0.4))
        iconView.backgroundColor = UIColor.white
        scrollView.addSubview(iconView)
        
        let viewWidth = iconView.frame.size.width / 3
        let icons = ["ic_calc_c", "ic_calc_so2", "ic_calc_dust", "ic_calc_co2", "ic_calc_zhi", "ic_calc_li"]
        
        var line : CGFloat = 0
        var index : CGFloat = 0
        let iconWidth : CGFloat = viewWidth * 0.5
        let iconHeight : CGFloat = iconWidth
        
        let iconTopOffSetY : CGFloat = iconHeight * 0.15
        
        let iconOffSetX : CGFloat = (iconView.frame.size.width - iconWidth * 3) / 4
        let iconOffSetY : CGFloat = (iconView.frame.size.height - iconHeight * 2 - iconTopOffSetY * 2) / 2
        
        
        
        for i in 0..<icons.count {
            if (i != 0 && index.truncatingRemainder(dividingBy: 3) == 0) {
                index = 0
                line += 1
            }
            let imageView = UIImageView.init(frame: CGRect(x: iconOffSetX * (index + 1) + index * iconWidth, y: iconTopOffSetY * (line + 1) + iconOffSetY * line + line * iconHeight, width: iconWidth, height: iconHeight))
            imageView.image = UIImage(named: icons[i])
            iconView.addSubview(imageView)
            
            let label = UILabel.init(frame: CGRect(x: imageView.frame.origin.x - 0.5 * iconWidth, y: imageView.frame.maxY, width: iconWidth * 2, height: iconOffSetY * 0.7))
            label.text = titleStrs[i] as! String
            label.textAlignment = NSTextAlignment.center
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.textColor = UIColor.lightGray
            label.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
            iconView.addSubview(label)
            
            index += 1
        }
        
        let moneyWidth = (PhoneUtils.kScreenWidth / 4 - 15) / 2
        let moneyLeftView = UIView.init(frame: CGRect(x: 0, y: (iconView.frame).maxY + 1, width: moneyWidth, height: PhoneUtils.kScreenHeight * 0.1))
        moneyLeftView.backgroundColor = UIColor.white
        scrollView.addSubview(moneyLeftView)
        
        let canEarnMoney = UILabel.init(frame: CGRect(x: moneyWidth, y: (iconView.frame).maxY + 1, width: PhoneUtils.kScreenWidth - moneyWidth, height: PhoneUtils.kScreenHeight * 0.1))
        canEarnMoney.textColor = Colors.installRedColor
        canEarnMoney.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        canEarnMoney.numberOfLines = 0
        canEarnMoney.lineBreakMode = NSLineBreakMode.byWordWrapping
        canEarnMoney.textAlignment = NSTextAlignment.left
        canEarnMoney.text = areaSize + "\n" + electricDu + "\n" + earnMoney
        canEarnMoney.backgroundColor = UIColor.white
        scrollView.addSubview(canEarnMoney)
        
        nameTextField = UITextField.init(frame: CGRect(x: 0, y: (canEarnMoney.frame).maxY + 1, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight / 15))
        nameTextField.backgroundColor = UIColor.white
        nameTextField.leftViewMode = UITextFieldViewMode.always
        nameTextField.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        nameTextField.placeholder = "输入姓名"
        scrollView.addSubview(nameTextField)
        
        let nameLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth / 4, height: PhoneUtils.kScreenHeight / 15))
        nameLabel.text = "姓名"
        nameLabel.textAlignment = NSTextAlignment.center
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        nameTextField.leftView = nameLabel
        
        phoneTextField = UITextField.init(frame: CGRect(x: 0, y: nameTextField.frame.maxY + 1, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight / 15))
        phoneTextField.backgroundColor = UIColor.white
        phoneTextField.leftViewMode = UITextFieldViewMode.always
        phoneTextField.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        phoneTextField.placeholder = "输入手机号"
        phoneTextField.keyboardType = UIKeyboardType.numberPad
        scrollView.addSubview(phoneTextField)
        
        let phoneLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth / 4, height: PhoneUtils.kScreenHeight / 15))
        phoneLabel.text = "手机号"
        phoneLabel.textAlignment = NSTextAlignment.center
        phoneLabel.textColor = UIColor.black
        phoneLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        phoneTextField.leftView = phoneLabel
        
        let tipsLabel = UILabel.init(frame: CGRect(x: 0, y: phoneTextField.frame.maxY + 5, width: PhoneUtils.kScreenWidth, height: 20))
        tipsLabel.text = "您需要客户联系回访吗? 您需要工作人员上门吗？您需要预约安装吗？"
        tipsLabel.textAlignment = NSTextAlignment.center
        tipsLabel.adjustsFontSizeToFitWidth = true
        tipsLabel.backgroundColor = UIColor.clear
        scrollView.addSubview(tipsLabel)
        
        scrollView.contentSize = CGSize(width: 0, height: scrollView.frame.size.height + 1)
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
