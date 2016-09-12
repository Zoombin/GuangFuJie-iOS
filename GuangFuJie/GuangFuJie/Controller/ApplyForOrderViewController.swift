//
//  ApplyForOrderViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/10.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class ApplyForOrderViewController: BaseViewController {

    var insuranceType : InsuranceType!
    var years : String!
    
    var scrollView : UIScrollView!
    var nameTextField : UITextField!
    var phoneTextField : UITextField!
    var idTextField : UITextField!
    var addressTextField : UITextField!
    
    var imgUrls : String!
    var imgView1 : UIImageView!
    var imgView2 : UIImageView!
    var imgView3 : UIImageView!
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "申请购买"
        // Do any additional setup after loading the view.
        imgUrls = ""
        initView()
    }

    func initView() {
        let labelWidth = PhoneUtils.kScreenWidth * 0.2
        let textFieldWidth = PhoneUtils.kScreenWidth * 0.8
        let labelHeight = PhoneUtils.kScreenHeight / 14
        let offSet : CGFloat = 5
        
        let buyBottomView = UIView.init(frame: CGRectMake(0, self.view.frame.size.height - 50, PhoneUtils.kScreenWidth, 50))
        buyBottomView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(buyBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = buyBottomView.frame.size.height - 5 * 2
        
        let buyNowButton = UIButton.init(type: UIButtonType.Custom)
        buyNowButton.frame = CGRectMake(5, 5, buttonWidth, buttonHeight)
        buyNowButton.setTitle("提交", forState: UIControlState.Normal)
        buyNowButton.backgroundColor = Colors.installColor
        buyNowButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buyNowButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge2)
        buyNowButton.addTarget(self, action: #selector(self.submitOrder), forControlEvents: UIControlEvents.TouchUpInside)
        buyBottomView.addSubview(buyNowButton)
        
        scrollView = UIScrollView.init(frame: CGRectMake(0, 64, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - buyBottomView.frame.size.height - 64))
        self.view.addSubview(scrollView)
        
        let nameLabel = UILabel.init(frame: CGRectMake(offSet, offSet, labelWidth - offSet * 2, labelHeight))
        nameLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        nameLabel.text = "姓名"
        scrollView.addSubview(nameLabel)
        
        nameTextField = UITextField.init(frame: CGRectMake(labelWidth + offSet, offSet, textFieldWidth - offSet * 2, labelHeight))
        nameTextField.layer.borderColor = UIColor.blackColor().CGColor
        nameTextField.layer.borderWidth = 1
        nameTextField.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        scrollView.addSubview(nameTextField)
        
        let phoneLabel = UILabel.init(frame: CGRectMake(offSet, offSet + CGRectGetMaxY(nameLabel.frame), labelWidth - offSet * 2, labelHeight))
        phoneLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        phoneLabel.text = "手机号"
        scrollView.addSubview(phoneLabel)
        
        phoneTextField = UITextField.init(frame: CGRectMake(labelWidth + offSet, offSet + CGRectGetMaxY(nameLabel.frame), textFieldWidth - offSet * 2, labelHeight))
        phoneTextField.layer.borderColor = UIColor.blackColor().CGColor
        phoneTextField.layer.borderWidth = 1
        phoneTextField.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        scrollView.addSubview(phoneTextField)
        
        let idLabel = UILabel.init(frame: CGRectMake(offSet, offSet + CGRectGetMaxY(phoneLabel.frame), labelWidth - offSet * 2, labelHeight))
        idLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        idLabel.text = "身份证号码"
        scrollView.addSubview(idLabel)
        
        idTextField = UITextField.init(frame: CGRectMake(labelWidth + offSet, offSet + CGRectGetMaxY(phoneLabel.frame), textFieldWidth - offSet * 2, labelHeight))
        idTextField.layer.borderColor = UIColor.blackColor().CGColor
        idTextField.layer.borderWidth = 1
        idTextField.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        scrollView.addSubview(idTextField)
        
        let addressLabel = UILabel.init(frame: CGRectMake(offSet, offSet + CGRectGetMaxY(idLabel.frame), labelWidth - offSet * 2, labelHeight))
        addressLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        addressLabel.text = "电站地址"
        scrollView.addSubview(addressLabel)
        
        addressTextField = UITextField.init(frame: CGRectMake(labelWidth + offSet, offSet + CGRectGetMaxY(idLabel.frame), textFieldWidth - offSet * 2, labelHeight))
        addressTextField.layer.borderColor = UIColor.blackColor().CGColor
        addressTextField.layer.borderWidth = 1
        addressTextField.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        scrollView.addSubview(addressTextField)
        
        let resourseLabel = UILabel.init(frame: CGRectMake(offSet, offSet + CGRectGetMaxY(addressLabel.frame), labelWidth - offSet * 2, labelHeight))
        resourseLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        resourseLabel.text = "合同资料"
        scrollView.addSubview(resourseLabel)
        
        let resourseNoticeLabel = UILabel.init(frame: CGRectMake(labelWidth + offSet, offSet + CGRectGetMaxY(addressLabel.frame), textFieldWidth - offSet * 2, labelHeight))
        resourseNoticeLabel.text = "为了确认电站所属人信息,请您上传发用电合同,若您的电站还未并网,请上传电站接入方案或电站照片。"
        resourseNoticeLabel.numberOfLines = 0
        resourseNoticeLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        resourseNoticeLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        scrollView.addSubview(resourseNoticeLabel)
        
        let resourseTitleLabel = UILabel.init(frame: CGRectMake(offSet, offSet + CGRectGetMaxY(resourseLabel.frame), textFieldWidth - offSet * 2, labelHeight))
        resourseTitleLabel.text = "点击示例上传合同。"
        resourseTitleLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall)
        scrollView.addSubview(resourseTitleLabel)
        
        let imgWidth = (PhoneUtils.kScreenWidth - offSet * 4) / 3
        let imgHeight = PhoneUtils.kScreenHeight / 4
        
        imgView1 = UIImageView.init(frame: CGRectMake(offSet, CGRectGetMaxY(resourseTitleLabel.frame) + offSet, imgWidth, imgHeight))
        imgView1.image = UIImage(named: "ic_p001")
        scrollView.addSubview(imgView1)
        
        let tapGesture1 = UITapGestureRecognizer.init(target: self, action: #selector(self.submitImage1))
        imgView1.userInteractionEnabled = true
        imgView1.addGestureRecognizer(tapGesture1)
        
        imgView2 = UIImageView.init(frame: CGRectMake(offSet * 2 + imgWidth, CGRectGetMaxY(resourseTitleLabel.frame) + offSet, imgWidth, imgHeight))
        imgView2.image = UIImage(named: "ic_p002")
        scrollView.addSubview(imgView2)
        
        let tapGesture2 = UITapGestureRecognizer.init(target: self, action: #selector(self.submitImage2))
        imgView2.userInteractionEnabled = true
        imgView2.addGestureRecognizer(tapGesture2)
        
        imgView3 = UIImageView.init(frame: CGRectMake(offSet * 3 + imgWidth * 2, CGRectGetMaxY(resourseTitleLabel.frame) + offSet, imgWidth, imgHeight))
        imgView3.image = UIImage(named: "ic_p003")
        scrollView.addSubview(imgView3)
        
        let tapGesture3 = UITapGestureRecognizer.init(target: self, action: #selector(self.submitImage3))
        imgView3.userInteractionEnabled = true
        imgView3.addGestureRecognizer(tapGesture3)
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
    
    override func pickerCallback(image: UIImage) {
        let imgData = UIImagePNGRepresentation(image)
        let time = NSDate().timeIntervalSince1970
        let key = "yyzhizhao_\(time).png"
        self.showHudInView(self.view, hint: "正在上传")
        API.sharedInstance.qnToken(key, success: { (info) in
            API.sharedInstance.uploadData(imgData!, key: key, token: info.token!, result: { (info, key, resp) in
                self.hideHud()
                if (info?.error != nil){
                    self.showHint(info?.error.description)
                } else {
                    self.showHint("上传成功!")
                    let url = "http://ob4e8ww8r.bkt.clouddn.com/" + key!
                    if (self.imgUrls.isEmpty) {
                        self.imgUrls = url
                    } else {
                        self.imgUrls = self.imgUrls + "," + url
                    }
                    if (self.currentIndex == 0) {
                        self.imgView1.af_setImageWithURL(NSURL.init(string: url)!)
                    } else if (self.currentIndex == 1) {
                        self.imgView2.af_setImageWithURL(NSURL.init(string: url)!)
                    } else if (self.currentIndex == 2) {
                        self.imgView3.af_setImageWithURL(NSURL.init(string: url)!)
                    }
                }
            })
        }) { (error) in
            self.hideHud()
            self.showHint(error)
        }
    }
    
    func submitOrder() {
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
        if (imgUrls.isEmpty) {
            self.showHint("请上传合同")
            return
        }
        
        self.showHudInView(self.view, hint: "提交中...")
        API.sharedInstance.insuranceAdd(insuranceType.company_id!, type_id: insuranceType.id!, years: years, price: insuranceType.price!, beneficiary_name: nameTextField.text!, beneficiary_phone: phoneTextField.text!, beneficiary_id_no: idTextField.text!, station_address: addressTextField.text!, client_contract_img: imgUrls, success: { (commonModel) in
                self.hideHud()
                self.aliPay(commonModel.order_sn!, title: self.insuranceType.size!, totalFee: String(self.insuranceType.price!.intValue * 100), type: commonModel.type!)
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