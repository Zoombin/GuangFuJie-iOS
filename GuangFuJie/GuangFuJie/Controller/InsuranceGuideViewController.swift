//
//  InsuranceGuideViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/11/10.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class InsuranceGuideViewController: BaseViewController {
    let images = ["ic_intro_01", "ic_intro_02", "ic_intro_03", "ic_intro_04", "ic_intro_05", "ic_intro_06", "ic_intro_07", "ic_intro_08", "ic_intro_09"]
    let heights = [1035, 314, 590, 1756, 734, 458, 826, 898, 1037]
    var scrollView: UIScrollView!
    let times = YCPhoneUtils.screenWidth / 375
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "光伏保险"
        initView()
    }
    
    func initView() {
        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: self.navigationBarAndStatusBarHeight(), width: YCPhoneUtils.screenWidth, height: YCPhoneUtils.screenHeight - self.navigationBarAndStatusBarHeight()))
        self.view.addSubview(scrollView)
        
        var currentY: CGFloat = 0
        for i in 0..<images.count {
            let imageView = UIImageView.init(frame: CGRect(x: 0, y: currentY, width: YCPhoneUtils.screenWidth, height: (CGFloat(heights[i]) * times / 2)))
            imageView.image = UIImage(named: images[i])
            scrollView.addSubview(imageView)
            currentY = imageView.frame.maxY
        }
        scrollView.contentSize = CGSize(width: 0, height: currentY)
        
        let buyBottomView = UIView.init(frame: CGRect(x: 0, y: PhoneUtils.kScreenHeight - 50, width: PhoneUtils.kScreenWidth, height: 50))
        buyBottomView.backgroundColor = UIColor.white
        self.view.addSubview(buyBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = buyBottomView.frame.size.height - 5 * 2
        
        let calButton = GFJBottomButton.init(type: UIButtonType.custom)
        calButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        calButton.setTitle("购买保险", for: UIControlState.normal)
        calButton.backgroundColor = Colors.appBlue
        calButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        calButton.titleLabel?.font = UIFont.systemFont(ofSize: FontUtils.getFontSize(size: 17))
        calButton.addTarget(self, action: #selector(self.buyNow), for: UIControlEvents.touchUpInside)
        buyBottomView.addSubview(calButton)
    }
    
    func buyNow() {
        let vc = BuySafeViewController()
        self.pushViewController(vc)
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
