//
//  InstallerDetailViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/12.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class InstallerDetailViewController: BaseViewController, UIAlertViewDelegate {
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var addressLabel : UILabel!
    @IBOutlet weak var phoneLabel : UILabel!
    @IBOutlet weak var sizeLabel : UILabel!
    @IBOutlet weak var tipsLabel : UILabel!
    
    @IBOutlet weak var logoImageView : UIImageView!
    @IBOutlet weak var zhizhaoImageView : UIImageView!
    
    @IBOutlet weak var introView : UIView!
    @IBOutlet weak var introLabel : UILabel!
    
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
        self.showHud(in: self.view, hint: "加载中")
        API.sharedInstance.installerDetail(installer_id, success: { (installerDetail) in
                self.hideHud()
                self.setData(installerDetail)
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
        
        var size = "公司规模："
        if (installerDetail.company_size != nil) {
            size = size + installerDetail.company_size! + "人"
        } else {
            size = size + "未填写"
        }
        sizeLabel.text = size
        
        var phone = "联系方式："
        if (installerDetail.contact_info != nil) {
            phone = phone + installerDetail.contact_info!
        } else {
            phone = phone + "未填写"
        }
        phoneLabel.text = phone
        
        var location = "公司地址："
        if ((installerDetail.province_label) != nil) {
            location = location + installerDetail.province_label!
        }
        if ((installerDetail.city_label) != nil) {
            location = location + installerDetail.city_label!
        }
        if ((installerDetail.address) != nil) {
            location = location + installerDetail.address!
        }
        addressLabel.text = location
        
        if (installerDetail.is_installer == 2) {
            tipsLabel.text = "已认证"
            tipsLabel.textColor = Colors.installColor
        } else {
            tipsLabel.text = "未认证"
            tipsLabel.textColor = Colors.installRedColor
        }
        
        if (installerDetail.logo != nil) {
            logoImageView.setImageWith(URL.init(string: installerDetail.logo!)! as URL)
        }
        if (installerDetail.license_url != nil) {
            zhizhaoImageView.setImageWith(URL.init(string: installerDetail.license_url!)! as URL)
        }
        
        var intro = ""
        if (installerDetail.company_intro != nil) {
           intro = installerDetail.company_intro!
        }
        introLabel.text = intro
        let originHeight = introLabel.frame.size.height
        var height = MSLFrameUtil.getLabHeight(intro, fontSize: 15, width: introLabel.frame.size.width)
        if (originHeight > height) {
            height = originHeight
        }
        
        introLabel.frame = CGRect(x: introLabel.frame.origin.x, y: introLabel.frame.origin.y, width: introLabel.frame.size.width, height: height)
        
        introView.frame = CGRect(x: introView.frame.origin.x, y: introView.frame.origin.y, width: introView.frame.size.width, height: introView.frame.size.height + height - originHeight)
        
        scrollView.contentSize = CGSize(width: 0, height: introView.frame.maxY)
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
