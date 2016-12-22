//
//  RoofPriceViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/1.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class RoofPriceViewController: BaseViewController, ProviceCityViewDelegate {
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var locationLabel : UILabel!
    @IBOutlet weak var typeButton : UIButton!
    
    @IBOutlet weak var type1View : UIView!
    @IBOutlet weak var type1TextField : UITextField!
    
    @IBOutlet weak var type2TextField : UITextField! //类型2TextField
    @IBOutlet weak var type2View : UIView!     //类型2View
    @IBOutlet weak var type2Button : UIButton! //房屋类型
    
    @IBOutlet weak var rightView1 : UILabel!
    @IBOutlet weak var rightView2 : UILabel!
    
    var currentType = 0
    var houseType = 0
    
    let TYPE_ACTIONSHEET_TAG = 1001 //计算类型的tag
    let HOUSE_ACTIONSHEET_TAG = 1002 //选择房屋类型的tag
    
    
    var provinceInfo : ProvinceModel?
    var cityInfo : CityModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "房顶估价"
        // Do any additional setup after loading the view.
        initView()
    }
    
    @IBAction func showHouseActionSheet() {
        let actionSheet = UIActionSheet()
        actionSheet.title = "选择房屋类型"
        actionSheet.delegate = self
        actionSheet.addButton(withTitle: "别墅")
        actionSheet.addButton(withTitle: "厂房")
        actionSheet.addButton(withTitle: "民房")
        actionSheet.addButton(withTitle: "取消")
        actionSheet.cancelButtonIndex = 2
        actionSheet.tag = HOUSE_ACTIONSHEET_TAG
        actionSheet.show(in: actionSheet)
    }
    
    @IBAction func showTypeActionSheet() {
        let actionSheet = UIActionSheet()
        actionSheet.title = "选择计算类型"
        actionSheet.delegate = self
        actionSheet.addButton(withTitle: "粗略计算")
        actionSheet.addButton(withTitle: "精确计算")
        actionSheet.addButton(withTitle: "取消")
        actionSheet.cancelButtonIndex = 2
        actionSheet.tag = TYPE_ACTIONSHEET_TAG
        actionSheet.show(in: actionSheet)
    }
    
    override func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if (actionSheet.cancelButtonIndex == buttonIndex) {
            return
        }
        if (actionSheet.tag == TYPE_ACTIONSHEET_TAG) {
            if (actionSheet.firstOtherButtonIndex + 1 == buttonIndex) {
                //粗略计算
                typeButton.setTitle("粗略计算", for: UIControlState.normal)
                type2View.isHidden = true
                type1View.isHidden = false
                currentType = 1
            } else {
                //精确计算
                typeButton.setTitle("精确计算", for: UIControlState.normal)
                type2View.isHidden = false
                type1View.isHidden = true
                currentType = 2
            }
        } else {
            if (actionSheet.firstOtherButtonIndex + 1 == buttonIndex) {
                type2Button.setTitle("别墅", for: UIControlState.normal)
                houseType = 1
            } else if (actionSheet.firstOtherButtonIndex + 1 == buttonIndex) {
                type2Button.setTitle("厂房", for: UIControlState.normal)
                houseType = 2
            } else {
                type2Button.setTitle("民房", for: UIControlState.normal)
                houseType = 3
            }
        }
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
    
    func initView() {
        let calBottomView = UIView.init(frame: CGRect(x: 0, y: PhoneUtils.kScreenHeight - 50, width: PhoneUtils.kScreenWidth, height: 50))
        calBottomView.backgroundColor = UIColor.white
        self.view.addSubview(calBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = calBottomView.frame.size.height - 5 * 2
        
        let calButton = UIButton.init(type: UIButtonType.custom)
        calButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        calButton.setTitle("立即评估", for: UIControlState.normal)
        calButton.backgroundColor = Colors.installColor
        calButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        calButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        calButton.addTarget(self, action: #selector(self.calacuteNow), for: UIControlEvents.touchUpInside)
        calBottomView.addSubview(calButton)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - calBottomView.frame.size.height - 64)
        
        type1TextField.rightView = rightView1
        type1TextField.rightViewMode = UITextFieldViewMode.always
        
        type2TextField.rightView = rightView2
        type2TextField.rightViewMode = UITextFieldViewMode.always
    }
    
    func calacuteNow() {
        var area = ""
        if (cityInfo == nil || provinceInfo == nil) {
            self.showHint("请选择所在地");
            return;
        }
        if (currentType == 0) {
            self.showHint("请选择计算类型")
            return
        }
        if (currentType == 1) {
            if (type1TextField.text!.isEmpty) {
                self.showHint("请输入粗略面积")
                return
            }
            area = type1TextField.text!
        } else if (currentType == 2) {
            if (houseType == 0) {
                self.showHint("请选择房屋类型")
                return
            }
            if (type2TextField.text!.isEmpty) {
                self.showHint("请输入室内面积")
                return
            }
            area = type2TextField.text!
        }
        let calModel = CalcModel()
        calModel.area = area
        calModel.province_id = provinceInfo!.province_id
        calModel.city_id = cityInfo!.city_id
        calModel.type = currentType as NSNumber?
        
        let vc = CalResultViewController()
        vc.calModel = calModel
        self.pushViewController(vc)
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
