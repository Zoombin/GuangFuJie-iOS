//
//  InstallerDetailViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/12.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class InstallerDetailViewController: BaseViewController, UIAlertViewDelegate {
    var introLabel : UILabel!
    
    var nameLabel = UILabel()
    
    var createTimeButton = UIButton()
    var registerMoneyButton = UIButton()
    
    var contractLabel = UILabel()
    var mailLabel = UILabel()
    var websiteLabel = UILabel()
    var addressLabel = UILabel()
    
    var describeLabel = UILabel()
    
    var secondView = UIView()
    var thirdView = UIView()
    var fourthView = UIView()
    
    var installerInfo: InstallInfo?
    
    var bkgScrollView = UIScrollView()
    
    var dir = 10 * (PhoneUtils.kScreenWidth / 750)
    var times = PhoneUtils.kScreenWidth / 750
    
    var installer_id : NSNumber!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        loadData()
    }
    
    func initView() {
        self.title = "安装商详情"
        bkgScrollView.frame = CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight)
        bkgScrollView.backgroundColor = UIColor.clear
        self.view.addSubview(bkgScrollView)
        
        nameLabel.frame = CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 110 * times)
        nameLabel.backgroundColor = Colors.installColor
        nameLabel.textAlignment = NSTextAlignment.center
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm2)
        nameLabel.adjustsFontSizeToFitWidth = true
        bkgScrollView.addSubview(nameLabel)
        
        initSecondView()
        initThirdView()
        initFourthView()
    }
    
    func initSecondView() {
        secondView = UIView.init(frame: CGRect(x: 0, y: nameLabel.frame.maxY + dir, width: PhoneUtils.kScreenWidth, height: 130 * times))
        secondView.backgroundColor = UIColor.white
        bkgScrollView.addSubview(secondView)
        
        createTimeButton.frame = CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth / 2, height: 130 * times)
        createTimeButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        createTimeButton.setImage(UIImage(named: "ic_installer_createtime"), for: UIControlState.normal)
        createTimeButton.setTitle("0000-00-00", for: UIControlState.normal)
        createTimeButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        let imageSize1: CGSize = createTimeButton.imageView!.frame.size
        let titleSize1: CGSize = createTimeButton.titleLabel!.frame.size
        createTimeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left:-imageSize1.width, bottom: -imageSize1.height - dir, right: 0)
        createTimeButton.imageEdgeInsets = UIEdgeInsets(top: -titleSize1.height - dir, left: 0, bottom: 0, right: -titleSize1.width)
        secondView.addSubview(createTimeButton)
        
        registerMoneyButton.frame = CGRect(x: PhoneUtils.kScreenWidth / 2, y: 0, width: PhoneUtils.kScreenWidth / 2, height: 130 * times)
        registerMoneyButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        registerMoneyButton.setImage(UIImage(named: "ic_installer_money"), for: UIControlState.normal)
        registerMoneyButton.setTitle("注册资本", for: UIControlState.normal)
        registerMoneyButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        let imageSize2: CGSize = registerMoneyButton.imageView!.frame.size
        let titleSize2: CGSize = registerMoneyButton.titleLabel!.frame.size
        registerMoneyButton.titleEdgeInsets = UIEdgeInsets(top: 0, left:-imageSize2.width, bottom: -imageSize2.height - dir, right: 0)
        registerMoneyButton.imageEdgeInsets = UIEdgeInsets(top: -titleSize2.height - dir, left: 0, bottom: 0, right: -titleSize2.width)
        secondView.addSubview(registerMoneyButton)
        
        let line1 = UILabel.init(frame: CGRect(x: PhoneUtils.kScreenWidth / 2, y: 130 * times * 0.15, width: 0.5, height: 130 * times * 0.7))
        line1.backgroundColor = Colors.topButtonColor
        secondView.addSubview(line1)
    }
    
    func initThirdView() {
        thirdView = UIView.init(frame: CGRect(x: 0, y: secondView.frame.maxY + dir, width: PhoneUtils.kScreenWidth, height: 390 * times))
        thirdView.backgroundColor = UIColor.white
        bkgScrollView.addSubview(thirdView)
        
        let labelHeight: CGFloat = thirdView.frame.size.height / 6
        
        let thirdleftView = UILabel.init(frame: CGRect(x: 0, y: 0, width: labelHeight * 0.75, height: labelHeight))
        thirdleftView.text = " |"
        thirdleftView.textColor = Colors.installColor
        thirdleftView.textAlignment = NSTextAlignment.center
        thirdleftView.backgroundColor = UIColor.white
        thirdleftView.font = UIFont.boldSystemFont(ofSize: Dimens.fontSizeComm)
        thirdView.addSubview(thirdleftView)
        
        let thirdheaderView = UILabel.init(frame: CGRect(x: thirdleftView.frame.maxX - 0.5, y: 0, width: (PhoneUtils.kScreenWidth / 2) - thirdleftView.frame.maxX, height: labelHeight))
        thirdheaderView.text = "联系方式"
        thirdheaderView.backgroundColor = UIColor.white
        thirdheaderView.textColor = Colors.installColor
        thirdheaderView.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm2)
        thirdView.addSubview(thirdheaderView)
        
        let contractNameTitle = UILabel.init(frame: CGRect(x: thirdleftView.frame.maxX - 0.5, y: thirdheaderView.frame.maxY, width: 175 * times, height: labelHeight))
        contractNameTitle.text = "联系人"
        contractNameTitle.backgroundColor = UIColor.white
        contractNameTitle.textColor = UIColor.lightGray
        contractNameTitle.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        thirdView.addSubview(contractNameTitle)
        
        contractLabel.frame = CGRect(x: contractNameTitle.frame.maxX, y: thirdheaderView.frame.maxY, width: PhoneUtils.kScreenWidth - contractNameTitle.frame.maxX - 2 * dir, height: labelHeight)
        contractLabel.backgroundColor = UIColor.white
        contractLabel.textColor = UIColor.black
        contractLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        thirdView.addSubview(contractLabel)
        
        let mailTitle = UILabel.init(frame: CGRect(x: thirdleftView.frame.maxX - 0.5, y: contractNameTitle.frame.maxY, width: 175 * times, height: labelHeight))
        mailTitle.text = "邮箱"
        mailTitle.backgroundColor = UIColor.white
        mailTitle.textColor = UIColor.lightGray
        mailTitle.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        thirdView.addSubview(mailTitle)
        
        mailLabel.frame = CGRect(x: mailTitle.frame.maxX, y: contractNameTitle.frame.maxY, width: PhoneUtils.kScreenWidth - contractNameTitle.frame.maxX - 2 * dir, height: labelHeight)
        mailLabel.backgroundColor = UIColor.white
        mailLabel.textColor = UIColor.black
        mailLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        thirdView.addSubview(mailLabel)
        
        let websiteTitle = UILabel.init(frame: CGRect(x: thirdleftView.frame.maxX - 0.5, y: mailTitle.frame.maxY, width: 175 * times, height: labelHeight))
        websiteTitle.text = "网址"
        websiteTitle.backgroundColor = UIColor.white
        websiteTitle.textColor = UIColor.lightGray
        websiteTitle.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        thirdView.addSubview(websiteTitle)
        
        websiteLabel.frame = CGRect(x: websiteTitle.frame.maxX, y: mailTitle.frame.maxY, width: PhoneUtils.kScreenWidth - contractNameTitle.frame.maxX - 2 * dir, height: labelHeight)
        websiteLabel.backgroundColor = UIColor.white
        websiteLabel.textColor = UIColor.black
        websiteLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        thirdView.addSubview(websiteLabel)
        
        let addressTitle = UILabel.init(frame: CGRect(x: thirdleftView.frame.maxX - 0.5, y: websiteTitle.frame.maxY, width: 175 * times, height: labelHeight * 2))
        addressTitle.text = "地址"
        addressTitle.backgroundColor = UIColor.white
        addressTitle.textColor = UIColor.lightGray
        addressTitle.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        thirdView.addSubview(addressTitle)
        
        addressLabel.frame = CGRect(x: addressTitle.frame.maxX, y: websiteTitle.frame.maxY, width: PhoneUtils.kScreenWidth - contractNameTitle.frame.maxX - 2 * dir, height: labelHeight * 2)
        addressLabel.backgroundColor = UIColor.white
        addressLabel.textColor = UIColor.black
        addressLabel.numberOfLines = 0
        addressTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        addressLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        thirdView.addSubview(addressLabel)
    }
    
    func initFourthView() {
        let labelHeight: CGFloat = thirdView.frame.size.height / 6
        
        fourthView = UIView.init(frame: CGRect(x: 0, y: thirdView.frame.maxY + dir, width: PhoneUtils.kScreenWidth, height: 568 * times))
        fourthView.backgroundColor = UIColor.white
        bkgScrollView.addSubview(fourthView)
        
        let fourthleftView = UILabel.init(frame: CGRect(x: 0, y: 0, width: labelHeight * 0.75, height: labelHeight))
        fourthleftView.text = " |"
        fourthleftView.textColor = Colors.installColor
        fourthleftView.textAlignment = NSTextAlignment.center
        fourthleftView.backgroundColor = UIColor.white
        fourthleftView.font = UIFont.boldSystemFont(ofSize: Dimens.fontSizeComm)
        fourthView.addSubview(fourthleftView)
        
        let fourthheaderView = UILabel.init(frame: CGRect(x: fourthleftView.frame.maxX - 0.5, y: 0, width: (PhoneUtils.kScreenWidth / 2) - fourthleftView.frame.maxX, height: labelHeight))
        fourthheaderView.text = "经营范围"
        fourthheaderView.backgroundColor = UIColor.white
        fourthheaderView.textColor = Colors.installColor
        fourthheaderView.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm2)
        fourthView.addSubview(fourthheaderView)
        
        describeLabel.frame = CGRect(x: dir, y: fourthheaderView.frame.maxY, width: PhoneUtils.kScreenWidth - 2 * dir, height: 0)
        describeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        describeLabel.numberOfLines = 0
        describeLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        fourthleftView.addSubview(describeLabel)
    }
    
    func tellPhoneUsButtonClicked() {
        let alertView = UIAlertView.init(title: "提示", message: "是否拨打电话给客服？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertView.show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if (alertView.cancelButtonIndex != buttonIndex) {
            UIApplication.shared.openURL(URL.init(string: "tel://4006229666")! as URL)
        }
    }
    
    func loadData() {
        if (installerInfo != nil) {
            self.setData(installerInfo!)
        }
    }
    
    func setData(_ model: InstallInfo) {
        createTimeButton.setTitle(StringUtils.getString(model.establishDate), for: UIControlState.normal)
        registerMoneyButton.setTitle("\(StringUtils.getString(model.capital))万元", for: UIControlState.normal)
        
        nameLabel.text = StringUtils.getString(model.companyName)
        contractLabel.text = StringUtils.getString(model.corporation)
        mailLabel.text = StringUtils.getString(model.email)
        websiteLabel.text = StringUtils.getString(model.website)
        addressLabel.text = StringUtils.getString(model.address)
        
        describeLabel.text = StringUtils.getString(model.scope)
        
        let labelHeight = MSLFrameUtil.getLabHeight(describeLabel.text, font: describeLabel.font, width: PhoneUtils.kScreenWidth - 2 * dir)
        
        describeLabel.frame = CGRect(x: dir, y: describeLabel.frame.origin.y, width: PhoneUtils.kScreenWidth - 2 * dir, height: labelHeight)
        bkgScrollView.contentSize = CGSize(width: 0, height: describeLabel.frame.maxY)
    }
    
    func remindButtonClicked() {
        API.sharedInstance.remindAuth({ (commonModel) in
            self.showHint("提醒成功")
        }) { (msg) in
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
