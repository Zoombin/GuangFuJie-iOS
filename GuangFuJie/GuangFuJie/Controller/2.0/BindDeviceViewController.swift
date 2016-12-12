//
//  BindDeviceViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/10.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class BindDeviceViewController: BaseViewController {
    var ystButton : UIButton!
    var gwtButton : UIButton!
    var grwtButton : UIButton!
    var khsyButton : UIButton!
    
    var deviceView : UIView!
    var deviceBkgImageView : UIImageView!
    var deviceTipsLabel : UILabel!
    var deviceTextField : UITextField!
    var currentDeviceType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "绑定设备"
        // Do any additional setup after loading the view.
        initView()
    }
    
    func initView() {
        let topView = UIView.init(frame: CGRectMake(0, 64, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight / 12))
        self.view.addSubview(topView)
        
        let buttonWidth = PhoneUtils.kScreenWidth / 4
        let buttonHeight = PhoneUtils.kScreenHeight / 12
        
        ystButton = UIButton.init(type: UIButtonType.Custom)
        ystButton.setImage(UIImage(named: "ic_dev_yst_img0"), forState: UIControlState.Normal)
        ystButton.setImage(UIImage(named: "ic_dev_yst_img1"), forState: UIControlState.Selected)
        ystButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        ystButton.tag = 0
        ystButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight)
        topView.addSubview(ystButton)
        
        gwtButton = UIButton.init(type: UIButtonType.Custom)
        gwtButton.setImage(UIImage(named: "ic_dev_gdw_img0"), forState: UIControlState.Normal)
        gwtButton.setImage(UIImage(named: "ic_dev_gdw_img1"), forState: UIControlState.Selected)
        gwtButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        gwtButton.tag = 1
        gwtButton.frame = CGRectMake(buttonWidth, 0, buttonWidth, buttonHeight)
        topView.addSubview(gwtButton)
        
        grwtButton = UIButton.init(type: UIButtonType.Custom)
        grwtButton.setImage(UIImage(named: "ic_dev_grwt_img0"), forState: UIControlState.Normal)
        grwtButton.setImage(UIImage(named: "ic_dev_grwt_img1"), forState: UIControlState.Selected)
        grwtButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        grwtButton.tag = 2
        grwtButton.frame = CGRectMake(buttonWidth * 2, 0, buttonWidth, buttonHeight)
        topView.addSubview(grwtButton)
        
        khsyButton = UIButton.init(type: UIButtonType.Custom)
        khsyButton.setImage(UIImage(named: "ic_dev_khkj_img0"), forState: UIControlState.Normal)
        khsyButton.setImage(UIImage(named: "ic_dev_khkj_img1"), forState: UIControlState.Selected)
        khsyButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        khsyButton.tag = 3
        khsyButton.frame = CGRectMake(buttonWidth * 3, 0, buttonWidth, buttonHeight)
        topView.addSubview(khsyButton)
        
        deviceView = UIView.init(frame: CGRectMake(0, 64 + topView.frame.size.height, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - 64 - topView.frame.size.height))
        deviceView.backgroundColor = Colors.bkgGray
        self.view.addSubview(deviceView)
        
        initBindCenterView()
    }
    
    func initBindCenterView() {
        let deviceBottomView = UIView.init(frame: CGRectMake(0, deviceView.frame.size.height - 50, PhoneUtils.kScreenWidth, 50))
        deviceBottomView.backgroundColor = UIColor.whiteColor()
        deviceView.addSubview(deviceBottomView)
        
        let bindButton = UIButton.init(type: UIButtonType.Custom)
        bindButton.frame = CGRectMake(5, 5, PhoneUtils.kScreenWidth - 5 * 2, deviceBottomView.frame.size.height - 5 * 2)
        bindButton.setTitle("绑定设备", forState: UIControlState.Normal)
        bindButton.backgroundColor = Colors.installColor
        bindButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        bindButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge2)
        bindButton.addTarget(self, action: #selector(self.bindButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        deviceBottomView.addSubview(bindButton)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = deviceBottomView.frame.size.height - 5 * 2
        
        let width = PhoneUtils.kScreenWidth * 0.6
        let height = (231 * width) / 309
        
        deviceBkgImageView = UIImageView.init(frame: CGRectMake((PhoneUtils.kScreenWidth - width) / 2, 8, width, height))
        deviceBkgImageView.image = UIImage(named: "device_gsm")
        deviceView.addSubview(deviceBkgImageView)
        
        deviceTipsLabel = UILabel.init(frame: CGRectMake((PhoneUtils.kScreenWidth - buttonWidth) / 2, CGRectGetMaxY(deviceBkgImageView.frame) + 8, buttonWidth, buttonHeight))
        deviceTipsLabel.text = "请输入10位S/N码"
        deviceTipsLabel.textAlignment = NSTextAlignment.Center
        deviceTipsLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        deviceTipsLabel.textColor = UIColor.blackColor()
        deviceView.addSubview(deviceTipsLabel)
        
        deviceTextField = UITextField.init(frame: CGRectMake((PhoneUtils.kScreenWidth - buttonWidth * 0.9) / 2, CGRectGetMaxY(deviceTipsLabel.frame) + 8, buttonWidth * 0.9, buttonHeight))
        deviceTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        deviceTextField.backgroundColor = UIColor.whiteColor()
        deviceView.addSubview(deviceTextField)
    }
    
    func topButtonClicked(button: UIButton) {
        ystButton.selected = false
        gwtButton.selected = false
        grwtButton.selected = false
        khsyButton.selected = false
        
        if (button.tag == 0) {
            ystButton.selected = true
            resetDeviceType()
        } else if (button.tag == 1) {
            gwtButton.selected = true
            currentDeviceType = 1
            deviceBkgImageView.image = UIImage(named: "device_goodwe")
            deviceTipsLabel.text = "请输入16位S/N码"
        } else {
            self.showHint("此设备未开通")
        }
    }
    
    func resetDeviceType() {
        currentDeviceType = 0
        deviceBkgImageView.image = UIImage(named: "device_gsm")
        deviceTipsLabel.text = "请输入10位S/N码"
    }

    
    func bindButtonClicked() {
        deviceTextField.resignFirstResponder()
        if (shouldShowLogin()) {
            return
        }
        let deviceId = deviceTextField.text
        if (deviceId!.isEmpty) {
            self.showHint("请输入设备号")
            return
        }
        let deviceIdStr = NSString.init(string: deviceId!)
        if (currentDeviceType == 0) {
            if (deviceIdStr.length != 10) {
                self.showHint("请输入10位S/N码")
                return
            }
        } else {
            if (deviceIdStr.length != 16) {
                self.showHint("请输入16位S/N码")
                return
            }
        }
        if (currentDeviceType == 0) {
            bindDevice()
        } else {
            API.sharedInstance.bindGoodwe(deviceTextField.text!, success: { (inventerModel) in
                let number = NSString.init(string: inventerModel.inventerSN!)
                if (number.length == 0) {
                    self.showHint("绑定失败")
                } else {
                    self.bindDevice()
                }
                }, failure: { (msg) in
                    self.showHint("绑定失败")
            })
        }
    }
    
    func bindDevice() {
        self.showHudInView(self.view, hint: "绑定中...")
        API.sharedInstance.bindDevice(deviceTextField.text!,device_type: currentDeviceType, success: { (userInfo) in
            self.hideHud()
            self.showHint("绑定成功!")
            UserDefaultManager.saveString(UserDefaultManager.USER_INFO, value: userInfo.mj_JSONString())
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
