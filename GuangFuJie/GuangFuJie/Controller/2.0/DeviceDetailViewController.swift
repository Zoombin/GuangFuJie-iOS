//
//  DeviceDetailViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/10.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit
import Charts

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
    
    let topButtonHeight = PhoneUtils.kScreenHeight / 18
    
    //发电量
    var pnLineChart : LineChartView!
    var pnBarChart : BarChartView!
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
    
    func topButtonClicked(_ sender: UIButton) {
        currentIndex = sender.tag
        normalInfoButton.backgroundColor = Colors.topButtonColor
        lineButton.backgroundColor = Colors.topButtonColor
        barButton.backgroundColor = Colors.topButtonColor
        electricView.isHidden = true
        picView.isHidden = true
        if (pnBarChart != nil && pnLineChart != nil) {
            pnBarChart.isHidden = true
            pnLineChart.isHidden = true
        }
        
        if (sender.tag == 0) {
            normalInfoButton.backgroundColor = Colors.installColor
            electricView.isHidden = false
        } else if (sender.tag == 1) {
            lineButton.backgroundColor = Colors.installColor
            picView.isHidden = false
            loadPicData()
            if (pnLineChart != nil) {
                pnLineChart.isHidden = false
            }
        } else if (sender.tag == 2) {
            barButton.backgroundColor = Colors.installColor
            picView.isHidden = false
            loadPicData()
            if (pnBarChart != nil) {
                pnBarChart.isHidden = false
            }
        }
    }
    
    func initTopView() {
        let topView = UIView.init(frame: CGRect(x: 0, y: 64, width: PhoneUtils.kScreenWidth, height: topButtonHeight))
        topView.backgroundColor = UIColor.lightGray
        self.view.addSubview(topView)
        
        normalInfoButton = UIButton.init(type: UIButtonType.custom)
        normalInfoButton.setTitle("基本信息", for: UIControlState.normal)
        normalInfoButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        normalInfoButton.backgroundColor = Colors.installColor
        normalInfoButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        normalInfoButton.frame = CGRect(x: 0, y: 0, width: (PhoneUtils.kScreenWidth / 3) - 1, height: topButtonHeight)
        normalInfoButton.tag = 0
        topView.addSubview(normalInfoButton)
        
        lineButton = UIButton.init(type: UIButtonType.custom)
        lineButton.setTitle("曲线图", for: UIControlState.normal)
        lineButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        lineButton.backgroundColor = Colors.topButtonColor
        lineButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        lineButton.frame = CGRect(x: (PhoneUtils.kScreenWidth / 3) + 1, y: 0, width: (PhoneUtils.kScreenWidth / 3) - 1, height: topButtonHeight)
        lineButton.tag = 1
        topView.addSubview(lineButton)
        
        barButton = UIButton.init(type: UIButtonType.custom)
        barButton.setTitle("柱状图", for: UIControlState.normal)
        barButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        barButton.backgroundColor = Colors.topButtonColor
        barButton.addTarget(self, action: #selector(self.topButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        barButton.frame = CGRect(x: (PhoneUtils.kScreenWidth * 2 / 3) + 1 * 2, y: 0, width: (PhoneUtils.kScreenWidth / 3) - 1, height: topButtonHeight)
        barButton.tag = 2
        topView.addSubview(barButton)
    }
    
    func removeDeviceButtonClicked() {
        let alertView = UIAlertView.init(title: "提示", message: "是否解除绑定设备?", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertView.show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        self.showHud(in: self.view, hint: "解绑中...")
        if (alertView.cancelButtonIndex != buttonIndex) {
            API.sharedInstance.unBindDevice(device_id, success: { (commomModel) in
                    self.hideHud()
                    self.showHint("解绑成功!")
                    self.navigationController?.popViewController(animated: true)
                }, failure: { (msg) in
                    self.hideHud()
                    self.showHint(msg)
            })
        }
    }
    
    //MARK: 发电量
    func initElectricView() {
        electricView = UIView.init(frame: CGRect(x: 0, y: 64 + topButtonHeight, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - 64 - topButtonHeight))
        electricView.backgroundColor = Colors.bkgGray
        self.view.addSubview(electricView)
        
        let deviceBottomView = UIView.init(frame: CGRect(x: 0, y: electricView.frame.size.height - 50, width: PhoneUtils.kScreenWidth, height: 50))
        deviceBottomView.backgroundColor = UIColor.white
        electricView.addSubview(deviceBottomView)
        
        let removeButton = UIButton.init(type: UIButtonType.custom)
        removeButton.frame = CGRect(x: 5, y: 5, width: PhoneUtils.kScreenWidth - 5 * 2, height: deviceBottomView.frame.size.height - 5 * 2)
        removeButton.setTitle("解绑设备", for: UIControlState.normal)
        removeButton.backgroundColor = Colors.installColor
        removeButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        removeButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        removeButton.addTarget(self, action: #selector(self.removeDeviceButtonClicked), for: UIControlEvents.touchUpInside)
        deviceBottomView.addSubview(removeButton)
    
        let labelHeight = PhoneUtils.kScreenHeight / 12
        
        let topView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: labelHeight))
        topView.backgroundColor = UIColor.white
        electricView.addSubview(topView)
        
        //运行状态
        statusButton = UIButton.init(type: UIButtonType.custom)
        statusButton.frame = CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth * 1 / 2, height: labelHeight)
        statusButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        statusButton.setTitle("运行状态 正常", for: UIControlState.normal)
        statusButton.setTitle("运行状态 故障（点击报修）", for: UIControlState.selected)
        statusButton.setTitle("运行状态 离线", for: UIControlState.disabled)
        
        statusButton.setTitleColor(Colors.statusOK, for: UIControlState.normal)
        statusButton.setTitleColor(Colors.statusError, for: UIControlState.selected)
        statusButton.setTitleColor(Colors.statusOffLine, for: UIControlState.disabled)
        
        statusButton.setImage(UIImage(named: "ic_devstatus_ok"), for: UIControlState.normal)
        statusButton.setImage(UIImage(named: "ic_devstatus_error"), for: UIControlState.selected)
        statusButton.setImage(UIImage(named: "ic_devstatus_offline"), for: UIControlState.disabled)
        statusButton.isUserInteractionEnabled = false
        statusButton.addTarget(self, action: #selector(self.reportPro), for: UIControlEvents.touchUpInside)
        statusButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        statusButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        statusButton.backgroundColor = UIColor.white
        statusButton.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        topView.addSubview(statusButton)
        
        //sn
        snButton = UIButton.init(type: UIButtonType.custom)
        snButton.frame = CGRect(x: PhoneUtils.kScreenWidth * 1 / 2, y: 0, width: PhoneUtils.kScreenWidth * 1 / 2, height: labelHeight)
        snButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        snButton.setTitle(device_id, for: UIControlState.normal)
        snButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        snButton.setImage(UIImage(named: "ic_dev_sn"), for: UIControlState.normal)
        snButton.isUserInteractionEnabled = false
        snButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        snButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        snButton.backgroundColor = UIColor.white
        topView.addSubview(snButton)
        
        let buttonWidth = PhoneUtils.kScreenWidth / 4
        
        let titles = ["今日发电:", "累计发电:", "今日收益:", "累计收益:", "今日减排:", "累计减排:", "今日种植:", "累计种植:"]
        let icons = ["ic_h_powerday_single", "ic_h_allpower", "ic_h_dayincome", "ic_h_allincome", "ic_reduce", "ic_allreduce", "ic_grow_day", "ic_allgrow"]
        
        let labels = NSMutableArray()
        var line = 0
        var index = 0
        for i in 0..<icons.count {
            if (i != 0 && i%2 == 0) {
                line = line + 1
                index = 0
            }
            let view = UIView.init(frame: CGRect(x: CGFloat(index) * buttonWidth * 2, y: topView.frame.maxY + labelHeight * CGFloat(line), width: buttonWidth * 2, height: labelHeight))
            view.backgroundColor = UIColor.white
            view.layer.borderColor = Colors.bkgGray.cgColor
            view.layer.borderWidth = 0.5
            electricView.addSubview(view)
            
            //今日发电
            let titleButton = UIButton.init(type: UIButtonType.custom)
            titleButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: labelHeight)
            titleButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
            titleButton.setTitle(titles[i], for: UIControlState.normal)
            titleButton.setTitleColor(Colors.installColor, for: UIControlState.normal)
            titleButton.setImage(UIImage(named: icons[i]), for: UIControlState.normal)
            titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
            view.addSubview(titleButton)
            
            let label = UILabel.init(frame:CGRect(x: buttonWidth, y: 0, width: buttonWidth, height: labelHeight))
            label.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
            label.text = ""
            label.textColor = UIColor.black
            view.addSubview(label)
            
            labels.add(label)
            index = index + 1
        }
        
        todayElectricLabel = labels[0] as! UILabel
        totalElectricLabel = labels[1] as! UILabel
        todayMoneyLabel = labels[2] as! UILabel
        totalMoneyLabel = labels[3] as! UILabel
        todayjianpaiLabel = labels[4] as! UILabel
        totaljianpaiLabel = labels[5] as! UILabel
        todayplantLabel = labels[6] as! UILabel
        totalplantLabel = labels[7] as! UILabel
    }
    
    func loadPicData() {
        if (self.infoArray.count > 0) {
            return
        }
        self.showHud(in: self.view, hint: "加载中...")
        API.sharedInstance.getEnergyStatistic(device_id, year: "2016", success: { (powerGraphInfos) in
            self.hideHud()
            self.infoArray.addObjects(from: powerGraphInfos as [AnyObject])
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
            xLabels.add(String(describing: power.month!) + "月")
            yLabels.add(power.energy_month == nil ? NSNumber.init(value: 0) : power.energy_month!)
        }
        
        initLineChart(xLabels, yLabels: yLabels)
        initBarChart(xLabels, yLabels: yLabels)
    }
    
    func initLineChart(_ xLabels : NSArray, yLabels : NSArray) {
        if (xLabels.count != yLabels.count) {
            return
        }
        
        var entries: [ChartDataEntry] = Array()
        var xValues: [String] = Array()
        
        for i in 0..<yLabels.count {
            let xValue = xLabels[i] as! String
            let yValue = yLabels[i] as! NSNumber
            
            let data = ChartDataEntry.init(x: Double(i), y: yValue.doubleValue)
            entries.append(data)
            xValues.append(xValue)
        }
        
        let dataSet: LineChartDataSet = LineChartDataSet(values: entries, label: "2016年发电量走势(单位:kw)")
        
        let offSetY : CGFloat = 0
        
        pnLineChart = LineChartView(frame: CGRect(x: 0, y: offSetY, width: PhoneUtils.kScreenWidth, height: picView.frame.size.height - offSetY))
        pnLineChart.backgroundColor = NSUIColor.clear
        pnLineChart.leftAxis.axisMinimum = 0.0
        pnLineChart.rightAxis.axisMinimum = 0.0
        pnLineChart.data = LineChartData(dataSet: dataSet)
        picView.addSubview(pnLineChart)
        pnLineChart.isHidden = currentIndex != 1
        pnLineChart.chartDescription?.text = ""
    }
    
    func initBarChart(_ xLabels : NSArray, yLabels : NSArray) {
        var entries: [BarChartDataEntry] = Array()
        var xValues: [String] = Array()
        
        for i in 0..<yLabels.count {
            let xValue = xLabels[i] as! String
            let yValue = yLabels[i] as! NSNumber
            
            let data = BarChartDataEntry.init(x: Double(i), y: yValue.doubleValue)
            entries.append(data)
            xValues.append(xValue)
        }
        
        let dataSet: BarChartDataSet = BarChartDataSet(values: entries, label: "2016年发电量走势(单位:kw)")
        
        let offSetY : CGFloat = 0
        
        pnBarChart = BarChartView(frame: CGRect(x: 0, y: offSetY, width: PhoneUtils.kScreenWidth, height: picView.frame.size.height - offSetY))
        pnBarChart.backgroundColor = NSUIColor.clear
        pnBarChart.leftAxis.axisMinimum = 0.0
        pnBarChart.rightAxis.axisMinimum = 0.0
        pnBarChart.data = BarChartData(dataSet: dataSet)
        picView.addSubview(pnBarChart)
        pnBarChart.isHidden = currentIndex != 2
        pnBarChart.chartDescription?.text = ""
    }
    
    func initPicView() {
        picView = UIView.init(frame: CGRect(x: 0, y: 64 + topButtonHeight, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - 64 - topButtonHeight))
        picView.isHidden = true
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
    
    func loadDeviceInfo(_ deviceInfo : DeviceInfo) {
        if (deviceInfo.status?.int32Value == 1) {
            self.statusButton.isSelected = false
            self.statusButton.isEnabled = true
        } else if (deviceInfo.status?.int32Value == 2) {
            self.statusButton.isSelected = true
            self.statusButton.isEnabled = true
            statusButton.isUserInteractionEnabled = true
        } else if (deviceInfo.status?.int32Value == 3) {
            self.statusButton.isSelected = false
            self.statusButton.isEnabled = false
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
