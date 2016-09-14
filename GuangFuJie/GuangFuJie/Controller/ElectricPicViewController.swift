//
//  ElectricPicViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/6.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class ElectricPicViewController: BaseViewController {
    var infoArray = NSMutableArray()
    var topView : UIView!
    var pnLineChart : PNLineChart!
    var pnBarChart : PNBarChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发电量走势图"
        // Do any additional setup after loading the view.
        initView()
        loadData()
    }
    
    func loadData() {
        let user = UserDefaultManager.getUser()
        let device_id = user!.device_id!
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
            yLabels.addObject(String(power.energy_month!))
        }
        
        if (xLabels.count == 0 || xLabels == 1) {
            self.showHint("暂无数据!")
            return
        }
        
        pnLineChart = ChartUtils.addLineChartsWidthFrame(xLabels, yDates: yLabels, andFrame: CGRectMake(0, CGRectGetMaxY(topView.frame), PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - 64 - topView.frame.size.height))
        self.view.addSubview(pnLineChart)
        pnLineChart.strokeChart()
        
        pnBarChart = ChartUtils.addBarChartsWidthFrame(xLabels, yDates: yLabels, andFrame: CGRectMake(0, CGRectGetMaxY(topView.frame), PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight - 64 - topView.frame.size.height))
        self.view.addSubview(pnBarChart)
        pnBarChart.strokeChart()
        pnBarChart.hidden = true
    }
    
    func initView() {
        topView = UIView.init(frame: CGRectMake(0, 64, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight * 0.05))
        self.view.addSubview(topView)
        
       let segmentedControl = UISegmentedControl.init(frame: CGRectMake(0, 0, topView.frame.size.width, topView.frame.size.height))
        segmentedControl.insertSegmentWithTitle("曲线图", atIndex: 0, animated: false)
        segmentedControl.insertSegmentWithTitle("柱状图", atIndex: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(self.valueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        topView.addSubview(segmentedControl)
    }
    
    func valueChanged(segmentedControl : UISegmentedControl) {
        pnLineChart.hidden = segmentedControl.selectedSegmentIndex != 0
        pnBarChart.hidden = segmentedControl.selectedSegmentIndex == 0
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
