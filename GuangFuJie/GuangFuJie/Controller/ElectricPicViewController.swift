//
//  ElectricPicViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/6.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class ElectricPicViewController: BaseViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发电走势图"
        // Do any additional setup after loading the view.
        initView()
    }
    
    func initView() {
        let topView = UIView.init(frame: CGRectMake(0, 64, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight * 0.05))
        self.view.addSubview(topView)
        
       let segmentedControl = UISegmentedControl.init(frame: CGRectMake(0, 0, topView.frame.size.width, topView.frame.size.height))
        segmentedControl.insertSegmentWithTitle("曲线图", atIndex: 0, animated: false)
        segmentedControl.insertSegmentWithTitle("柱状图", atIndex: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        topView.addSubview(segmentedControl)
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
