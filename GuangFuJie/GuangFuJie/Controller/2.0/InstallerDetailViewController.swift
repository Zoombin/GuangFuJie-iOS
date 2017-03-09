//
//  InstallerDetailViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/12.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class InstallerDetailViewController: BaseViewController, UIAlertViewDelegate {
    
    var nickNameLabel : UILabel!
    var phoneLabel : UILabel!
    var sizeLabel : UILabel!
    
    var addressButton : UIButton!
    
    var logoImageView : UIImageView!
    var nameLabel : UILabel!
    var tipsLabel : UILabel!
    var noticeButton : UIButton!
    
    var introLabel : UILabel!
    
    @IBOutlet weak var scrollView : UIScrollView!
    
    var installer_id : NSNumber!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
        initView()
    }
    
    func initView() {
        self.view.backgroundColor = UIColor.yellow
        scrollView.frame = CGRect(x: 0, y: scrollView.frame.origin.y, width: scrollView.frame.size.width, height: scrollView.frame.size.height - 50)
        
        let installViewBottomView = UIView.init(frame: CGRect(x: 0, y: PhoneUtils.kScreenHeight - 50, width: PhoneUtils.kScreenWidth, height: 50))
        installViewBottomView.backgroundColor = UIColor.white
        self.view.addSubview(installViewBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = installViewBottomView.frame.size.height - 5 * 2
        
        let installerButton = GFJBottomButton.init(type: UIButtonType.custom)
        installerButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        installerButton.setTitle("点我安装", for: UIControlState.normal)
        installerButton.backgroundColor = Colors.installColor
        installerButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        installerButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        installerButton.addTarget(self, action: #selector(self.tellPhoneUsButtonClicked), for: UIControlEvents.touchUpInside)
        installViewBottomView.addSubview(installerButton)
        
        let orignWidth: CGFloat = 70
        let orignHeight: CGFloat = 45
        let times: CGFloat = PhoneUtils.kScreenWidth / 320
        let imgWidth: CGFloat = orignWidth * times
        let imgHeight: CGFloat = orignHeight * times
        
        let dir: CGFloat = 10
        
        logoImageView = UIImageView.init(frame: CGRect(x: dir, y: dir, width: imgWidth, height: imgHeight))
        logoImageView.layer.borderColor = UIColor.lightGray.cgColor
        logoImageView.layer.borderWidth = 0.5
        scrollView.addSubview(logoImageView)
        
        let topLabelWidth = PhoneUtils.kScreenWidth - dir * 2 - imgWidth
        
        nameLabel = UILabel.init(frame: CGRect(x: logoImageView.frame.maxX + dir, y: logoImageView.frame.minY, width: topLabelWidth, height: imgHeight / 2))
        nameLabel.text = "公司名称"
        nameLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        scrollView.addSubview(nameLabel)
        
        tipsLabel = UILabel.init(frame: CGRect(x: logoImageView.frame.maxX + dir, y: nameLabel.frame.maxY, width: 70, height: imgHeight / 2))
        tipsLabel.text = "已认证"
        tipsLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        scrollView.addSubview(tipsLabel)
        
        noticeButton = UIButton.init(type: UIButtonType.custom)
        noticeButton.frame = CGRect(x: logoImageView.frame.maxX + dir, y: nameLabel.frame.maxY + (imgHeight / 2) * 0.1, width: 70, height: (imgHeight / 2) * 0.8)
        noticeButton.backgroundColor = Colors.installColor
        noticeButton.setTitle("通知审核", for: UIControlState.normal)
        noticeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        noticeButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        noticeButton.addTarget(self, action: #selector(self.remindButtonClicked), for: UIControlEvents.touchUpInside)
        noticeButton.isHidden = true
        scrollView.addSubview(noticeButton)
        
        let labelWidth = PhoneUtils.kScreenWidth / 2
        let labelHeight = PhoneUtils.kScreenHeight / 14
        
        nickNameLabel = UILabel.init(frame: CGRect(x: 0, y: logoImageView.frame.maxY + dir, width: labelWidth, height: labelHeight))
        nickNameLabel.text = ""
        nickNameLabel.layer.borderColor = UIColor.lightGray.cgColor
        nickNameLabel.layer.borderWidth = 0.5
        nickNameLabel.textAlignment = NSTextAlignment.center
        nickNameLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        scrollView.addSubview(nickNameLabel)
        
        phoneLabel = UILabel.init(frame: CGRect(x: labelWidth, y: logoImageView.frame.maxY + dir, width: labelWidth, height: labelHeight))
        phoneLabel.text = ""
        phoneLabel.layer.borderColor = UIColor.lightGray.cgColor
        phoneLabel.layer.borderWidth = 0.5
        phoneLabel.textAlignment = NSTextAlignment.center
        phoneLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        scrollView.addSubview(phoneLabel)
        
        let titleSizeLabel = UILabel.init(frame: CGRect(x: 0, y: nickNameLabel.frame.maxY, width: labelWidth, height: labelHeight))
        titleSizeLabel.text = "公司规模"
        titleSizeLabel.layer.borderColor = UIColor.lightGray.cgColor
        titleSizeLabel.layer.borderWidth = 0.5
        titleSizeLabel.textAlignment = NSTextAlignment.center
        titleSizeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        scrollView.addSubview(titleSizeLabel)
        
        sizeLabel = UILabel.init(frame: CGRect(x: labelWidth, y: nickNameLabel.frame.maxY, width: labelWidth, height: labelHeight))
        sizeLabel.text = ""
        sizeLabel.layer.borderColor = UIColor.lightGray.cgColor
        sizeLabel.layer.borderWidth = 0.5
        sizeLabel.textAlignment = NSTextAlignment.center
        sizeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        scrollView.addSubview(sizeLabel)
        
        addressButton = UIButton.init(type: UIButtonType.custom)
        addressButton.frame = CGRect(x:0, y:titleSizeLabel.frame.maxY, width: PhoneUtils.kScreenWidth, height: labelHeight)
        addressButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        addressButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        addressButton.setImage(UIImage(named: "roof_location"), for: UIControlState.normal)
        scrollView.addSubview(addressButton)
        
        introLabel = UILabel.init(frame: CGRect(x: dir, y: addressButton.frame.maxY, width: PhoneUtils.kScreenWidth - dir * 2, height: 0))
        introLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        introLabel.numberOfLines = 0
        introLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        scrollView.addSubview(introLabel)
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
    
    func addFavButton(isFav : Bool) {
        if (isFav) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelFavButtonClicked))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "收藏", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.favButtonClicked))
        }
    }
    
    func favButtonClicked() {
        self.showHud(in: self.view, hint: "加载中")
        API.sharedInstance.favInstaller(installer_id, { (model) in
            self.hideHud()
            self.showHint("收藏成功")
            self.loadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    func cancelFavButtonClicked() {
        self.showHud(in: self.view, hint: "加载中")
        API.sharedInstance.unFavInstaller(installer_id, { (model) in
            self.hideHud()
            self.showHint("取消收藏成功")
            self.loadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    func loadData() {
        self.showHud(in: self.view, hint: "加载中")
        API.sharedInstance.installerDetail(installer_id, success: { (installerDetail) in
                self.hideHud()
                self.setData(installerDetail)
                self.addFavButton(isFav: installerDetail.is_favor!.boolValue)
            }) { (msg) in
                self.hideHud()
                self.showHint(msg)
        }
    }
    
    func setData(_ installerDetail : InstallInfo) {
        var name = ""
        if (installerDetail.company_name != nil) {
            name = installerDetail.company_name!
        }
        nameLabel.text = name
        self.title = name
        
        var nickName = ""
        if (installerDetail.fullname != nil) {
            nickName = installerDetail.fullname!
        }
        nickNameLabel.text = nickName

        var size = ""
        if (installerDetail.company_size != nil) {
            size = size + installerDetail.company_size! + "人"
        } else {
            size = size + "未填写"
        }
        sizeLabel.text = size

        var phone = ""
        if (installerDetail.contact_info != nil) {
            phone = phone + installerDetail.contact_info!
        } else {
            phone = phone + "未填写"
        }
        phoneLabel.text = phone

        var location = ""
        if ((installerDetail.province_label) != nil) {
            location = location + installerDetail.province_label!
        }
        if ((installerDetail.city_label) != nil) {
            location = location + installerDetail.city_label!
        }
        if ((installerDetail.address) != nil) {
            location = location + installerDetail.address!
        }
        addressButton.setTitle(location, for: UIControlState.normal)
        
        if (installerDetail.is_installer == 2) {
            tipsLabel.text = "已认证"
            tipsLabel.textColor = Colors.installColor
        } else {
            if (UserDefaultManager.getUser()!.user_id!.intValue == installerDetail.user_id!.intValue) {
                noticeButton.isHidden = false
                tipsLabel.isHidden = true
            } else {
                tipsLabel.text = "未认证"
                tipsLabel.textColor = Colors.installRedColor
            }
        }

        if (installerDetail.logo != nil) {
            logoImageView.setImageWith(URL.init(string: installerDetail.logo!)! as URL)
        } else {
            logoImageView.image = UIImage(named: "ic_avatar_yezhu")
        }
        
        var intro = ""
        if (installerDetail.company_intro != nil) {
           intro = installerDetail.company_intro!
        }
        introLabel.text = intro
        let originHeight = introLabel.frame.size.height
        var height = MSLFrameUtil.getLabHeight(intro, fontSize: Dimens.fontSizeComm, width: introLabel.frame.size.width)
        if (originHeight > height) {
            height = originHeight
        }

        introLabel.frame = CGRect(x: introLabel.frame.origin.x, y: introLabel.frame.origin.y, width: introLabel.frame.size.width, height: height)
        
        scrollView.contentSize = CGSize(width: 0, height: introLabel.frame.maxY)
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
