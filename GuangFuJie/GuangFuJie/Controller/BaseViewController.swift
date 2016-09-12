//
//  BaseViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/7/30.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, BeeCloudDelegate {
    
    let displayView = DisplayView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.bkgColor
        //设置标题的字的颜色
        self.navigationController!.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.darkGrayColor(),forKey: NSForegroundColorAttributeName) as? [String : AnyObject]
        BeeCloud.setBeeCloudDelegate(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushViewController(to : UIViewController) {
        to.hidesBottomBarWhenPushed = true
        let image = UIImage(named: "ic_back")
        to.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.backButtonClicked))
        //注意: 加了这一句，自定义的返回按钮也可以用滑动返回了...
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.pushViewController(to, animated: true)
    }
    
    func aliPay(billno:String,title:String,totalFee:String,type:String) {
        let billno = billno
        let payReq = BCPayReq()
        payReq.channel = PayChannel.AliApp
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
    func onBeeCloudResp(resp: BCBaseResp!) {
        if (resp.type == BCObjsType.PayResp) {
            let timeResp : BCPayResp = resp as! BCPayResp
            if (timeResp.resultCode == 0) {
                self.showHint("购买成功")
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                self.showHint(timeResp.resultMsg)
            }
        }
    }
    
    //外部调用这个方法
    func selectPhotoPicker() {
        let actionSheet = UIActionSheet.init()
        actionSheet.title = "选择方式"
        actionSheet.addButtonWithTitle("拍照")
        actionSheet.addButtonWithTitle("相册")
        actionSheet.addButtonWithTitle("取消")
        actionSheet.cancelButtonIndex = 2
        actionSheet.delegate = self
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
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
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func takePhoto() {
        if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            self.showHint("模拟机不能使用相机")
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo
        info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        pickerCallback(image)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //图片回调方法
    func pickerCallback(image : UIImage) {
    }
    
    func backButtonClicked() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showPhotos(urls : NSMutableArray, index : NSInteger, isLocal: Bool) {
        for view in displayView.subviews {
            view.removeFromSuperview()
        }
        displayView.imgsPrepare(urls as! [String], isLocal: isLocal)
        
        let pbVC = PhotoBrowser()
        
        /**  set album demonstration style  */
        pbVC.showType = PhotoBrowser.ShowType.ZoomAndDismissWithSingleTap
        
        /**  set album style  */
        if (isLocal) {
            pbVC.photoType = PhotoBrowser.PhotoType.Local
        } else {
            pbVC.photoType = PhotoBrowser.PhotoType.Host
        }
        
        //forbid showing all info
        pbVC.hideMsgForZoomAndDismissWithSingleTap = true
        
        var models: [PhotoBrowser.PhotoModel] = []
        
        for i in 0..<urls.count {
            let imageUrl = urls[i] as! String
            if (!isLocal) {
                let model = PhotoBrowser.PhotoModel(hostHDImgURL: imageUrl, hostThumbnailImg: nil, titleStr: "", descStr:"", sourceView: displayView.subviews[i] )
                models.append(model)
            } else {
                var image = UIImage(named: imageUrl)
                if (image == nil) {
                    image = UIImage.init(data: NSData.init(contentsOfURL: NSURL.init(string: imageUrl)!)!)
                }
                let model = PhotoBrowser.PhotoModel(localImg:image , titleStr: "", descStr:"", sourceView: displayView.subviews[i] )
                models.append(model)
            }
        }
        /**  set models   */
        pbVC.photoModels = models
        
        pbVC.show(inVC: self,index: index)
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
