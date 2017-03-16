//
//  BaseViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/7/30.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, BeeCloudDelegate, LoginViewDelegate, UMSocialUIDelegate {
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
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(image: UIImage(named: "users_icon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.rightButtonClicked)), UIBarButtonItem.init(image: UIImage(named: "btn_share")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(shareApp))]
    }
    
    func didFinishGetUMSocialData(inViewController response: UMSocialResponseEntity!) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            self.showHint("分享成功")
        } else {
            self.showHint("分享失败")
        }
    }
    
    func shareApp() {
        let info = ShareInfo()
        info.shareTitle = "光伏街"
        info.shareLink = "https://itunes.apple.com/app/id1157294691"
        info.shareDesc = "光伏街是一家基于“互联网”的新能源提供商，是太阳能发电行业最优秀的系统集成商之一"
        info.shareImg = UIImage(named: "icon")
        shareButtonClicked(shareInfo: info)
    }
    
    func shareButtonClicked(shareInfo: ShareInfo) {
        UMSocialData.default().extConfig.wechatSessionData.title = shareInfo.shareTitle
        UMSocialData.default().extConfig.wechatSessionData.url = shareInfo.shareLink
        
        UMSocialData.default().extConfig.wechatTimelineData.title = shareInfo.shareTitle
        UMSocialData.default().extConfig.wechatTimelineData.url = shareInfo.shareLink
        
        let content = shareInfo.shareDesc
        
        let snsNames = [UMShareToWechatSession, UMShareToWechatTimeline]
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: Constants.umAppKey, shareText: content, shareImage: shareInfo.shareImg != nil ? NSData.init(contentsOf: URL.init(string: shareInfo.shareImg as! String)!) : nil, shareToSnsNames: snsNames, delegate: self)
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
    
    func pushViewController(_ to : UIViewController, animation: Bool? = true) {
        to.hidesBottomBarWhenPushed = true
        let image = UIImage(named: "ic_back")
        to.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonClicked))
        //注意: 加了这一句，自定义的返回按钮也可以用滑动返回了...
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.pushViewController(to, animated: animation!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectPayType(_ billno:String,title:String,totalFee:String,type:String) {
        let actionSheet = UIAlertController.init(title: "选择支付方式", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        let actionButtonAliPay = UIAlertAction.init(title: "支付宝", style: UIAlertActionStyle.default) { (action) in
            self.pay(billno, title: title, totalFee: totalFee, type: type, channel: PayChannel.aliApp)
        }
        let actionButtonWX = UIAlertAction.init(title: "微信", style: UIAlertActionStyle.default) { (action) in
            self.pay(billno, title: title, totalFee: totalFee, type: type, channel: PayChannel.wxApp)
        }
        let actionButtonCancel = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
            //do nothing
        }
        actionSheet.addAction(actionButtonAliPay)
        actionSheet.addAction(actionButtonWX)
        actionSheet.addAction(actionButtonCancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func pay(_ billno:String,title:String,totalFee:String,type:String, channel: PayChannel) {
        if (channel == PayChannel.wxApp && !WXApi.isWXAppInstalled()) {
            self.showHint("请安装微信进行支付")
            return
        }
        
        let payReq = BCPayReq()
        payReq.channel = channel
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
