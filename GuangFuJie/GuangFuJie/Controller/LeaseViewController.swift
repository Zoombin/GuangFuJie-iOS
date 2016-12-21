//
//  LeaseViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/1.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class LeaseViewController: BaseViewController, ProviceCityViewDelegate {

    @IBOutlet weak var locationLabel : UILabel!
    @IBOutlet weak var addressTextField : UITextField!
    @IBOutlet weak var roofSizeField : UITextField!
    @IBOutlet weak var roofTypeButton : UIButton!
    @IBOutlet weak var priceTextField : UITextField!
    @IBOutlet weak var contractTextField : UITextField!
    @IBOutlet weak var contractPhoneField : UITextField!
    @IBOutlet weak var timeButton : UIButton!
    @IBOutlet weak var roofTypeView : UIView!
    @IBOutlet weak var datePicker : UIDatePicker!
    @IBOutlet weak var datePickerView : UIView!
    @IBOutlet weak var submitButton : UIButton!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var toolBar : UIToolbar!

    var imageView1 : UIImageView!
    var imageView2 : UIImageView!
    var imageView3 : UIImageView!
    let ROOF_ACTIONSHEET_TAG = 1001
    
    var roofTypeIndex = -1
    var type = 1
    var provinceInfo : ProvinceModel?
    var cityInfo : CityModel?
    var timeStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "房顶出租"
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        let offSet : CGFloat = 5
        let imageWidth = (PhoneUtils.kScreenWidth - offSet * 4) / 3
        let imageHeight = roofTypeView.frame.size.height - offSet * 2 - 20
        
        imageView1 = UIImageView.init(frame: CGRect(x: offSet, y: offSet, width: imageWidth, height: imageHeight))
        imageView1.image = UIImage(named: "ic_wuding_bies")
        imageView1.tag = 0
        imageView1.layer.borderColor = Colors.installColor.cgColor
        roofTypeView.addSubview(imageView1)
        
        let label1 = UILabel.init(frame: CGRect(x: imageView1.frame.origin.x, y: imageView1.frame.maxY, width: imageWidth, height: 20))
        label1.text = "别墅"
        label1.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        label1.textAlignment = NSTextAlignment.center
        roofTypeView.addSubview(label1)
        
        imageView2 = UIImageView.init(frame: CGRect(x: offSet * 2 + imageWidth, y: offSet, width: imageWidth, height: imageHeight))
        imageView2.image = UIImage(named: "ic_wuding_changf")
        imageView2.tag = 1
        imageView2.layer.borderColor = Colors.installColor.cgColor
        roofTypeView.addSubview(imageView2)
        
        let label2 = UILabel.init(frame: CGRect(x: imageView2.frame.origin.x, y: imageView2.frame.maxY, width: imageWidth, height: 20))
        label2.text = "厂房"
        label2.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        label2.textAlignment = NSTextAlignment.center
        roofTypeView.addSubview(label2)
        
        imageView3 = UIImageView.init(frame: CGRect(x: offSet * 3 + imageWidth * 2, y: offSet, width: imageWidth, height: imageHeight))
        imageView3.image = UIImage(named: "ic_wuding_nongc")
        imageView3.tag = 2
        imageView3.layer.borderColor = Colors.installColor.cgColor
        roofTypeView.addSubview(imageView3)
        
        let label3 = UILabel.init(frame: CGRect(x: imageView3.frame.origin.x, y: imageView1.frame.maxY, width: imageWidth, height: 20))
        label3.text = "民房"
        label3.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        label3.textAlignment = NSTextAlignment.center
        roofTypeView.addSubview(label3)
        
        let tapGesture1 = UITapGestureRecognizer.init(target: self, action: #selector(self.imageSelected(_:)))
        let tapGesture2 = UITapGestureRecognizer.init(target: self, action: #selector(self.imageSelected(_:)))
        let tapGesture3 = UITapGestureRecognizer.init(target: self, action: #selector(self.imageSelected(_:)))
        
        imageView1.isUserInteractionEnabled = true
        imageView2.isUserInteractionEnabled = true
        imageView3.isUserInteractionEnabled = true
    
        imageView1.addGestureRecognizer(tapGesture1)
        imageView2.addGestureRecognizer(tapGesture2)
        imageView3.addGestureRecognizer(tapGesture3)
        
        let roofSizeLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 80, height: addressTextField.frame.size.height))
        roofSizeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        roofSizeLabel.textColor = UIColor.darkGray
        roofSizeLabel.text = " 屋顶面积:"
        
        roofSizeField.leftViewMode = UITextFieldViewMode.always
        roofSizeField.leftView = roofSizeLabel
        
        let priceLeftLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 80, height: addressTextField.frame.size.height))
        priceLeftLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        priceLeftLabel.textColor = UIColor.darkGray
        priceLeftLabel.text = " 出租单价:"
        
        let priceRightLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 40, height: addressTextField.frame.size.height))
        priceRightLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        priceRightLabel.textColor = UIColor.darkGray
        priceRightLabel.textAlignment = NSTextAlignment.center
        priceRightLabel.text = "元/㎡"
        
        priceTextField.leftViewMode = UITextFieldViewMode.always
        priceTextField.rightViewMode = UITextFieldViewMode.always
        priceTextField.leftView = priceLeftLabel
        priceTextField.rightView = priceRightLabel
        
        let contractLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 80, height: addressTextField.frame.size.height))
        contractLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        contractLabel.textColor = UIColor.darkGray
        contractLabel.text = " 联系人:"
        
        contractTextField.leftViewMode = UITextFieldViewMode.always
        contractTextField.leftView = contractLabel
        
        let contractPhoneLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 80, height: addressTextField.frame.size.height))
        contractPhoneLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        contractPhoneLabel.textColor = UIColor.darkGray
        contractPhoneLabel.text = " 联系电话:"
        
        contractPhoneField.leftViewMode = UITextFieldViewMode.always
        contractPhoneField.leftView = contractPhoneLabel
        
        scrollView.contentSize = CGSize(width: 0, height: PhoneUtils.kScreenHeight < 568 ? 568 : PhoneUtils.kScreenHeight)
        
        toolBar.frame = CGRect(x: 0, y: datePicker.frame.minY - toolBar.frame.size.height, width: toolBar.frame.size.width, height: toolBar.frame.size.height)
    }
    
    @IBAction func locationButtonClicked(_ sender : UIButton) {
        let vc = ProviceCityViewController()
        vc.delegate = self
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func proviceAndCity(_ provice: ProvinceModel, city: CityModel) {
        provinceInfo = provice
        cityInfo = city
        locationLabel.text = provinceInfo!.province_label! + cityInfo!.city_label!
    }
    
    func imageSelected(_ gesture : UITapGestureRecognizer) {
        let index = gesture.view!.tag
        imageView1.layer.borderWidth = 0
        imageView2.layer.borderWidth = 0
        imageView3.layer.borderWidth = 0
        roofTypeIndex = index
        if (index == 0) {
            imageView1.layer.borderWidth = 2
        } else if (index == 1) {
            imageView2.layer.borderWidth = 2
        } else if (index == 2) {
            imageView3.layer.borderWidth = 2
        }
    }
    
    @IBAction func selectRoofTypeButtonClicked() {
        let actionSheet = UIActionSheet()
        actionSheet.title = "选择房屋类型"
        actionSheet.addButton(withTitle: "平面")
        actionSheet.addButton(withTitle: "斜面")
        actionSheet.addButton(withTitle: "取消")
        actionSheet.cancelButtonIndex = 2
        actionSheet.delegate = self
        actionSheet.show(in: actionSheet)
    }
    
    override func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if (actionSheet.cancelButtonIndex == buttonIndex) {
            return
        }
        if (actionSheet.firstOtherButtonIndex + 1 == buttonIndex) {
            roofTypeButton.setTitle("平面", for: UIControlState.normal)
            type = 1
        } else {
            roofTypeButton.setTitle("斜面", for: UIControlState.normal)
            type = 2
        }
    }
    
    @IBAction func datePickerValueChanged(_ sender : UIDatePicker) {
        print(sender.date)
        getCurrentDate()
    }
    
    func getCurrentDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM月dd日 HH时mm分"
        timeStr = dateFormatter.string(from: datePicker.date)
        timeButton.setTitle(timeStr, for: UIControlState.normal)
    }
    
    @IBAction func datePickerViewHidenOrShow() {
        getCurrentDate()
        datePickerView.isHidden = !datePickerView.isHidden
    }
    
    @IBAction func submitButtonClicked() {
        if (roofTypeIndex == -1) {
            self.showHint("请选择屋顶类型")
            return
        }
        if (roofTypeIndex == -1) {
            self.showHint("请选择屋顶类似图片")
            return
        }
        if (cityInfo == nil || provinceInfo == nil) {
            self.showHint("请选择所在城市");
            return;
        }
        if (addressTextField.text!.isEmpty) {
            self.showHint("请输入详细地址");
            return;
        }
        if (roofSizeField.text!.isEmpty) {
            self.showHint("请输入屋顶面积");
            return;
        }
        if (contractTextField.text!.isEmpty) {
            self.showHint("请输入联系人姓名");
            return;
        }
        if (priceTextField.text!.isEmpty) {
            self.showHint("请输入出租单价");
            return;
        }
        if (contractPhoneField.text!.isEmpty) {
            self.showHint("请输入联系电话")
            return
        }
        if (timeStr.isEmpty) {
            self.showHint("请选择预约时间");
            return;
        }
        
        var roofTypeUrl = ""
        if (roofTypeIndex == 0) {
            roofTypeUrl = "http://ob4e8ww8r.bkt.clouddn.com/ic_wuding_bies.jpg"
        } else if (roofTypeIndex == 1) {
            roofTypeUrl = "http://ob4e8ww8r.bkt.clouddn.com/ic_wuding_changf.jpg"
        } else if (roofTypeIndex == 2) {
            roofTypeUrl = "http://ob4e8ww8r.bkt.clouddn.com/ic_wuding_nongc.jpg"
        }
        self.showHud(in: self.view, hint: "提交中...")
        API.sharedInstance.roofAdd(contractTextField.text!, province_id: provinceInfo!.province_id!, city_id: cityInfo!.city_id!, address: addressTextField.text!, area_size: roofSizeField.text!, area_image: roofTypeUrl, type: NSNumber.init(value: type), contact_time: timeStr, price: priceTextField.text!, phone: contractPhoneField.text!, success: { (commonModel) in
                self.hideHud()
                self.showHint("提交成功")
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
