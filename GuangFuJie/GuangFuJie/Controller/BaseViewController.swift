//
//  BaseViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/6.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate, BeeCloudDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        BeeCloud.setBeeCloudDelegate(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return true
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
