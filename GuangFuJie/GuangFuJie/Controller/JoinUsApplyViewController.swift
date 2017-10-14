//
//  JoinUsApplyViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/15.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class JoinUsApplyViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, ProviceCityViewDelegate {
    @IBOutlet weak var applyTableView: UITableView!
    var companyNameLabel: UITextField!
    var nameLabel: UITextField!
    var phoneLabel: UITextField!
    var sizeLabel: UITextField!
    var addressLabel: UITextField!
    var describeLabel: UITextField!
    var capitalLabel: UITextField!
    
    var currentProvince: ProvinceModel?
    var currentCity: CityModel?
    var currentArea: AreaModel?
    
    var img1 = ""
    var img2 = ""
    var img3 = ""
    
    var currentIndex = 0
    
    @IBOutlet weak var photoImage1: UIImageView!
    @IBOutlet weak var photoImage2: UIImageView!
    @IBOutlet weak var photoImage3: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "加盟商申请"
        photoImage1.isUserInteractionEnabled = true
        let tapGesture1 = UITapGestureRecognizer.init(target: self, action: #selector(self.addPhoto1))
        photoImage1.addGestureRecognizer(tapGesture1)
        
        photoImage2.isUserInteractionEnabled = true
        let tapGesture2 = UITapGestureRecognizer.init(target: self, action: #selector(self.addPhoto2))
        photoImage2.addGestureRecognizer(tapGesture2)
        
        photoImage3.isUserInteractionEnabled = true
        let tapGesture3 = UITapGestureRecognizer.init(target: self, action: #selector(self.addPhoto3))
        photoImage3.addGestureRecognizer(tapGesture3)
    }
    
    func addPhoto1() {
        currentIndex = 0
        self.selectPhotoPicker()
    }
    
    func addPhoto2() {
        currentIndex = 1
        self.selectPhotoPicker()
    }
    
    func addPhoto3() {
        currentIndex = 2
        self.selectPhotoPicker()
    }
    
    func proviceAndCity(_ provice: ProvinceModel, city: CityModel, area: AreaModel) {
        currentProvince = provice
        currentCity = city
        currentArea = area
        applyTableView.reloadData()
    }
    
    override func pickerCallback(_ image: UIImage) {
        let imgData = UIImagePNGRepresentation(image)
        let time = Date().timeIntervalSince1970
        let key = "roofphoto_\(time).png"
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
                        self.photoImage1.setImageWith(URL.init(string: url)!)
                    } else if (self.currentIndex == 1) {
                        self.img2 = url
                        self.photoImage2.setImageWith(URL.init(string: url)!)
                    } else if (self.currentIndex == 2) {
                        self.img3 = url
                        self.photoImage3.setImageWith(URL.init(string: url)!)
                    }
                }
            })
        }) { (error) in
            self.hideHud()
            self.showHint(error)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let submitBottomView = UIView.init(frame: CGRect(x: 0, y: PhoneUtils.kScreenHeight - 50, width: PhoneUtils.kScreenWidth, height: 50))
        submitBottomView.backgroundColor = UIColor.white
        self.view.addSubview(submitBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = submitBottomView.frame.size.height - 5 * 2
        
        let submitButton = GFJBottomButton.init(type: UIButtonType.custom)
        submitButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        submitButton.setTitle("提交审核", for: UIControlState.normal)
        submitButton.backgroundColor = Colors.appBlue
        submitButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: FontUtils.getFontSize(size: 17))
        submitButton.addTarget(self, action: #selector(self.submit), for: UIControlEvents.touchUpInside)
        submitBottomView.addSubview(submitButton)
    }
    
    func submit() {
        let companyName = companyNameLabel.text!
        let name = nameLabel.text!
        let phone = phoneLabel.text!
        let size = sizeLabel.text!
        let address = addressLabel.text!
        let describe = describeLabel.text!
        
        if (companyName.isEmpty) {
            self.showHint("请输入公司名称!")
            return
        }
        if (phone.isEmpty) {
            self.showHint("请输入手机号!")
            return
        }
        if (name.isEmpty) {
            self.showHint("请输入姓名!")
            return
        }
        if (size.isEmpty) {
            self.showHint("请输入公司规模!")
            return
        }
        if (currentProvince == nil || currentCity == nil || currentArea == nil) {
            self.showHint("请选择地区!")
            return
        }
        if (address.isEmpty) {
            self.showHint("请输入地址!")
            return
        }
        if (describe.isEmpty) {
            self.showHint("请输入公司简介!")
            return
        }
        if (img1 == "") {
            self.showHint("请上传营业执照!")
            return
        }
        if (img2 == "") {
            self.showHint("请上传许可证!")
            return
        }
        if (img3 == "") {
            self.showHint("请上传资质证书!")
            return
        }
        API.sharedInstance.franchiseeAdd(businessUrl: img1, electricalUrl: img2, licenserUrl: img3, companyName: companyName, companySize: size, companyDesc: describe, phone: phone, linkMan: name, provinceId: YCStringUtils.getNumber(currentProvince?.province_id), cityId: YCStringUtils.getNumber(currentCity?.city_id), areaId: YCStringUtils.getNumber(currentArea?.area_id), addressDetail: address, success: { (info) in
            self.showHint("提交成功")
            self.navigationController?.popViewController(animated: true)
        }) { (msg) in
            self.showHint(msg)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell_\(indexPath.section)_\(indexPath.row + 1)")
        if (indexPath.row == 0) {
            companyNameLabel = self.getTextField(views: cell!.contentView.subviews)
        } else if (indexPath.row == 1) {
            nameLabel = self.getTextField(views: cell!.contentView.subviews)
        } else if (indexPath.row == 2) {
            phoneLabel = self.getTextField(views: cell!.contentView.subviews)
        } else if (indexPath.row == 3) {
            sizeLabel = self.getTextField(views: cell!.contentView.subviews)
        } else if (indexPath.row == 4) {
            if (currentProvince != nil && currentArea != nil && currentCity != nil) {
                cell?.detailTextLabel?.text = "\(YCStringUtils.getString(currentProvince!.name))\(YCStringUtils.getString(currentCity!.name))\(YCStringUtils.getString(currentArea!.name))"
            }
        } else if (indexPath.row == 5) {
            addressLabel = self.getTextField(views: cell!.contentView.subviews)
        } else if (indexPath.row == 6){
            describeLabel = self.getTextField(views: cell!.contentView.subviews)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.row == 4) {
            let vc = ProviceCityViewController()
            vc.delegate = self
            
            let nav = UINavigationController.init(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
