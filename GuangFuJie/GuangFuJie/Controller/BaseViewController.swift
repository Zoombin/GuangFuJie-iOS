//
//  BaseViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/6.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate, BeeCloudDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, BMKLocationServiceDelegate {
    let locationManager = BMKLocationService()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.bkgColor
        //修改navigationBar的背景色
        self.navigationController?.navigationBar.barTintColor = Colors.appBlue
        //修改右边按钮的颜色
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //设置标题的字的颜色
        self.navigationController!.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.white, forKey: NSForegroundColorAttributeName as NSCopying) as? [String : AnyObject]
        
        BeeCloud.setBeeCloudDelegate(self)
    }
    
    func getCurrentLocation() {
        locationManager.delegate = self
        locationManager.startUserLocationService()
    }
    
    func didUpdate(_ userLocation: BMKUserLocation!) {
        print("didUpdateUserLocation lat:\(userLocation.location.coordinate.latitude) lon:\(userLocation.location.coordinate.longitude)")
        locationManager.stopUserLocationService()
        saveLocationInfo(location: userLocation.location)
    }
    
    func saveLocationInfo(location: CLLocation) {
        API.sharedInstance.getCityFromLatlng(lat: NSNumber.init(value: location.coordinate.latitude), lng: NSNumber.init(value: location.coordinate.longitude), success: { (locationInfo) in
            UserDefaultManager.saveString(UserDefaultManager.USER_LOCATION, value: locationInfo.mj_JSONString())
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshLocation"), object: nil)
        }) { (msg) in
            
        }
    }
    
    func goToPageByTitle(title: String) {
        var title = title
        var newTitle = NSString.init(string: title)
        newTitle = newTitle.replacingOccurrences(of: "　", with: "") as NSString
        title = newTitle as String
        if (title == "本地市场") {
            let vc = RootMapV2ViewController()
            self.pushViewController(vc)
        } else if (title == "体验店") {
            //体验店
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ExperienceShopViewController")
            self.pushViewController(vc)
        } else if (title == "光伏政策") {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "RootNewsViewController")
            self.pushViewController(vc)
        } else if (title == "光伏保险") {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            self.pushViewController(sb.instantiateViewController(withIdentifier: "RootInsuranceViewController"))
        } else if (title == "光伏贷款") {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "RootNewsViewController")
            self.pushViewController(vc)
        } else if (title == "供电局") {
            let vc = RootMapV2ViewController()
            self.pushViewController(vc)
        } else if (title == "地面推广") {
            let vc = DiTuiHomeV2ViewController()
            self.pushViewController(vc)
        } else if (title == "推广支持") {
            API.sharedInstance.articlesList(0, pagesize: 1, key: nil, provinceId: nil, cityId: nil, areaId: nil, type: 25, success: { (count, array) in
                if (array.count >= 1) {
                    let article = array[0] as! ArticleInfo
                    let vc = GFJWebViewController()
                    vc.title = title
                    vc.url = Constants.httpHost.replacingOccurrences(of: "/api/", with: "") + "/articles/\(article.id!)"
                    self.pushViewController(vc)
                }
            }) { (msg) in
                self.showHint(msg)
            }
        } else if (title == "本地安装商") {
            //更多安装商
            let vc = MoreInstallerViewController(nibName: "MoreInstallerViewController", bundle: nil)
            self.pushViewController(vc)
        } else if (title == "本地业主") {
            //本地业主
            let vc = GFJRoofListViewController(nibName: "GFJRoofListViewController", bundle: nil)
            self.pushViewController(vc)
        } else if (title == "投资收益") {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "NewsListViewController") as! NewsListViewController
            vc.title = title
            vc.type = 11
            self.pushViewController(vc)
        } else if (title == "实战模式") {
            API.sharedInstance.articlesList(0, pagesize: 1, key: nil, provinceId: nil, cityId: nil, areaId: nil, type: 26, success: { (count, array) in
                if (array.count >= 1) {
                    let article = array[0] as! ArticleInfo
                    let vc = GFJWebViewController()
                    vc.title = title
                    vc.url = Constants.httpHost.replacingOccurrences(of: "/api/", with: "") + "/articles/\(article.id!)"
                    self.pushViewController(vc)
                }
            }) { (msg) in
                self.showHint(msg)
            }
        } else if (title == "加盟支持") {
            API.sharedInstance.articlesList(0, pagesize: 1, key: nil, provinceId: nil, cityId: nil, areaId: nil, type: 24, success: { (count, array) in
                if (array.count >= 1) {
                    let article = array[0] as! ArticleInfo
                    let vc = GFJWebViewController()
                    vc.title = title
                    vc.url = Constants.httpHost.replacingOccurrences(of: "/api/", with: "") + "/articles/\(article.id!)"
                    self.pushViewController(vc)
                }
            }) { (msg) in
                self.showHint(msg)
            }
        } else if (title == "安装运维") {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "NewsListViewController") as! NewsListViewController
            vc.title = title
            vc.type = 7
            self.pushViewController(vc)
        } else if (title == "产品供求") {
            //产品供求
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ProductProvideViewController")
            self.pushViewController(vc)
        } else if (title == "客服") {
            self.chat()
        } else if (title == "安装教程") {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "NewsListViewController") as! NewsListViewController
            vc.title = title
            vc.type = 7
            self.pushViewController(vc)
        } else {
            self.showHint("功能暂未开放")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        if (self.navigationController!.viewControllers.count > 1) {
//            let image = UIImage(named: "ic_back")
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonClicked))
//            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//        }
    }
    
    func applyYeZhu() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "YeZhuApplyViewController")
        self.pushViewController(vc)
    }
    
    func applyJiaMeng() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "JoinUsApplyViewController")
        self.pushViewController(vc)
    }
    
    func applyAnZhuang() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "InstallerApplyViewController")
        self.pushViewController(vc)
    }
    
    func applyDiTui() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "DituiApplyViewController")
        self.pushViewController(vc)
    }
    
    func pushViewController(_ to : UIViewController, animation: Bool? = true) {
        to.hidesBottomBarWhenPushed = true
        let image = UIImage(named: "ic_back")
        to.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backButtonClicked))
        //注意: 加了这一句，自定义的返回按钮也可以用滑动返回了...
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.pushViewController(to, animated: animation!)
    }
    
    func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
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
    
    func contactUs() {
        UIApplication.shared.openURL(URL.init(string: "tel:4006229666")!)
    }
    
    func chat() {
        let chatViewManager = MQChatViewManager()
        chatViewManager.chatViewStyle.statusBarStyle = UIStatusBarStyle.lightContent
        chatViewManager.chatViewStyle.navBarColor = Colors.appBlue
        chatViewManager.chatViewStyle.navBarTintColor = UIColor.white
        let button = UIButton.init(type: UIButtonType.custom)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.setTitle("客服电话", for: UIControlState.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        button.addTarget(self, action: #selector(self.contactUs), for: UIControlEvents.touchUpInside)
        chatViewManager.chatViewStyle.navBarRightButton = button
        chatViewManager.chatViewStyle.navTitleColor = UIColor.white
        chatViewManager.chatViewStyle.navBackButtonImage = UIImage(named: "ic_back")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        chatViewManager.pushMQChatViewController(in: self)
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
        payReq.optional = ["type" : type, "project" : Constants.project]
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
    
    func shouldShowLogin() -> Bool{
        if (UserDefaultManager.isLogin()) {
            return false
        } else {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            self.pushViewController(sb.instantiateViewController(withIdentifier: "LoginViewController"))
            return true
        }
    }
    
    func shareApp() {
        let info = ShareInfo()
        info.shareTitle = Constants.projectName
        info.shareLink = "https://itunes.apple.com/app/id1157294691"
        info.shareDesc = "\(Constants.projectName)是一家基于“互联网”的新能源提供商，是太阳能发电行业最优秀的系统集成商之一"
        info.shareImg = UIImage(named: "icon")
        shareButtonClicked(shareInfo: info)
    }
    
    func shareButtonClicked(shareInfo: ShareInfo) {
        let platforms = NSMutableArray()
        if (UMSocialManager.default().isInstall(UMSocialPlatformType.wechatSession) && UMSocialManager.default().isInstall(UMSocialPlatformType.wechatTimeLine)) {
            platforms.add(UMSocialPlatformType.wechatSession.rawValue)
            platforms.add(UMSocialPlatformType.wechatTimeLine.rawValue)
        }
        if (platforms.count == 0) {
            self.showHint("您没有可以分享的平台")
            return
        }
       UMSocialUIManager.setPreDefinePlatforms(platforms as [AnyObject])
       UMSocialUIManager.showShareMenuViewInWindow { (platformType, userInfo) in
            self.shareData(info: shareInfo, platformType: platformType)
        }
    }
    
    func shareData(info: ShareInfo, platformType: UMSocialPlatformType) {
        let messageObject = UMSocialMessageObject()
        let shareObject = UMShareWebpageObject()
        shareObject.title = info.shareTitle
        shareObject.descr = info.shareDesc
        shareObject.webpageUrl = info.shareLink
        if (info.shareImg != nil) {
            shareObject.thumbImage = info.shareImg
        }
        messageObject.shareObject = shareObject
        
        UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: self) { (data, error) in
            if (error == nil) {
                self.showHint("分享成功")
            } else {
                self.showHint("分享失败")
            }
        }
    }
    
    func navigationBarAndStatusBarHeight() -> CGFloat{
        let rectOfStatusbar = UIApplication.shared.statusBarFrame
        let rectOfNavigationbar = self.navigationController?.navigationBar.frame
        return rectOfStatusbar.size.height + rectOfNavigationbar!.size.height
    }
    
    func getTabBarHeight() -> CGFloat {
        let tabHeight = self.tabBarController?.tabBar.frame.size.height
        if (self.hidesBottomBarWhenPushed == false) {
            return tabHeight!
        } else {
            return 0
        }
    }
    
    func getTextField(views: [UIView]) -> UITextField {
        for i in 0..<views.count {
            let view = views[i]
            if (view.isKind(of: UITextField.self)) {
                return view as! UITextField
            }
        }
        return UITextField()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
