//
//  DituiApplyViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/15.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class DituiApplyViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, ProviceCityViewDelegate {
    @IBOutlet weak var applyTableView: UITableView!
    var nameTextField: UITextField!
    var phoneTextField: UITextField!
    var addressTextField: UITextField!
    
    var currentProvince: ProvinceModel?
    var currentCity: CityModel?
    var currentArea: AreaModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "地推申请"
        // Do any additional setup after loading the view.
    }
    
    func proviceAndCity(_ provice: ProvinceModel, city: CityModel, area: AreaModel) {
        currentProvince = provice
        currentCity = city
        currentArea = area
        applyTableView.reloadData()
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
        let phone = phoneTextField.text!
        let name = nameTextField.text!
        let address = addressTextField.text!
        
        if (phone.isEmpty) {
            self.showHint("请输入手机号!")
            return
        }
        if (name.isEmpty) {
            self.showHint("请输入姓名!")
            return
        }
        //地址可不填
        if (currentProvince == nil || currentCity == nil || currentArea == nil) {
            self.showHint("请选择地区!")
            return
        }
        API.sharedInstance.groundAdd(name: name, phone: phone, provinceId: YCStringUtils.getNumber(currentProvince?.province_id), cityId: YCStringUtils.getNumber(currentCity?.city_id), areaId: YCStringUtils.getNumber(currentArea?.area_id), addressDetail: address, success: { (info) in
            self.showHint("提交成功")
            self.navigationController?.popViewController(animated: true)
        }) { (msg) in
            self.showHint(msg)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell_\(indexPath.section)_\(indexPath.row + 1)")
        if (indexPath.row == 0) {
            nameTextField = self.getTextField(views: cell!.contentView.subviews)
        } else if (indexPath.row == 1) {
            phoneTextField = self.getTextField(views: cell!.contentView.subviews)
        } else if (indexPath.row == 2) {
            if (currentProvince != nil && currentArea != nil && currentCity != nil) {
                cell?.detailTextLabel?.text = "\(YCStringUtils.getString(currentProvince!.name))\(YCStringUtils.getString(currentCity!.name))\(YCStringUtils.getString(currentArea!.name))"
            }
        } else {
            addressTextField = self.getTextField(views: cell!.contentView.subviews)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.row == 2) {
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
