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
    var currentDeviceType = 1  //设备类型(0:易事特  1:固德威  2:古瑞瓦特 3:开合山亿）
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "绑定设备"
        // Do any additional setup after loading the view.
        initView()
    }
    
    func initView() {
        let topView = UIView.init(frame: CGRect(x: 0, y: 64, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight / 12))
        self.view.addSubview(topView)
        
        let buttonWidth = PhoneUtils.kScreenWidth / 4
        let buttonHeight = PhoneUtils.kScreenHeight / 12
        
        gwtButton = UIButton.init(type: UIButtonType.custom)
        gwtButton.setImage(UIImage(named: "ic_dev_gdw_img0"), for: UIControlState.normal)
        gwtButton.setImage(UIImage(named: "ic_dev_gdw_img1"), for: UIControlState.selected)
        gwtButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        gwtButton.tag = 0
        gwtButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        topView.addSubview(gwtButton)
        
        ystButton = UIButton.init(type: UIButtonType.custom)
        ystButton.setImage(UIImage(named: "ic_dev_yst_img0"), for: UIControlState.normal)
        ystButton.setImage(UIImage(named: "ic_dev_yst_img1"), for: UIControlState.selected)
        ystButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        ystButton.tag = 1
        ystButton.frame = CGRect(x: buttonWidth, y: 0, width: buttonWidth, height: buttonHeight)
        topView.addSubview(ystButton)
        
        grwtButton = UIButton.init(type: UIButtonType.custom)
        grwtButton.setImage(UIImage(named: "ic_dev_grwt_img0"), for: UIControlState.normal)
        grwtButton.setImage(UIImage(named: "ic_dev_grwt_img1"), for: UIControlState.selected)
        grwtButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        grwtButton.tag = 2
        grwtButton.frame = CGRect(x: buttonWidth * 2, y: 0, width: buttonWidth, height: buttonHeight)
        topView.addSubview(grwtButton)
        
        khsyButton = UIButton.init(type: UIButtonType.custom)
        khsyButton.setImage(UIImage(named: "ic_dev_khkj_img0"), for: UIControlState.normal)
        khsyButton.setImage(UIImage(named: "ic_dev_khkj_img1"), for: UIControlState.selected)
        khsyButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        khsyButton.tag = 3
        khsyButton.frame = CGRect(x: buttonWidth * 3, y: 0, width: buttonWidth, height: buttonHeight)
        topView.addSubview(khsyButton)
        
        deviceView = UIView.init(frame: CGRect(x: 0, y: 64 + topView.frame.size.height, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - 64 - topView.frame.size.height))
        deviceView.backgroundColor = Colors.bkgGray
        self.view.addSubview(deviceView)
        
        initBindCenterView()
    }
    
    func initBindCenterView() {
        let deviceBottomView = UIView.init(frame: CGRect(x: 0, y: deviceView.frame.size.height - 50, width: PhoneUtils.kScreenWidth, height: 50))
        deviceBottomView.backgroundColor = UIColor.white
        deviceView.addSubview(deviceBottomView)
        
        let bindButton = GFJBottomButton.init(type: UIButtonType.custom)
        bindButton.frame = CGRect(x: 5, y: 5, width: PhoneUtils.kScreenWidth - 5 * 2, height: deviceBottomView.frame.size.height - 5 * 2)
        bindButton.setTitle("绑定设备", for: UIControlState.normal)
        bindButton.backgroundColor = Colors.installColor
        bindButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        bindButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        bindButton.addTarget(self, action: #selector(self.bindButtonClicked), for: UIControlEvents.touchUpInside)
        deviceBottomView.addSubview(bindButton)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = deviceBottomView.frame.size.height - 5 * 2
        
        let width = PhoneUtils.kScreenWidth * 0.6
        let height = (231 * width) / 309
        
        deviceBkgImageView = UIImageView.init(frame: CGRect(x: (PhoneUtils.kScreenWidth - width) / 2, y: 8, width: width, height: height))
        deviceBkgImageView.image = UIImage(named: "device_goodwe")
        deviceView.addSubview(deviceBkgImageView)
        
        deviceTipsLabel = UILabel.init(frame: CGRect(x: (PhoneUtils.kScreenWidth - buttonWidth) / 2, y: (deviceBkgImageView.frame).maxY + 8, width: buttonWidth, height: buttonHeight))
        deviceTipsLabel.text = "您当前选择了固德威品牌，请输入设备号查询发电量！"
        deviceTipsLabel.textAlignment = NSTextAlignment.center
        deviceTipsLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        deviceTipsLabel.adjustsFontSizeToFitWidth = true
        deviceTipsLabel.textColor = UIColor.black
        deviceView.addSubview(deviceTipsLabel)
        
        deviceTextField = UITextField.init(frame: CGRect(x: (PhoneUtils.kScreenWidth - buttonWidth * 0.9) / 2, y: (deviceTipsLabel.frame).maxY + 8, width: buttonWidth * 0.9, height: buttonHeight))
        deviceTextField.layer.borderColor = UIColor.lightGray.cgColor
        deviceTextField.backgroundColor = UIColor.white
        deviceTextField.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        deviceTextField.placeholder = "请输入设备号"
        deviceView.addSubview(deviceTextField)
    }
    
    func topButtonClicked(_ button: UIButton) {
        ystButton.isSelected = false
        gwtButton.isSelected = false
        grwtButton.isSelected = false
        khsyButton.isSelected = false
        
//        设备类型(0:易事特  1:固德威  2:古瑞瓦特 3:开合山亿）
        if (button.tag == 0) {
            gwtButton.isSelected = true
            currentDeviceType = 1
            deviceBkgImageView.image = UIImage(named: "device_goodwe")
            deviceTipsLabel.text = "您当前选择了固德威品牌，请输入设备号查询发电量！"
        } else if (button.tag == 1) {
            ystButton.isSelected = true
            currentDeviceType = 0
            deviceBkgImageView.image = UIImage(named: "device_gsm")
            deviceTipsLabel.text = "您当前选择了易事特品牌，请输入设备号查询发电量！"
        } else if (button.tag == 2){
            grwtButton.isSelected = true
            currentDeviceType = 2
            deviceBkgImageView.image = UIImage(named: "device_grwt")
            deviceTipsLabel.text = "您当前选择了古瑞瓦特品牌，请输入设备号查询发电量！"
        } else if (button.tag == 3) {
            khsyButton.isSelected = true
            currentDeviceType = 3
            deviceBkgImageView.image = UIImage(named: "device_khsy")
            deviceTipsLabel.text = "您当前选择了开合山亿品牌，请输入设备号查询发电量！"
        }
    }
    
    func bindButtonClicked() {
        deviceTextField.resignFirstResponder()
        if (shouldShowLogin()) {
            return
        }
        if (currentDeviceType == 2 || currentDeviceType == 3) {
            self.showHint("设备号无法验证，请核对设备号！")
            return
        }
        
        let deviceId = deviceTextField.text
        if (deviceId!.isEmpty) {
            self.showHint("请输入设备号")
            return
        }
        bindDevice()
    }
    
    func bindDevice() {
        self.showHud(in: self.view, hint: "绑定中...")
        API.sharedInstance.bindDevice(deviceTextField.text!,device_type: NSNumber.init(value: currentDeviceType), success: { (userInfo) in
            self.hideHud()
            self.showHint("绑定成功!")
            UserDefaultManager.saveString(UserDefaultManager.USER_INFO, value: userInfo.mj_JSONString())
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
