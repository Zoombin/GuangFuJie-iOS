//
//  DeviceDetailViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/10.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class DeviceDetailViewController: BaseViewController, UIAlertViewDelegate {
    var todayElectricLabel : UILabel!
    var totalElectricLabel : UILabel!
    var todayMoneyLabel : UILabel!
    var totalMoneyLabel : UILabel!
    var todayjianpaiLabel : UILabel!
    var totaljianpaiLabel : UILabel!
    var todayplantLabel : UILabel!
    var totalplantLabel : UILabel!
    var viewDetailButton : UIButton!
    
    var electricView : UIView!
    
    let offSetY : CGFloat = 10
    let offSetX : CGFloat = 10
    var device_id : String = ""
    
    var normalInfoButton: UIButton!
    var lineButton: UIButton!
    var barButton: UIButton!
    var statusButton: UIButton!
    
    let topButtonHeight = PhoneUtils.kScreenHeight / 14
    
    //发电量
    var pnLineChart : PNLineChart!
    var pnBarChart : PNBarChart!
    var picView : UIView!
    let infoArray = NSMutableArray()
    var currentIndex = 0
    var snButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设备详情"
        initTopView()
        initElectricView()
        initPicView()
        
        getDeviceInfo()
        // Do any additional setup after loading the view.
    }
    
    func topButtonClicked(sender: UIButton) {
        currentIndex = sender.tag
        normalInfoButton.backgroundColor = Colors.topButtonColor
        lineButton.backgroundColor = Colors.topButtonColor
        barButton.backgroundColor = Colors.topButtonColor
        electricView.hidden = true
        picView.hidden = true
        if (pnBarChart != nil && pnLineChart != nil) {
            pnBarChart.hidden = true
            pnLineChart.hidden = true
        }
        
        if (sender.tag == 0) {
            normalInfoButton.backgroundColor = Colors.installColor
            electricView.hidden = false
        } else if (sender.tag == 1) {
            lineButton.backgroundColor = Colors.installColor
            picView.hidden = false
            loadPicData()
            if (pnLineChart != nil) {
                pnLineChart.hidden = false
            }
        } else if (sender.tag == 2) {
            barButton.backgroundColor = Colors.installColor
            picView.hidden = false
            loadPicData()
            if (pnBarChart != nil) {
                pnBarChart.hidden = false
            }
        }
    }
    
    func initTopView() {
        let topView = UIView.init(frame: CGRectMake(0, 64, PhoneUtils.kScreenWidth, topButtonHeight))
        topView.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(topView)
        
        normalInfoButton = UIButton.init(type: UIButtonType.Custom)
        normalInfoButton.setTitle("基本信息", forState: UIControlState.Normal)
        normalInfoButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        normalInfoButton.backgroundColor = Colors.installColor
        normalInfoButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        normalInfoButton.frame = CGRectMake(0, 0, (PhoneUtils.kScreenWidth / 3) - 1, topButtonHeight)
        normalInfoButton.tag = 0
        topView.addSubview(normalInfoButton)
        
        lineButton = UIButton.init(type: UIButtonType.Custom)
        lineButton.setTitle("曲线图", forState: UIControlState.Normal)
        lineButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        lineButton.backgroundColor = Colors.topButtonColor
        lineButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        lineButton.frame = CGRectMake((PhoneUtils.kScreenWidth / 3) + 1, 0, (PhoneUtils.kScreenWidth / 3) - 1, topButtonHeight)
        lineButton.tag = 1
        topView.addSubview(lineButton)
        
        barButton = UIButton.init(type: UIButtonType.Custom)
        barButton.setTitle("柱状图", forState: UIControlState.Normal)
        barButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        barButton.backgroundColor = Colors.topButtonColor
        barButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        barButton.frame = CGRectMake((PhoneUtils.kScreenWidth * 2 / 3) + 1 * 2, 0, (PhoneUtils.kScreenWidth / 3) - 1, topButtonHeight)
        barButton.tag = 2
        topView.addSubview(barButton)
    }
    
    func removeDeviceButtonClicked() {
        let alertView = UIAlertView.init(title: "提示", message: "是否解除绑定设备?", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertView.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.showHudInView(self.view, hint: "解绑中...")
        if (alertView.cancelButtonIndex != buttonIndex) {
            API.sharedInstance.unBindDevice(device_id, success: { (commomModel) in
                    self.hideHud()
                    self.showHint("解绑成功!")
                    self.navigationController?.popViewControllerAnimated(true)
                }, failure: { (msg) in
                    self.hideHud()
                    self.showHint(msg)
            })
        }
    }
    
    //MARK: 发电量
    func initElectricView() {
        electricView = UIView.init(frame: CGRectMake(0, 64 + topButtonHeight, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - 64 - topButtonHeight))
        electricView.backgroundColor = Colors.bkgGray
        self.view.addSubview(electricView)
        
        let deviceBottomView = UIView.init(frame: CGRectMake(0, electricView.frame.size.height - 50, PhoneUtils.kScreenWidth, 50))
        deviceBottomView.backgroundColor = UIColor.whiteColor()
        electricView.addSubview(deviceBottomView)
        
        let removeButton = UIButton.init(type: UIButtonType.Custom)
        removeButton.frame = CGRectMake(5, 5, PhoneUtils.kScreenWidth - 5 * 2, deviceBottomView.frame.size.height - 5 * 2)
        removeButton.setTitle("解绑设备", forState: UIControlState.Normal)
        removeButton.backgroundColor = Colors.installColor
        removeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        removeButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge2)
        removeButton.addTarget(self, action: #selector(self.removeDeviceButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        deviceBottomView.addSubview(removeButton)
    
        let labelHeight = PhoneUtils.kScreenHeight / 12
        
        let topView = UIView.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, labelHeight))
        topView.backgroundColor = UIColor.whiteColor()
        electricView.addSubview(topView)
        
        //运行状态
        statusButton = UIButton.init(type: UIButtonType.Custom)
        statusButton.frame = CGRectMake(0, 0, PhoneUtils.kScreenWidth * 2 / 3, labelHeight)
        statusButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        statusButton.setTitle("运行状态 正常", forState: UIControlState.Normal)
        statusButton.setTitle("运行状态 故障（点击报修）", forState: UIControlState.Selected)
        statusButton.setTitle("运行状态 离线", forState: UIControlState.Disabled)
        
        statusButton.setTitleColor(Colors.statusOK, forState: UIControlState.Normal)
        statusButton.setTitleColor(Colors.statusError, forState: UIControlState.Selected)
        statusButton.setTitleColor(Colors.statusOffLine, forState: UIControlState.Disabled)
        
        statusButton.setImage(UIImage(named: "ic_devstatus_ok"), forState: UIControlState.Normal)
        statusButton.setImage(UIImage(named: "ic_devstatus_error"), forState: UIControlState.Selected)
        statusButton.setImage(UIImage(named: "ic_devstatus_offline"), forState: UIControlState.Disabled)
        statusButton.userInteractionEnabled = false
        statusButton.addTarget(self, action: #selector(self.reportPro), forControlEvents: UIControlEvents.TouchUpInside)
        statusButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        statusButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        statusButton.backgroundColor = UIColor.whiteColor()
        statusButton.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        topView.addSubview(statusButton)
        
        //sn
        snButton = UIButton.init(type: UIButtonType.Custom)
        snButton.frame = CGRectMake(PhoneUtils.kScreenWidth * 2 / 3, 0, PhoneUtils.kScreenWidth * 1 / 3, labelHeight)
        snButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        snButton.setTitle("402415512", forState: UIControlState.Normal)
        snButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        snButton.setImage(UIImage(named: "ic_dev_sn"), forState: UIControlState.Normal)
        snButton.userInteractionEnabled = false
        snButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        snButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        snButton.backgroundColor = UIColor.whiteColor()
        topView.addSubview(snButton)
        
        let buttonWidth = PhoneUtils.kScreenWidth / 4
        //今日发电
        let todayElectricButton = UIButton.init(type: UIButtonType.Custom)
        todayElectricButton.frame = CGRectMake(0, CGRectGetMaxY(topView.frame) + 1, buttonWidth, labelHeight)
        todayElectricButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        todayElectricButton.setTitle("今日发电:", forState: UIControlState.Normal)
        todayElectricButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        todayElectricButton.setImage(UIImage(named: "ic_h_powerday_single"), forState: UIControlState.Normal)
        todayElectricButton.backgroundColor = UIColor.whiteColor()
        todayElectricButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        electricView.addSubview(todayElectricButton)
        
        todayElectricLabel = UILabel.init(frame:CGRectMake(CGRectGetMaxX(todayElectricButton.frame), CGRectGetMaxY(topView.frame) + 1, buttonWidth, labelHeight))
        todayElectricLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        todayElectricLabel.text = ""
        todayElectricLabel.textColor = UIColor.blackColor()
        todayElectricLabel.backgroundColor = UIColor.whiteColor()
        electricView.addSubview(todayElectricLabel)
        
        //累计发电
        let totalElectricButton = UIButton.init(type: UIButtonType.Custom)
        totalElectricButton.frame = CGRectMake((PhoneUtils.kScreenWidth / 2) + 1, CGRectGetMaxY(topView.frame) + 1, buttonWidth, labelHeight)
        totalElectricButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        totalElectricButton.setTitle("累计发电:", forState: UIControlState.Normal)
        totalElectricButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        totalElectricButton.setImage(UIImage(named: "ic_h_allpower"), forState: UIControlState.Normal)
        totalElectricButton.backgroundColor = UIColor.whiteColor()
        totalElectricButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        electricView.addSubview(totalElectricButton)
        
        totalElectricLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(totalElectricButton.frame), CGRectGetMaxY(topView.frame) + 1, buttonWidth - 1, labelHeight))
        totalElectricLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        totalElectricLabel.text = ""
        totalElectricLabel.textColor = UIColor.blackColor()
        totalElectricLabel.backgroundColor = UIColor.whiteColor()
        electricView.addSubview(totalElectricLabel)
        
        //今日收益
        let todayMoneyButton = UIButton.init(type: UIButtonType.Custom)
        todayMoneyButton.frame = CGRectMake(0, CGRectGetMaxY(totalElectricButton.frame) + 1, buttonWidth, labelHeight)
        todayMoneyButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        todayMoneyButton.setTitle("今日收益:", forState: UIControlState.Normal)
        todayMoneyButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        todayMoneyButton.setImage(UIImage(named: "ic_h_dayincome"), forState: UIControlState.Normal)
        todayMoneyButton.backgroundColor = UIColor.whiteColor()
        todayMoneyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        electricView.addSubview(todayMoneyButton)
        
        todayMoneyLabel = UILabel.init(frame:CGRectMake(CGRectGetMaxX(todayMoneyButton.frame),CGRectGetMaxY(todayElectricButton.frame) + 1, buttonWidth, labelHeight))
        todayMoneyLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        todayMoneyLabel.text = ""
        todayMoneyLabel.textColor = UIColor.blackColor()
        todayMoneyLabel.backgroundColor = UIColor.whiteColor()
        electricView.addSubview(todayMoneyLabel)
        
        //累计收益
        let totalMoneyButton = UIButton.init(type: UIButtonType.Custom)
        totalMoneyButton.frame = CGRectMake((PhoneUtils.kScreenWidth / 2) + 1, CGRectGetMaxY(todayElectricLabel.frame) + 1, buttonWidth, labelHeight)
        totalMoneyButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        totalMoneyButton.setTitle("累计收益:", forState: UIControlState.Normal)
        totalMoneyButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        totalMoneyButton.setImage(UIImage(named: "ic_h_allincome"), forState: UIControlState.Normal)
        totalMoneyButton.backgroundColor = UIColor.whiteColor()
        totalMoneyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        electricView.addSubview(totalMoneyButton)
        
        totalMoneyLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(totalMoneyButton.frame), CGRectGetMaxY(todayElectricLabel.frame) + 1, buttonWidth - 1, labelHeight))
        totalMoneyLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        totalMoneyLabel.text = ""
        totalMoneyLabel.textColor = UIColor.blackColor()
        totalMoneyLabel.backgroundColor = UIColor.whiteColor()
        electricView.addSubview(totalMoneyLabel)
        
        //今日减排
        let todayjianpaiButton = UIButton.init(type: UIButtonType.Custom)
        todayjianpaiButton.frame = CGRectMake(0, CGRectGetMaxY(todayMoneyButton.frame) + 1, buttonWidth, labelHeight)
        todayjianpaiButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        todayjianpaiButton.setTitle("今日减排:", forState: UIControlState.Normal)
        todayjianpaiButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        todayjianpaiButton.setImage(UIImage(named: "ic_reduce"), forState: UIControlState.Normal)
        todayjianpaiButton.backgroundColor = UIColor.whiteColor()
        todayjianpaiButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        electricView.addSubview(todayjianpaiButton)
        
        todayjianpaiLabel = UILabel.init(frame:CGRectMake(CGRectGetMaxX(todayjianpaiButton.frame),CGRectGetMaxY(todayMoneyButton.frame) + 1, buttonWidth, labelHeight))
        todayjianpaiLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        todayjianpaiLabel.text = ""
        todayjianpaiLabel.textColor = UIColor.blackColor()
        todayjianpaiLabel.backgroundColor = UIColor.whiteColor()
        electricView.addSubview(todayjianpaiLabel)
        
        //累计减排
        let totaljianpaiButton = UIButton.init(type: UIButtonType.Custom)
        totaljianpaiButton.frame = CGRectMake((PhoneUtils.kScreenWidth / 2) + 1, CGRectGetMaxY(todayMoneyButton.frame) + 1, buttonWidth - 1, labelHeight)
        totaljianpaiButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        totaljianpaiButton.setTitle("累计减排:", forState: UIControlState.Normal)
        totaljianpaiButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        totaljianpaiButton.setImage(UIImage(named: "ic_allreduce"), forState: UIControlState.Normal)
        totaljianpaiButton.backgroundColor = UIColor.whiteColor()
        totaljianpaiButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        electricView.addSubview(totaljianpaiButton)
        
        totaljianpaiLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(totaljianpaiButton.frame), CGRectGetMaxY(todayMoneyButton.frame) + 1, buttonWidth, labelHeight))
        totaljianpaiLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        totaljianpaiLabel.text = ""
        totaljianpaiLabel.textColor = UIColor.blackColor()
        totaljianpaiLabel.backgroundColor = UIColor.whiteColor()
        electricView.addSubview(totaljianpaiLabel)
        
        //今日种植
        let todayPlantButton = UIButton.init(type: UIButtonType.Custom)
        todayPlantButton.frame = CGRectMake(0, CGRectGetMaxY(todayjianpaiButton.frame) + 1, buttonWidth, labelHeight)
        todayPlantButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        todayPlantButton.setTitle("今日种植:", forState: UIControlState.Normal)
        todayPlantButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        todayPlantButton.setImage(UIImage(named: "ic_grow_day"), forState: UIControlState.Normal)
        todayPlantButton.backgroundColor = UIColor.whiteColor()
        todayPlantButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        electricView.addSubview(todayPlantButton)
        
        todayplantLabel = UILabel.init(frame:CGRectMake(CGRectGetMaxX(todayPlantButton.frame),CGRectGetMaxY(todayjianpaiButton.frame) + 1, buttonWidth, labelHeight))
        todayplantLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        todayplantLabel.text = ""
        todayplantLabel.textColor = UIColor.blackColor()
        todayplantLabel.backgroundColor = UIColor.whiteColor()
        electricView.addSubview(todayplantLabel)
        
        //累计种植
        let totalPlantButton = UIButton.init(type: UIButtonType.Custom)
        totalPlantButton.frame = CGRectMake((PhoneUtils.kScreenWidth / 2) + 1, CGRectGetMaxY(todayjianpaiButton.frame) + 1, buttonWidth, labelHeight)
        totalPlantButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        totalPlantButton.setTitle("累计种植:", forState: UIControlState.Normal)
        totalPlantButton.setTitleColor(Colors.installColor, forState: UIControlState.Normal)
        totalPlantButton.setImage(UIImage(named: "ic_allgrow"), forState: UIControlState.Normal)
        totalPlantButton.backgroundColor = UIColor.whiteColor()
        totalPlantButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        electricView.addSubview(totalPlantButton)
        
        totalplantLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(totalPlantButton.frame), CGRectGetMaxY(todayjianpaiButton.frame) + 1, buttonWidth - 1, labelHeight))
        totalplantLabel.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        totalplantLabel.text = ""
        totalplantLabel.textColor = UIColor.blackColor()
        totalplantLabel.backgroundColor = UIColor.whiteColor()
        electricView.addSubview(totalplantLabel)
    }
    
    func loadPicData() {
        if (self.infoArray.count > 0) {
            return
        }
        self.showHudInView(self.view, hint: "加载中...")
        API.sharedInstance.getEnergyStatistic(device_id, year: "2016", success: { (powerGraphInfos) in
            self.hideHud()
            self.infoArray.addObjectsFromArray(powerGraphInfos as [AnyObject])
            self.initLineBarChart()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    func initLineBarChart() {
        let xLabels = NSMutableArray()
        let yLabels = NSMutableArray()
        for i in 0..<infoArray.count {
            let power = infoArray[i] as! PowerGraphInfo
            xLabels.addObject(String(power.month!) + "月")
            yLabels.addObject(power.energy_month == nil ? "0" : String(power.energy_month!))
        }
        
        if (xLabels.count == 0 || xLabels == 1) {
            self.showHint("暂无数据!")
            return
        }
        
        pnLineChart = ChartUtils.addLineChartsWidthFrame(xLabels, yDates: yLabels, andFrame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, picView.frame.size.height))
        picView.addSubview(pnLineChart)
        pnLineChart.strokeChart()
        pnLineChart.hidden = currentIndex != 1
        
        pnBarChart = ChartUtils.addBarChartsWidthFrame(xLabels, yDates: yLabels, andFrame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, picView.frame.size.height))
        picView.addSubview(pnBarChart)
        pnBarChart.strokeChart()
        pnBarChart.hidden = currentIndex != 2
    }
    
    func initPicView() {
        picView = UIView.init(frame: CGRectMake(0, 64 + topButtonHeight, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - 64 - topButtonHeight))
        picView.hidden = true
        self.view.addSubview(picView)
    }
    
    func getDeviceInfo() {
        API.sharedInstance.deviceInfo(device_id, success: { (deviceInfo) in
            self.hideHud()
            self.loadDeviceInfo(deviceInfo)
            }, failure: { (msg) in
                self.hideHud()
                self.showHint(msg)
        })
    }
    
    func loadDeviceInfo(deviceInfo : DeviceInfo) {
        if (deviceInfo.status?.integerValue == 1) {
            self.statusButton.selected = false
            self.statusButton.enabled = true
        } else if (deviceInfo.status?.integerValue == 2) {
            self.statusButton.selected = true
            self.statusButton.enabled = true
            statusButton.userInteractionEnabled = true
        } else if (deviceInfo.status?.integerValue == 3) {
            self.statusButton.selected = false
            self.statusButton.enabled = false
        }
    
        if (deviceInfo.energy_day == nil || deviceInfo.energy_all == nil) {
            todayElectricLabel.text = "0kw"
            totalElectricLabel.text = "0kw"
            todayMoneyLabel.text = "0元"
            totalMoneyLabel.text = "0元"
            todayjianpaiLabel.text = "0吨"
            totaljianpaiLabel.text = "0吨"
            todayplantLabel.text = "0棵"
            totalplantLabel.text = "0棵"
            return
        }
        todayElectricLabel.text = String(format: "%@kw", deviceInfo.energy_day!)
        totalElectricLabel.text = String(format: "%@kw", deviceInfo.energy_all!)
        todayMoneyLabel.text = String(format: "%.2f元", deviceInfo.energy_day!.floatValue * 3)
        totalMoneyLabel.text = String(format: "%.2f元", deviceInfo.energy_all!.floatValue * 3)
        todayjianpaiLabel.text = String(format: "%.2f吨", deviceInfo.energy_day!.floatValue * 0.272 / 1000)
        totaljianpaiLabel.text = String(format: "%.2f吨", deviceInfo.energy_all!.floatValue * 0.272 / 1000)
        todayplantLabel.text = String(format: "%.2f棵", deviceInfo.energy_day!.floatValue * 0.272 / 100)
        totalplantLabel.text = String(format: "%.2f棵", deviceInfo.energy_all!.floatValue * 0.272 / 100)
    }
    
    
    //报修
    func reportPro() {
        let user = UserDefaultManager.getUser()
        if (user == nil) {
            return
        }
        if (user?.device_id == nil) {
            return
        }
        let vc = ReportViewController()
        vc.device_id = user!.device_id!
        self.pushViewController(vc)
    }
    
    func disConnectDevice() {
        
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
