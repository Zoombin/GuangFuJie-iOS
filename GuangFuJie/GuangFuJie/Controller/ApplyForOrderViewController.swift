//
//  ApplyForOrderViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/10.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class ApplyForOrderViewController: BaseViewController, BMKGeoCodeSearchDelegate {
    var locService : BMKLocationService!
    var geocodeSearch: BMKGeoCodeSearch!
    
    var years : String!
    
    var scrollView : UIScrollView!
    var nameTextField : UITextField!
    var phoneTextField : UITextField!
    var idTextField : UITextField!
    var nibianqiTextField: UITextField!
    var addressTextField : UITextField!
    
    var imgUrls = ""
    var img1 = ""
    var img2 = ""
    var img3 = ""
    
    var lat = ""
    var lng = ""
    var address = ""
    
    var selectedImgs = NSMutableArray()
    var imgView1 : UIImageView!
    var imgView2 : UIImageView!
    var imgView3 : UIImageView!
    var currentIndex = 0
    var totalprice: NSNumber!
    var price: NSNumber!
    
    var hasLocated = false
    var is_nearsea = "0"
    
    //类型和套餐内容
    var insuranceTypeV2: InsuranceTypeV2!
    var insuranceItemInfo: InsuranceItemInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "申请购买"
        // Do any additional setup after loading the view.
        initView()
        
        locService = BMKLocationService()
        geocodeSearch = BMKGeoCodeSearch()
        
        if (selectedImgs.count > 0) {
            for i in 0..<selectedImgs.count {
                let selectedImgUrl = selectedImgs[i] as! String
                if (selectedImgs.count == 1) {
                    imgUrls = selectedImgUrl
                } else {
                    imgUrls = imgUrls + "," + selectedImgUrl
                }
            }
            print(imgUrls)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locService.delegate = self
        geocodeSearch.delegate = self
        
        startLocation()
    }
    
    // MARK: - IBAction
    func startLocation() {
        print("进入普通定位态");
        hasLocated = false
        locService.startUserLocationService()
    }
    
    func stopLocation() {
        locService.stopUserLocationService()
    }

    func initView() {
        let labelWidth = PhoneUtils.kScreenWidth * 0.2
        let textFieldWidth = PhoneUtils.kScreenWidth * 0.8
        let labelHeight = PhoneUtils.kScreenHeight / 14
        let offSet : CGFloat = 5
        
        let buyBottomView = UIView.init(frame: CGRect(x: 0, y: self.view.frame.size.height - 50, width: PhoneUtils.kScreenWidth, height: 50))
        buyBottomView.backgroundColor = UIColor.white
        self.view.addSubview(buyBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = buyBottomView.frame.size.height - 5 * 2
        
        let buyNowButton = GFJBottomButton.init(type: UIButtonType.custom)
        buyNowButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        buyNowButton.setTitle("提交", for: UIControlState.normal)
        buyNowButton.backgroundColor = Colors.appBlue
        buyNowButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        buyNowButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        buyNowButton.addTarget(self, action: #selector(self.submitOrder), for: UIControlEvents.touchUpInside)
        buyBottomView.addSubview(buyNowButton)
        
        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: self.navigationBarAndStatusBarHeight(), width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - buyBottomView.frame.size.height - self.navigationBarAndStatusBarHeight()))
        scrollView.backgroundColor = UIColor.white
        self.view.addSubview(scrollView)
        
        let nameLabel = UILabel.init(frame: CGRect(x: offSet, y: offSet, width: labelWidth - offSet * 2, height: labelHeight))
        nameLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        nameLabel.text = "姓名"
        scrollView.addSubview(nameLabel)
        
        nameTextField = UITextField.init(frame: CGRect(x: labelWidth + offSet, y: offSet, width: textFieldWidth - offSet * 2, height: labelHeight))
        nameTextField.layer.borderColor = UIColor.black.cgColor
        nameTextField.layer.borderWidth = 1
        nameTextField.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        scrollView.addSubview(nameTextField)
        
        let phoneLabel = UILabel.init(frame: CGRect(x: offSet, y: offSet + nameLabel.frame.maxY, width: labelWidth - offSet * 2, height: labelHeight))
        phoneLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        phoneLabel.text = "手机号"
        scrollView.addSubview(phoneLabel)
        
        phoneTextField = UITextField.init(frame: CGRect(x: labelWidth + offSet, y: offSet + nameLabel.frame.maxY, width: textFieldWidth - offSet * 2, height: labelHeight))
        phoneTextField.layer.borderColor = UIColor.black.cgColor
        phoneTextField.layer.borderWidth = 1
        phoneTextField.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        phoneTextField.keyboardType = UIKeyboardType.numberPad
        scrollView.addSubview(phoneTextField)
        
        let idLabel = UILabel.init(frame: CGRect(x: offSet, y: offSet + phoneLabel.frame.maxY, width: labelWidth - offSet * 2, height: labelHeight))
        idLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        idLabel.text = "身份证号码"
        scrollView.addSubview(idLabel)
        
        idTextField = UITextField.init(frame: CGRect(x: labelWidth + offSet, y: offSet + phoneLabel.frame.maxY, width: textFieldWidth - offSet * 2, height: labelHeight))
        idTextField.layer.borderColor = UIColor.black.cgColor
        idTextField.layer.borderWidth = 1
        idTextField.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        scrollView.addSubview(idTextField)
        
        let nibianqiLabel = UILabel.init(frame: CGRect(x: offSet, y: offSet + idLabel.frame.maxY, width: labelWidth - offSet * 2, height: labelHeight))
        nibianqiLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        nibianqiLabel.text = "逆变器型号"
        scrollView.addSubview(nibianqiLabel)
        
        nibianqiTextField = UITextField.init(frame: CGRect(x: labelWidth + offSet, y: offSet + idLabel.frame.maxY, width: textFieldWidth - offSet * 2, height: labelHeight))
        nibianqiTextField.layer.borderColor = UIColor.black.cgColor
        nibianqiTextField.layer.borderWidth = 1
        nibianqiTextField.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        scrollView.addSubview(nibianqiTextField)
        
        let addressLabel = UILabel.init(frame: CGRect(x: offSet, y: offSet + nibianqiLabel.frame.maxY, width: labelWidth - offSet * 2, height: labelHeight))
        addressLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        addressLabel.text = "电站地址"
        scrollView.addSubview(addressLabel)
        
        addressTextField = UITextField.init(frame: CGRect(x: labelWidth + offSet, y: offSet + nibianqiLabel.frame.maxY, width: textFieldWidth - offSet * 2, height: labelHeight))
        addressTextField.layer.borderColor = UIColor.black.cgColor
        addressTextField.layer.borderWidth = 1
        addressTextField.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        scrollView.addSubview(addressTextField)
        
        let resourseLabel = UILabel.init(frame: CGRect(x: offSet, y: offSet + addressLabel.frame.maxY, width: labelWidth - offSet * 2, height: labelHeight))
        resourseLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        resourseLabel.text = "合同资料"
        scrollView.addSubview(resourseLabel)
        
        let resourseNoticeLabel = UILabel.init(frame: CGRect(x: labelWidth + offSet, y: offSet + addressLabel.frame.maxY, width: textFieldWidth - offSet * 2, height: labelHeight))
        resourseNoticeLabel.text = "为了确认电站所属人信息,请您上传发用电合同,若您的电站还未并网,请上传电站接入方案或电站照片。"
        resourseNoticeLabel.numberOfLines = 0
        resourseNoticeLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        resourseNoticeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        scrollView.addSubview(resourseNoticeLabel)
        
        let resourseTitleLabel = UILabel.init(frame: CGRect(x: offSet, y: offSet + resourseLabel.frame.maxY, width: textFieldWidth - offSet * 2, height: labelHeight))
        resourseTitleLabel.text = "点击示例上传合同。"
        resourseTitleLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        scrollView.addSubview(resourseTitleLabel)
        
        let imgWidth = (PhoneUtils.kScreenWidth - offSet * 4) / 3
        let imgHeight = PhoneUtils.kScreenHeight / 4
        
        imgView1 = UIImageView.init(frame: CGRect(x: offSet, y: resourseTitleLabel.frame.maxY + offSet, width: imgWidth, height: imgHeight))
        imgView1.image = UIImage(named: "ic_p001")
        scrollView.addSubview(imgView1)
        
        let uploadButton1 = UIButton.init(type: UIButtonType.custom)
        uploadButton1.frame = CGRect(x: imgView1.frame.origin.x, y: imgView1.frame.maxY + 5, width: imgView1.frame.size.width, height: imgView1.frame.size.height * 0.12)
        uploadButton1.setTitle("点击上传", for: UIControlState.normal)
        uploadButton1.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        uploadButton1.backgroundColor = Colors.appBlue
        uploadButton1.addTarget(self, action: #selector(self.submitImage1), for: UIControlEvents.touchUpInside)
        scrollView.addSubview(uploadButton1)
        
        let tapGesture1 = UITapGestureRecognizer.init(target: self, action: #selector(self.viewImage1))
        imgView1.isUserInteractionEnabled = true
        imgView1.addGestureRecognizer(tapGesture1)
        
        imgView2 = UIImageView.init(frame: CGRect(x: offSet * 2 + imgWidth, y: resourseTitleLabel.frame.maxY + offSet, width: imgWidth, height: imgHeight))
        imgView2.image = UIImage(named: "ic_p002")
        scrollView.addSubview(imgView2)
        
        let uploadButton2 = UIButton.init(type: UIButtonType.custom)
        uploadButton2.frame = CGRect(x: imgView2.frame.origin.x, y: imgView2.frame.maxY + 5, width: imgView2.frame.size.width, height: imgView2.frame.size.height * 0.12)
        uploadButton2.setTitle("点击上传", for: UIControlState.normal)
        uploadButton2.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        uploadButton2.backgroundColor = Colors.appBlue
        uploadButton2.addTarget(self, action: #selector(self.submitImage2), for: UIControlEvents.touchUpInside)
        scrollView.addSubview(uploadButton2)
        
        let tapGesture2 = UITapGestureRecognizer.init(target: self, action: #selector(self.viewImage2))
        imgView2.isUserInteractionEnabled = true
        imgView2.addGestureRecognizer(tapGesture2)
        
        imgView3 = UIImageView.init(frame: CGRect(x: offSet * 3 + imgWidth * 2, y: resourseTitleLabel.frame.maxY + offSet, width: imgWidth, height: imgHeight))
        imgView3.image = UIImage(named: "ic_p003")
        scrollView.addSubview(imgView3)
        
        let uploadButton3 = UIButton.init(type: UIButtonType.custom)
        uploadButton3.frame = CGRect(x: imgView3.frame.origin.x, y: imgView3.frame.maxY + 5, width: imgView3.frame.size.width, height: imgView3.frame.size.height * 0.12)
        uploadButton3.setTitle("点击上传", for: UIControlState.normal)
        uploadButton3.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        uploadButton3.backgroundColor = Colors.appBlue
        uploadButton3.addTarget(self, action: #selector(self.submitImage3), for: UIControlEvents.touchUpInside)
        scrollView.addSubview(uploadButton3)
        
        let tapGesture3 = UITapGestureRecognizer.init(target: self, action: #selector(self.viewImage3))
        imgView3.isUserInteractionEnabled = true
        imgView3.addGestureRecognizer(tapGesture3)
        
        scrollView.contentSize = CGSize(width: 0, height: uploadButton3.frame.maxY + 1)
    }
    
    func viewImage1() {
        if (img1.isEmpty) {
            self.showPhotos(["ic_p001"], index: 0, isLocal: true)
        } else {
            self.showPhotos([img1], index: 0, isLocal: false)
        }
    }
    
    func viewImage2() {
        if (img2.isEmpty) {
            self.showPhotos(["ic_p002"], index: 0, isLocal: true)
        } else {
            self.showPhotos([img2], index: 0, isLocal: false)
        }
    }
    
    func viewImage3() {
        if (img3.isEmpty) {
            self.showPhotos(["ic_p003"], index: 0, isLocal: true)
        } else {
            self.showPhotos([img3], index: 0, isLocal: false)
        }
    }
    
    func submitImage1() {
        currentIndex = 0
        uploadImage()
    }
    
    func submitImage2() {
        currentIndex = 1
        uploadImage()
    }
    
    func submitImage3() {
        currentIndex = 2
        uploadImage()
    }
    
    func uploadImage() {
        selectPhotoPicker()
    }
    
    override func pickerCallback(_ image: UIImage) {
        let imgData = UIImagePNGRepresentation(image)
        let time = Date().timeIntervalSince1970
        let key = "yyzhizhao_\(time).png"
        self.showHud(in: self.view, hint: "正在上传")
        API.sharedInstance.qnToken(key, success: { (info) in
            API.sharedInstance.uploadData(imgData!, key: key, token: info.token!, success: { (result) in
                self.hideHud()
                if (result.info?.error != nil) {
                    self.showHint("上传失败")
                } else {
                    self.showHint("上传成功!")
                    let url = "http://ob4e8ww8r.bkt.clouddn.com/" + result.key!
                    if (self.currentIndex == 0) {
                        self.img1 = url
                        self.imgView1.setImageWith(URL.init(string: url)!)
                    } else if (self.currentIndex == 1) {
                        self.img2 = url
                        self.imgView2.setImageWith(URL.init(string: url)!)
                    } else if (self.currentIndex == 2) {
                        self.img3 = url
                        self.imgView3.setImageWith(URL.init(string: url)!)
                    }
                }
            })
        }) { (error) in
            self.hideHud()
            self.showHint(error)
        }
    }

    func submitOrder() {
        if (shouldShowLogin()) {
            return
        }
        if (nameTextField.text!.isEmpty) {
            self.showHint("请输入姓名")
            return
        }
        if (phoneTextField.text!.isEmpty) {
            self.showHint("请输入手机号")
            return
        }
        if (idTextField.text!.isEmpty) {
            self.showHint("请输入身份证号码")
            return
        }
        if (addressTextField.text!.isEmpty) {
            self.showHint("请输入电站地址")
            return
        }
        if (nibianqiTextField.text!.isEmpty) {
            self.showHint("请输入逆变器型号")
            return
        }
        if (img1.isEmpty && img2.isEmpty && img3.isEmpty) {
            self.showHint("请上传合同")
            return
        }
        var htImgUrls = ""
        if (!img1.isEmpty) {
            htImgUrls = htImgUrls + img1
        }
        if (!img2.isEmpty) {
            htImgUrls = htImgUrls + "," + img2
        }
        if (!img3.isEmpty) {
            htImgUrls = htImgUrls + "," + img3
        }
        let title = "光伏保险套餐\(YCStringUtils.getNumber(self.insuranceItemInfo.id))"
        self.totalprice = YCStringUtils.getNumber(self.insuranceItemInfo.price)
        
        self.showHud(in: self.view, hint: "提交中...")
        API.sharedInstance.insuranceAddV2(itemId: YCStringUtils.getNumber(insuranceItemInfo.id), price: YCStringUtils.getNumber(insuranceItemInfo.price), beneficiary_name: nameTextField.text!, beneficiary_phone: phoneTextField.text!, beneficiary_id_no: idTextField.text!, station_address: addressTextField.text!, client_contract_img: htImgUrls, image: imgUrls, address: address, longitude: lng, latitude: lat, is_nearsea: is_nearsea, inverternum: nibianqiTextField.text!, success: { (commonModel) in
            self.hideHud()
            self.selectPayType(commonModel.order_sn!, title: title, totalFee: String(format: "%.0f", self.totalprice.floatValue * 100), type: commonModel.type!)
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    //支付回调
    override func onBeeCloudResp(_ resp: BCBaseResp!) {
        if (resp.type == BCObjsType.payResp) {
            let timeResp : BCPayResp = resp as! BCPayResp
            print(timeResp.resultMsg)
            if (timeResp.resultCode == 0) {
                self.showHint("购买成功")
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.showHint(timeResp.resultMsg)
            }
        }
    }
    
    
    // MARK: - BMKLocationServiceDelegate
    
    /**
     *在地图View将要启动定位时，会调用此函数
     *@param mapView 地图View
     */
    func willStartLocatingUser() {
        print("willStartLocatingUser");
    }
    
    /**
     *用户位置更新后，会调用此函数
     *@param userLocation 新的用户位置
     */
    override func didUpdate(_ userLocation: BMKUserLocation!) {
        print("didUpdateUserLocation lat:\(userLocation.location.coordinate.latitude) lon:\(userLocation.location.coordinate.longitude)")
        if (hasLocated == false) {
            hasLocated = true
            lat = "\(userLocation.location.coordinate.latitude)"
            lng = "\(userLocation.location.coordinate.longitude)"
            
            reGeoSearch(location: userLocation.location.coordinate)
        }
    }
    
    func reGeoSearch(location: CLLocationCoordinate2D) {
        let reverseGeoOption = BMKReverseGeoCodeOption()
        reverseGeoOption.reverseGeoPoint = location
        let flag = geocodeSearch.reverseGeoCode(reverseGeoOption)
        if flag {
            print("反地理编码成功")
        } else {
            print("反地理编码失败")
        }
    }
    
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            address = result.address
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locService.delegate = nil
        geocodeSearch.delegate = nil
        stopLocation()
    }
    
    /**
     *在地图View停止定位后，会调用此函数
     *@param mapView 地图View
     */
    func didStopLocatingUser() {
        print("didStopLocatingUser")
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
