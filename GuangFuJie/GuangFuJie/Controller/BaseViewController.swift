//
//  BaseViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/7/30.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, BeeCloudDelegate, LoginViewDelegate, UMSocialUIDelegate {
    var topMenuView : UIView!
    var loginView : LoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLoginView()
        
        self.view.backgroundColor = Colors.bkgColor
        self.navigationController!.navigationBar.tintColor = UIColor.black
        
        //设置标题的字的颜色
        self.navigationController!.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.darkGray,forKey: NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject]
        BeeCloud.setBeeCloudDelegate(self)
    }
    
    func showTopMenu(_ index : NSInteger) {
        let topImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        topImageView.image = UIImage.init(named: "ic_home_logo")
        self.navigationItem.titleView = topImageView
        
        let screenWidth = PhoneUtils.kScreenWidth
        let buttonHeigt : CGFloat = 30
        let offSetX : CGFloat = 15
        let offSetY : CGFloat = 5
        let titles = ["业主", "安装商", "发电量", "保险"]
        let buttonWidth = (screenWidth - offSetX * CGFloat(titles.count + 1))  / CGFloat(titles.count)
        
        topMenuView = UIView.init(frame: CGRect(x: 0, y: 64, width: screenWidth, height: buttonHeigt + offSetY * 2))
        topMenuView.backgroundColor = UIColor.white
        self.view.addSubview(topMenuView)
        
        for i in 0..<titles.count {
            let startX : CGFloat = CGFloat(i) * buttonWidth + (CGFloat(i) + 1) * offSetX;
            let button = UIButton.init(frame: CGRect(x: startX, y: offSetY, width: buttonWidth, height: buttonHeigt))
            button.setTitle(titles[i], for: UIControlState.normal)
            button.setTitleColor(Colors.lightGray, for: UIControlState.normal)
            button.setTitleColor(Colors.lightBule, for: UIControlState.selected)
            button.layer.cornerRadius = 15
            button.layer.borderColor = Colors.clearColor.cgColor
            button.layer.borderWidth = 0.5
            button.layer.masksToBounds = true
            button.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm2)
            button.tag = i
            button.addTarget(self, action: #selector(self.topMenuButtonClicked(_:)), for: UIControlEvents.touchUpInside)
            topMenuView.addSubview(button)
            if (i == index) {
                button.layer.borderColor = Colors.borderWithGray.cgColor
                button.isSelected = true
            }
        }
    }
    
    func initLeftNavButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "user_icon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.leftButtonClicked))
    }
    
    func leftButtonClicked() {
        if (UserDefaultManager.isLogin()) {
            let vc = UserCenterViewController()
            self.pushViewController(vc)
            return
        }
        loginView.isHidden = false
    }
    
    //MARK:是否需要显示登录页面
    func shouldShowLogin() -> Bool{
        if (UserDefaultManager.isLogin()) {
            return false
        }
        loginView.isHidden = false
        return true
    }
    
    func initRightNavButton() {
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(image: UIImage(named: "users_icon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.rightButtonClicked)), UIBarButtonItem.init(image: UIImage(named: "btn_share")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(shareButtonClicked))]
    }
    
    func didFinishGetUMSocialData(inViewController response: UMSocialResponseEntity!) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            self.showHint("分享成功")
        } else {
            self.showHint("分享失败")
        }
    }
    
    func shareButtonClicked() {
        UMSocialData.default().extConfig.wechatSessionData.title = "光伏街"
        UMSocialData.default().extConfig.wechatSessionData.url = "https://itunes.apple.com/app/id1157294691"
        
        UMSocialData.default().extConfig.wechatTimelineData.title = "光伏街"
        UMSocialData.default().extConfig.wechatTimelineData.url = "https://itunes.apple.com/app/id1157294691"
        
        let content = "光伏街是一家基于“互联网”的新能源提供商，是太阳能发电行业最优秀的系统集成商之一"
        let logo = UIImage(named: "icon")
        
        let snsNames = [UMShareToWechatSession, UMShareToWechatTimeline]
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: Constants.umAppKey, shareText: content, shareImage: logo, shareToSnsNames: snsNames, delegate: self)
    }
    
    func rightButtonClicked() {
        let vc = GFJWebViewController()
        vc.urlTag = 0
        self.pushViewController(vc)
    }
    
    //MARK: 登录页面
    func initLoginView() {
        loginView = LoginView(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight))
        loginView.initView()
        loginView.delegate = self
        loginView.isHidden = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.addSubview(loginView)
    }
    
    /**
     登录页面代理方法--获取验证码
     */
    func getCodeButtonClicked(_ phone: String) {
        loginView.hiddenAllKeyBoard()
        if (phone.isEmpty) {
            self.showHint("请输入手机号!")
            return
        }
        self.showHud(in: self.view, hint: "验证码获取中...")
        API.sharedInstance.userCaptcha(phone, success: { (commonModel) in
            self.hideHud()
            self.showHint("验证码将发送到您的手机!")
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    /**
     登录页面代理方法--登录按钮
     
     - parameter phone
     - parameter code
     */
    func loginButtonClicked(_ phone: String, code: String) {
        loginView.hiddenAllKeyBoard()
        if (phone.isEmpty) {
            self.showHint("请输入手机号!")
            return
        }
        if (code.isEmpty) {
            self.showHint("请输入验证码!")
            return
        }
        self.showHud(in: self.view, hint: "登录中...")
        API.sharedInstance.login(phone, captcha: code, success: { (userinfo) in
            self.hideHud()
            self.showHint("登录成功!")
            self.loginView.isHidden = true
            UserDefaultManager.saveString(UserDefaultManager.USER_INFO, value: userinfo.mj_JSONString())
            self.userDidLogin()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    /**
     用户登录会调用此方法
     */
    func userDidLogin() {
        
    }
    
    func topMenuButtonClicked(_ sender : UIButton) {
        self.tabBarController?.selectedIndex = sender.tag
    }
    
    func pushViewController(_ to : UIViewController) {
        //        to.hidesBottomBarWhenPushed = true
        let image = UIImage(named: "ic_back")
        to.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonClicked))
        //注意: 加了这一句，自定义的返回按钮也可以用滑动返回了...
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.pushViewController(to, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func aliPay(_ billno:String,title:String,totalFee:String,type:String) {
        let payReq = BCPayReq()
        payReq.channel = PayChannel.aliApp
        payReq.title = title
        payReq.totalFee = totalFee //单位是分
        payReq.billNo = billno
        payReq.scheme = "GuangFuJieApp"
        payReq.billTimeOut = 300
        payReq.viewController = self
        payReq.optional = ["type" : type]
        BeeCloud.sendBCReq(payReq)
    }
    
    //支付回调
    func onBeeCloudResp(_ resp: BCBaseResp!) {
        if (resp.type == BCObjsType.payResp) {
            let timeResp : BCPayResp = resp as! BCPayResp
            print(timeResp.resultMsg)
            if (timeResp.resultCode == 0) {
                self.showHint("购买成功")
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showHint(timeResp.resultMsg)
            }
        }
    }
    
    //外部调用这个方法
    func selectPhotoPicker() {
        let actionSheet = UIActionSheet.init()
        actionSheet.title = "选择方式"
        actionSheet.addButton(withTitle: "拍照")
        actionSheet.addButton(withTitle: "相册")
        actionSheet.addButton(withTitle: "取消")
        actionSheet.cancelButtonIndex = 2
        actionSheet.delegate = self
        actionSheet.show(in: self.view)
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if (actionSheet.cancelButtonIndex == buttonIndex) {
            return
        }
        print(actionSheet.firstOtherButtonIndex)
        print(buttonIndex)
        if (actionSheet.firstOtherButtonIndex + 1 == buttonIndex) {
            takePhoto()
        } else if (actionSheet.firstOtherButtonIndex + 2 == buttonIndex) {
            openPhotoAdlum()
        }
    }
    
    func openPhotoAdlum() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func takePhoto() {
        if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            self.showHint("模拟机不能使用相机")
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.camera
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
        info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        pickerCallback(image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    //图片回调方法
    func pickerCallback(_ image : UIImage) {
    }
    
    func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showPhotos(_ urls : NSMutableArray, index : NSInteger, isLocal: Bool) {
        let vc = ZLPhotoPickerBrowserViewController()
        var tmpArray = [ZLPhotoPickerBrowserPhoto]()
        for i in 0..<urls.count {
            let photo = ZLPhotoPickerBrowserPhoto()
            if (isLocal) {
                photo.photoObj = UIImage(named: urls[i] as! String)
            } else {
               photo.photoObj = urls[i]
            }
            tmpArray.append(photo)
        }
        vc.photos = tmpArray
        vc.showPickerVc(self)
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
