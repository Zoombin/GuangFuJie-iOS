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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "预计收益"
        // Do any additional setup after loading the view.
        loadData()
    }
    
    func loadData() {
        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.caluateElectric(String(calModel.type!), area_size: calModel.area!, province_id: calModel.province_id!, city_id: calModel.city_id!, success: { (electricInfo) in
                self.hideHud()
                self.eInfo = electricInfo
                self.initView()
            }) { (msg) in
                self.hideHud()
                self.showHint(msg)
                self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func submitButtonClicked() {
         self.showHudInView(self.view, hint: "提交中...")
        API.sharedInstance.caluateSave(phoneTextField.text!, fullname: nameTextField.text!, type: calModel.type!, province_id: calModel.province_id!, city_id: calModel.city_id!, area_size: calModel.area!, success: { (commonModel) in
                self.hideHud()
                self.showHint("提交成功!")
                self.navigationController?.popViewControllerAnimated(true)
            }) { (msg) in
                self.hideHud()
                self.showHint(msg)
        }
    }
    
    func initView() {
        let titleStrs = NSMutableArray()
        titleStrs.addObject("节约用煤\n" + String(eInfo.c!) + "吨/年")
        titleStrs.addObject("减排二氧化硫\n" + String(eInfo.so2!) + "吨/年")
        titleStrs.addObject("减排粉尘\n" + String(eInfo.dust!) + "吨/年")
        titleStrs.addObject("减排二氧化碳\n" + String(eInfo.co2!) + "吨/年")
        titleStrs.addObject("减排一氧化物\n" + String(eInfo.xo1!) + "吨/年")
        titleStrs.addObject("减排氮化物\n" + String(eInfo.no!) + "吨/年")
        
        let earnMoney = "预计收益:" + String(eInfo.year_money!) + "元/年"
        
        let submitBottomView = UIView.init(frame: CGRectMake(0, self.view.frame.size.height - 50, PhoneUtils.kScreenWidth, 50))
        submitBottomView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(submitBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = submitBottomView.frame.size.height - 5 * 2
        
        let submitButton = UIButton.init(type: UIButtonType.Custom)
        submitButton.frame = CGRectMake(5, 5, buttonWidth, buttonHeight)
        submitButton.setTitle("提交", forState: UIControlState.Normal)
        submitButton.backgroundColor = Colors.installColor
        submitButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        submitButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge2)
        submitButton.addTarget(self, action: #selector(self.submitButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        submitBottomView.addSubview(submitButton)
        
        let scrollView = UIScrollView.init(frame: CGRectMake(0, 64, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - submitBottomView.frame.size.height - 64))
        scrollView.backgroundColor = Colors.bkgGray
        self.view.addSubview(scrollView)
        
        let iconView = UIView.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight * 0.4))
        iconView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(iconView)
        
        let viewWidth = iconView.frame.size.width / 3
        let icons = ["ic_calc_c", "ic_calc_so2", "ic_calc_dust", "ic_calc_co2", "ic_calc_co", "ic_calc_no"]
        
        var line : CGFloat = 0
        var index : CGFloat = 0
        let iconWidth : CGFloat = viewWidth * 0.5
        let iconHeight : CGFloat = iconWidth
        
        let iconTopOffSetY : CGFloat = iconHeight * 0.15
        
        let iconOffSetX : CGFloat = (iconView.frame.size.width - iconWidth * 3) / 4
        let iconOffSetY : CGFloat = (iconView.frame.size.height - iconHeight * 2 - iconTopOffSetY * 2) / 2
        
        
        
        for i in 0..<icons.count {
            if (i != 0 && index%3 == 0) {
                index = 0
                line += 1
            }
            let imageView = UIImageView.init(frame: CGRectMake(iconOffSetX * (index + 1) + index * iconWidth, iconTopOffSetY * (line + 1) + iconOffSetY * line + line * iconHeight, iconWidth, iconHeight))
            imageView.image = UIImage(named: icons[i])
            iconView.addSubview(imageView)
            
            let label = UILabel.init(frame: CGRectMake(imageView.frame.origin.x - 0.1 * iconWidth, CGRectGetMaxY(imageView.frame), iconWidth * 1.2, iconOffSetY * 0.7))
            label.text = titleStrs[i] as! String
            label.textAlignment = NSTextAlignment.Center
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.ByWordWrapping
            label.textColor = UIColor.lightGrayColor()
            label.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
            iconView.addSubview(label)
            
            index += 1
        }
        
        let canEarnMoney = UILabel.init(frame: CGRectMake(0, CGRectGetMaxY(iconView.frame), PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight * 0.1))
        canEarnMoney.textColor = Colors.installRedColor
        canEarnMoney.font = UIFont.systemFontOfSize(Dimens.fontSizelarge)
        canEarnMoney.textAlignment = NSTextAlignment.Center
        canEarnMoney.text = earnMoney
        canEarnMoney.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(canEarnMoney)
        
        let tipsLabel = UILabel.init(frame: CGRectMake(0, CGRectGetMaxY(canEarnMoney.frame) + 10, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight * 0.12))
        tipsLabel.text = "您需要客户联系回访吗?\n您需要工作人员上门\n您需要预约安装吗？"
        tipsLabel.backgroundColor = UIColor.whiteColor()
        tipsLabel.numberOfLines = 0
        tipsLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        scrollView.addSubview(tipsLabel)
        
        nameTextField = UITextField.init(frame: CGRectMake(0, CGRectGetMaxY(tipsLabel.frame), PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight / 15))
        nameTextField.backgroundColor = UIColor.whiteColor()
        nameTextField.leftViewMode = UITextFieldViewMode.Always
        nameTextField.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        nameTextField.placeholder = "输入姓名"
        scrollView.addSubview(nameTextField)
        
        let nameLabel = UILabel.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth / 4, PhoneUtils.kScreenHeight / 15))
        nameLabel.text = "姓名"
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.textColor = UIColor.blackColor()
        nameLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        nameTextField.leftView = nameLabel
        
        phoneTextField = UITextField.init(frame: CGRectMake(0, CGRectGetMaxY(nameTextField.frame) + 1, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight / 15))
        phoneTextField.backgroundColor = UIColor.whiteColor()
        phoneTextField.leftViewMode = UITextFieldViewMode.Always
        phoneTextField.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        phoneTextField.placeholder = "输入手机号"
        scrollView.addSubview(phoneTextField)
        
        let phoneLabel = UILabel.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth / 4, PhoneUtils.kScreenHeight / 15))
        phoneLabel.text = "手机号"
        phoneLabel.textAlignment = NSTextAlignment.Center
        phoneLabel.textColor = UIColor.blackColor()
        phoneLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        phoneTextField.leftView = phoneLabel
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
