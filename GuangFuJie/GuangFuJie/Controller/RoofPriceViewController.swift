//
//  RoofPriceViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/1.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class RoofPriceViewController: BaseViewController, ProviceCityViewDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    var tableView : UITableView!
    var currentType = 0
    var houseType = 0
    
    var clStr = "" //粗略面积
    var jqStr = "" //精确面积
    var tmpStr = ""
    
    
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
    
    func showHouseActionSheet() {
        let actionSheet = UIActionSheet()
        actionSheet.title = "选择房屋类型"
        actionSheet.delegate = self
        actionSheet.addButton(withTitle: "别墅")
        actionSheet.addButton(withTitle: "厂房")
        actionSheet.addButton(withTitle: "民房")
        actionSheet.addButton(withTitle: "取消")
        actionSheet.cancelButtonIndex = 3
        actionSheet.tag = HOUSE_ACTIONSHEET_TAG
        actionSheet.show(in: actionSheet)
    }
    
    func showTypeActionSheet() {
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
    
    func locationButtonClicked() {
        let vc = ProviceCityViewController()
        vc.delegate = self
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func proviceAndCity(_ provice: ProvinceModel, city: CityModel) {
        provinceInfo = provice
        cityInfo = city
        tableView.reloadData()
    }
    
    func showInputAlert() {
        let alertView = UIAlertView.init(title: "请输入面积", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertView.alertViewStyle = UIAlertViewStyle.plainTextInput
        alertView.show()
        
        alertView.textField(at: 0)?.keyboardType = UIKeyboardType.numberPad
        alertView.textField(at: 0)?.addTarget(self, action: #selector(self.textFieldValueChanged(textField:)), for: UIControlEvents.editingChanged)
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            if (tmpStr.isEmpty) {
                self.showHint("请输入面积!")
                return
            }
            if (currentType == 1) {
                clStr = tmpStr
            } else if (currentType == 2) {
                jqStr = tmpStr
            }
            tableView.reloadData()
        }
    }
    
    func textFieldValueChanged(textField : UITextField) {
        tmpStr = textField.text!
    }
    
    
    override func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if (actionSheet.cancelButtonIndex == buttonIndex) {
            return
        }
        if (actionSheet.tag == TYPE_ACTIONSHEET_TAG) {
            if (actionSheet.firstOtherButtonIndex + 1 == buttonIndex) {
                //粗略计算
                currentType = 1
            } else {
                //精确计算
                currentType = 2
            }
        } else {
            if (actionSheet.firstOtherButtonIndex + 1 == buttonIndex) {
                houseType = 1
            } else if (actionSheet.firstOtherButtonIndex + 1 == buttonIndex) {
                houseType = 2
            } else {
                houseType = 3
            }
        }
        tableView.reloadData()
    }
    
    let cellReuseIdentifier = "UITableViewCell"
    func initView() {
        let calBottomView = UIView.init(frame: CGRect(x: 0, y: PhoneUtils.kScreenHeight - 50, width: PhoneUtils.kScreenWidth, height: 50))
        calBottomView.backgroundColor = UIColor.white
        self.view.addSubview(calBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = calBottomView.frame.size.height - 5 * 2
        
        let calButton = GFJBottomButton.init(type: UIButtonType.custom)
        calButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        calButton.setTitle("立即评估", for: UIControlState.normal)
        calButton.backgroundColor = Colors.installColor
        calButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        calButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        calButton.addTarget(self, action: #selector(self.calacuteNow), for: UIControlEvents.touchUpInside)
        calBottomView.addSubview(calButton)
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 64, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - calBottomView.frame.size.height - 64), style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
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
            if (clStr.isEmpty) {
                self.showHint("请输入粗略面积")
                return
            }
            area = clStr
        } else if (currentType == 2) {
            if (houseType == 0) {
                self.showHint("请选择房屋类型")
                return
            }
            if (jqStr.isEmpty) {
                self.showHint("请输入室内面积")
                return
            }
            area = jqStr
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 5))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (currentType == 0) {
            return 4
        } else if (currentType == 1) {
            return 5
        }
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: cellReuseIdentifier)
        cell.textLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        if (currentType == 0) {
            if (indexPath.row == 0) {
                cell.textLabel?.text = "所在城市"
                cell.imageView?.image = UIImage(named: "ic_szfs")
                if (provinceInfo != nil && cityInfo != nil) {
                    cell.detailTextLabel?.text = provinceInfo!.province_label! + cityInfo!.city_label!
                } else {
                    cell.detailTextLabel?.text = "请选择城市"
                }
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            } else if (indexPath.row == 1) {
                cell.textLabel?.text = "政府补贴"
                cell.imageView?.image = UIImage(named: "ic_zfbt")
                cell.detailTextLabel?.text = "0.42元/瓦"
            } else if (indexPath.row == 2) {
                cell.textLabel?.text = "当地补贴"
                cell.imageView?.image = UIImage(named: "ic_ddbt")
                cell.detailTextLabel?.text = "0.20元/瓦"
            } else if (indexPath.row == 3) {
                cell.textLabel?.text = "计算方式"
                cell.imageView?.image = UIImage(named: "ic_jsfs")
                var typeStr = "请选择计算方式"
                if (currentType == 1) {
                    typeStr = "粗略计算"
                } else if (currentType == 2) {
                    typeStr = "精确计算"
                }
                cell.detailTextLabel?.text = typeStr
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
        } else if (currentType == 1) {
            if (indexPath.row == 0) {
                cell.textLabel?.text = "所在城市"
                cell.imageView?.image = UIImage(named: "ic_szfs")
                if (provinceInfo != nil && cityInfo != nil) {
                    cell.detailTextLabel?.text = provinceInfo!.province_label! + cityInfo!.city_label!
                } else {
                    cell.detailTextLabel?.text = "请选择城市"
                }
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            } else if (indexPath.row == 1) {
                cell.textLabel?.text = "政府补贴"
                cell.imageView?.image = UIImage(named: "ic_zfbt")
                cell.detailTextLabel?.text = "0.42元/瓦"
            } else if (indexPath.row == 2) {
                cell.textLabel?.text = "当地补贴"
                cell.imageView?.image = UIImage(named: "ic_ddbt")
                 cell.detailTextLabel?.text = "0.20元/瓦"
            } else if (indexPath.row == 3) {
                cell.textLabel?.text = "计算方式"
                cell.imageView?.image = UIImage(named: "ic_jsfs")
                var typeStr = "请选择计算方式"
                if (currentType == 1) {
                    typeStr = "粗略计算"
                } else if (currentType == 2) {
                    typeStr = "精确计算"
                }
                cell.detailTextLabel?.text = typeStr
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            } else if (indexPath.row == 4) {
                cell.textLabel?.text = "粗略面积"
                cell.imageView?.image = UIImage(named: "ic_clmj")
                var sizeStr = clStr
                if (sizeStr.isEmpty) {
                    sizeStr = "请输入粗略面积"
                }
                cell.detailTextLabel?.text = "\(sizeStr) 平米"
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
        } else if (currentType == 2){
            if (indexPath.row == 0) {
                cell.textLabel?.text = "所在城市"
                cell.imageView?.image = UIImage(named: "ic_szfs")
                if (provinceInfo != nil && cityInfo != nil) {
                    cell.detailTextLabel?.text = provinceInfo!.province_label! + cityInfo!.city_label!
                } else {
                    cell.detailTextLabel?.text = "请选择城市"
                }
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            } else if (indexPath.row == 1) {
                cell.textLabel?.text = "政府补贴"
                cell.imageView?.image = UIImage(named: "ic_zfbt")
                cell.detailTextLabel?.text = "0.42元/瓦"
            } else if (indexPath.row == 2) {
                cell.textLabel?.text = "当地补贴"
                cell.imageView?.image = UIImage(named: "ic_ddbt")
                cell.detailTextLabel?.text = "0.20元/瓦"
            } else if (indexPath.row == 3) {
                cell.textLabel?.text = "计算方式"
                cell.imageView?.image = UIImage(named: "ic_jsfs")
                var typeStr = "请选择计算方式"
                if (currentType == 1) {
                    typeStr = "粗略计算"
                } else if (currentType == 2) {
                    typeStr = "精确计算"
                }
                cell.detailTextLabel?.text = typeStr
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            } else if (indexPath.row == 4) {
                cell.textLabel?.text = "房屋类型"
                cell.imageView?.image = UIImage(named: "ic_fwlx")
                var typeStr = "请选择房屋类型"
                if (houseType == 1) {
                    typeStr = "别墅"
                } else if (houseType == 2) {
                    typeStr = "厂房"
                } else if (houseType == 3) {
                    typeStr = "民房"
                }
                cell.detailTextLabel?.text = typeStr
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            } else if (indexPath.row == 5) {
                cell.textLabel?.text = "室内面积"
                cell.imageView?.image = UIImage(named: "ic_snmj")
                var sizeStr = jqStr
                if (sizeStr.isEmpty) {
                    sizeStr = "请输入室内面积"
                }
                cell.detailTextLabel?.text = "\(sizeStr) 平米"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (currentType == 0) {
            if (indexPath.row == 0) {
                locationButtonClicked()
            } else if (indexPath.row == 3) {
                showTypeActionSheet()
            }
        } else if (currentType == 1) {
            if (indexPath.row == 0) {
                locationButtonClicked()
            } else if (indexPath.row == 3) {
                showTypeActionSheet()
            } else if (indexPath.row == 4) {
                showInputAlert()
            }
        } else {
            if (indexPath.row == 0) {
                locationButtonClicked()
            } else if (indexPath.row == 3) {
                showTypeActionSheet()
            } else if (indexPath.row == 4) {
                showHouseActionSheet()
            } else if (indexPath.row == 5) {
                showInputAlert()
            }
        }
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
