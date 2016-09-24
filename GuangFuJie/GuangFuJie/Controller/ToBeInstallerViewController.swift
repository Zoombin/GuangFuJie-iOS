//
//  ToBeInstallerViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/1.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class ToBeInstallerViewController: BaseViewController, UITextViewDelegate, ProviceCityViewDelegate {
    @IBOutlet weak var yinyezhizhaoImagView : UIImageView!
    @IBOutlet weak var locationLabel : UILabel!
    @IBOutlet weak var addressTextField : UITextField!
    @IBOutlet weak var companyTextField : UITextField!
    @IBOutlet weak var nameTextField : UITextField!
    @IBOutlet weak var phoneTextField : UITextField!
    @IBOutlet weak var installerCountTextField : UITextField!
    @IBOutlet weak var companyDescribeTextField : UITextView!
    @IBOutlet weak var describeHintLabel : UILabel!
    
    @IBOutlet weak var scrollView : UIScrollView!
    
    var provinceInfo : ProvinceModel?
    var cityInfo : CityModel?
    var imageUrl : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "申请成为安装商"
        // Do any additional setup after loading the view.
        initView()
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
                    self.imageUrl = url
                    self.yinyezhizhaoImagView.af_setImageWithURL(NSURL.init(string: url + "?imageView2/5/w/450/h/300")!)
                }
            })
        }) { (error) in
            self.hideHud()
            self.showHint(error)
        }
    }
    
    func initView() {
        var height = PhoneUtils.kScreenHeight
        if (height < 568) {
            height = 568
        }
        scrollView.contentSize = CGSizeMake(0, height + 1)
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.uploadImage))
        yinyezhizhaoImagView.userInteractionEnabled = true
        yinyezhizhaoImagView.addGestureRecognizer(tapGesture)
        
        let companyLeftLabel = UILabel.init(frame: CGRectMake(0, 0, 80, companyTextField.frame.size.height))
        companyLeftLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        companyLeftLabel.textColor = UIColor.darkGrayColor()
        companyLeftLabel.text = " 公司名称:"
        
        companyTextField.leftViewMode = UITextFieldViewMode.Always
        companyTextField.leftView = companyLeftLabel
        
        let nameLeftLabel = UILabel.init(frame: CGRectMake(0, 0, 80, nameTextField.frame.size.height))
        nameLeftLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        nameLeftLabel.textColor = UIColor.darkGrayColor()
        nameLeftLabel.text = " 联系人:"
        
        nameTextField.leftViewMode = UITextFieldViewMode.Always
        nameTextField.leftView = nameLeftLabel
        
        let phoneLeftLabel = UILabel.init(frame: CGRectMake(0, 0, 80, phoneTextField.frame.size.height))
        phoneLeftLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        phoneLeftLabel.textColor = UIColor.darkGrayColor()
        phoneLeftLabel.text = " 联系方式:"
        
        phoneTextField.leftViewMode = UITextFieldViewMode.Always
        phoneTextField.leftView = phoneLeftLabel
        
        let instalerCountLeftLabel = UILabel.init(frame: CGRectMake(0, 0, 80, installerCountTextField.frame.size.height))
        instalerCountLeftLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        instalerCountLeftLabel.textColor = UIColor.darkGrayColor()
        instalerCountLeftLabel.text = " 公司规模:"
        
        installerCountTextField.leftViewMode = UITextFieldViewMode.Always
        installerCountTextField.leftView = instalerCountLeftLabel
    }
    
    func textViewDidChange(textView: UITextView) {
        describeHintLabel.hidden = !textView.text.isEmpty
    }
    
    func proviceAndCity(provice: ProvinceModel, city: CityModel) {
        provinceInfo = provice
        cityInfo = city
        locationLabel.text = provinceInfo!.province_label! + cityInfo!.city_label!
    }
    
    func hidenAllKeyboard() {
        addressTextField.resignFirstResponder()
        companyTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        installerCountTextField.resignFirstResponder()
        companyDescribeTextField.resignFirstResponder()
    }
    
    @IBAction func submitButtonClicked(sender : UIButton) {
        hidenAllKeyboard()
        if (imageUrl == nil) {
            self.showHint("请先上传营业执照")
            return
        }
        if (provinceInfo == nil || cityInfo == nil) {
            self.showHint("请选择所在城市")
            return
        }
        if (addressTextField.text!.isEmpty) {
            self.showHint("请输入详细地址")
            return
        }
        if (companyTextField.text!.isEmpty) {
            self.showHint("请输入公司名称")
            return
        }
        if (nameTextField.text!.isEmpty) {
            self.showHint("请输入联系人姓名")
            return
        }
        if (phoneTextField.text!.isEmpty) {
            self.showHint("请输入联系方式")
            return
        }
        if (installerCountTextField.text!.isEmpty) {
            self.showHint("请输入公司规模")
            return
        }
        if (companyDescribeTextField.text!.isEmpty) {
            self.showHint("请输入公司简介")
            return
        }
        self.showHudInView(self.view, hint: "提交中...")
        API.sharedInstance.becomeInstaller(nameTextField.text!, license_url: imageUrl!, province_id: provinceInfo!.province_id!, city_id: cityInfo!.city_id!, address: addressTextField.text!, contact_info: phoneTextField.text!, company_name: companyTextField.text!, company_size: installerCountTextField.text!, company_intro: companyDescribeTextField.text!, success: { (commonModel) in
                self.hideHud()
                self.showHint("申请成功,等待审核")
                self.navigationController?.popViewControllerAnimated(true)
            }) { (msg) in
                self.hideHud()
                self.showHint(msg)
        }
    }

    @IBAction func locationButtonClicked(sender : UIButton) {
        let vc = ProviceCityViewController()
        vc.delegate = self
        let nav = UINavigationController.init(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: nil)
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
