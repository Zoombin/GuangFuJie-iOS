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
        actionSheet.addButtonWithTitle("别墅")
        actionSheet.addButtonWithTitle("厂房")
        actionSheet.addButtonWithTitle("民房")
        actionSheet.addButtonWithTitle("取消")
        actionSheet.cancelButtonIndex = 2
        actionSheet.tag = HOUSE_ACTIONSHEET_TAG
        actionSheet.showInView(actionSheet)
    }
    
    @IBAction func showTypeActionSheet() {
        let actionSheet = UIActionSheet()
        actionSheet.title = "选择计算类型"
        actionSheet.delegate = self
        actionSheet.addButtonWithTitle("粗略计算")
        actionSheet.addButtonWithTitle("精确计算")
        actionSheet.addButtonWithTitle("取消")
        actionSheet.cancelButtonIndex = 2
        actionSheet.tag = TYPE_ACTIONSHEET_TAG
        actionSheet.showInView(actionSheet)
    }
    
    override func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if (actionSheet.cancelButtonIndex == buttonIndex) {
            return
        }
        if (actionSheet.tag == TYPE_ACTIONSHEET_TAG) {
            if (actionSheet.firstOtherButtonIndex + 1 == buttonIndex) {
                //粗略计算
                typeButton.setTitle("粗略计算", forState: UIControlState.Normal)
                type2View.hidden = true
                type1View.hidden = false
                currentType = 1
            } else {
                //精确计算
                typeButton.setTitle("精确计算", forState: UIControlState.Normal)
                type2View.hidden = false
                type1View.hidden = true
                currentType = 2
            }
        } else {
            if (actionSheet.firstOtherButtonIndex + 1 == buttonIndex) {
                type2Button.setTitle("别墅", forState: UIControlState.Normal)
                houseType = 1
            } else if (actionSheet.firstOtherButtonIndex + 1 == buttonIndex) {
                type2Button.setTitle("厂房", forState: UIControlState.Normal)
                houseType = 2
            } else {
                type2Button.setTitle("民房", forState: UIControlState.Normal)
                houseType = 3
            }
        }
    }
    
    @IBAction func locationButtonClicked(sender : UIButton) {
        let vc = ProviceCityViewController()
        vc.delegate = self
        let nav = UINavigationController.init(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func proviceAndCity(provice: ProvinceModel, city: CityModel) {
        provinceInfo = provice
        cityInfo = city
        locationLabel.text = provinceInfo!.province_label! + cityInfo!.city_label!
    }
    
    func initView() {
        let calBottomView = UIView.init(frame: CGRectMake(0, PhoneUtils.kScreenHeight - 50, PhoneUtils.kScreenWidth, 50))
        calBottomView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(calBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = calBottomView.frame.size.height - 5 * 2
        
        let calButton = UIButton.init(type: UIButtonType.Custom)
        calButton.frame = CGRectMake(5, 5, buttonWidth, buttonHeight)
        calButton.setTitle("立即评估", forState: UIControlState.Normal)
        calButton.backgroundColor = Colors.installColor
        calButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        calButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge2)
        calButton.addTarget(self, action: #selector(self.calacuteNow), forControlEvents: UIControlEvents.TouchUpInside)
        calBottomView.addSubview(calButton)
        
        scrollView.frame = CGRectMake(0, 0, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - calBottomView.frame.size.height - 64)
        
        type1TextField.rightView = rightView1
        type1TextField.rightViewMode = UITextFieldViewMode.Always
        
        type2TextField.rightView = rightView2
        type2TextField.rightViewMode = UITextFieldViewMode.Always
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
        calModel.type = currentType
        
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
