//
//  RootProjectCalV2ViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/10/19.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootProjectCalV2ViewController: BaseViewController {
//    static let calUnSelectColor : UIColor = UIColor.white
//    static let calSelectedColor : UIColor = UIColor.init(hexString: "F1F1F1")
//    static let calUnSelectTextColor : UIColor = UIColor.black
//    static let calSelectedTextColor : UIColor = UIColor.init(hexString: "2483CB")
    let times = PhoneUtils.kScreenWidth / 375
    var leftButton1: UIButton!
    var leftButton2: UIButton!
    var leftButton3: UIButton!
    var leftButton4: UIButton!
    
    var rightContentView: UIView!
    
    let leftBtnTitles = ["日照计算", "产能计算", "收益分析", "现金流向"]
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initLeftButtons() {
        let btnWidth = 56 * times
        let btnHeight = PhoneUtils.kScreenHeight / 4
        
        for i in 0..<leftBtnTitles.count {
            let button = UIButton.init(type: UIButtonType.custom)
            button.backgroundColor = UIColor.lightGray
            button.frame = CGRect(x: 0, y: CGFloat(i) * btnHeight, width: btnWidth, height: btnHeight)
            self.view.addSubview(button)
            
//            if (i == 0)
        }
//        leftButton1 = UIButton.init(type: UIButtonType.custom)
//        leftButton1.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//        leftButton1.backgroundColor = UIColor.lightGray
//        self.view.addSubview(leftButton1)
//
//        leftButton2 = UIButton.init(type: UIButtonType.custom)
//        leftButton2.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//        leftButton2.backgroundColor = UIColor.lightGray
//        self.view.addSubview(leftButton2)
//
//        leftButton3 = UIButton.init(type: UIButtonType.custom)
//        leftButton3.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//        leftButton3.backgroundColor = UIColor.lightGray
//        self.view.addSubview(leftButton3)
//
//        leftButton4 = UIButton.init(type: UIButtonType.custom)
//        leftButton4.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//        leftButton4.backgroundColor = UIColor.lightGray
//        self.view.addSubview(leftButton4)
    }
    
    func initView() {
        initLeftButtons()
        
        rightContentView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
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
