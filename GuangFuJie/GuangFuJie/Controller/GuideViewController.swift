//
//  GuideViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/15.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class GuideViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight))
        scrollView.contentSize = CGSize(width: PhoneUtils.kScreenWidth * 3, height: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        
//        let tapGestrue = UITapGestureRecognizer.init(target: self, action: #selector(self.goToMain))
//        scrollView.addGestureRecognizer(tapGestrue)
        
        let orignWidth: CGFloat = 292 / 2
        let orignHeight: CGFloat = 87 / 2
        let orignSkipWidth: CGFloat = 107 / 2
        let orignSkipHeight: CGFloat = 57 / 2
        var times = PhoneUtils.kScreenWidth / 375
       
        var btnWidth = orignWidth * times
        var btnHeight = orignHeight * times
        var skipWidth = orignSkipWidth * times
        var skipHeight = orignSkipHeight * times
        
        let leftOrignStartX: CGFloat = 37 / 2
        let leftOrignStartY: CGFloat = 1100 / 2
        let rightOrginStartX: CGFloat = 420 / 2
        let skipOrignStartX: CGFloat = 595 / 2
        let skipOrignStartY: CGFloat = 41 / 2
        
        var leftStartX = leftOrignStartX * times
        var leftStartY = leftOrignStartY * times
        var rightStartX = rightOrginStartX * times
        var skipStartX = skipOrignStartX * times
        var skipStartY = skipOrignStartY * times
        
        //TODO:由于iPhone4的尺寸比例不对，所以只能这样特殊处理了，哎。。。
        if (PhoneUtils.kScreenHeight < 568) {
            btnWidth = 248 / 2
            btnHeight = 64 / 2
            skipWidth = 97 / 2
            skipHeight = 41 / 2
            
            leftStartX = 33 / 2
            leftStartY = 786 / 2
            rightStartX = 360 / 2
            skipStartX = 504 / 2
            skipStartY = 28 / 2
        }
        
        let imgs = ["guide_01", "guide_02", "guide_03"]
        for i in 0..<imgs.count {
            let imageView = UIImageView.init(frame: CGRect(x: CGFloat(i) * PhoneUtils.kScreenWidth, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight))
            imageView.image = UIImage(named: imgs[i])
            scrollView.addSubview(imageView)
            
            let skipBtn = UIButton.init(type: UIButtonType.custom)
            skipBtn.backgroundColor = UIColor.clear
            skipBtn.frame = CGRect(x: skipStartX + CGFloat(i) * PhoneUtils.kScreenWidth, y: skipStartY, width: skipWidth, height: skipHeight)
            skipBtn.addTarget(self, action: #selector(self.goToMain), for: UIControlEvents.touchUpInside)
            scrollView.addSubview(skipBtn)
            
            let leftBtn = UIButton.init(type: UIButtonType.custom)
            leftBtn.backgroundColor = UIColor.clear
            leftBtn.frame = CGRect(x: leftStartX + CGFloat(i) * PhoneUtils.kScreenWidth, y: leftStartY, width: btnWidth, height: btnHeight)
            leftBtn.addTarget(self, action: #selector(self.goToMain), for: UIControlEvents.touchUpInside)
            scrollView.addSubview(leftBtn)
            
            let rightBtn = UIButton.init(type: UIButtonType.custom)
            rightBtn.backgroundColor = UIColor.clear
            rightBtn.frame = CGRect(x: rightStartX + CGFloat(i) * PhoneUtils.kScreenWidth, y: leftStartY, width: btnWidth, height: btnHeight)
            rightBtn.addTarget(self, action: #selector(self.goToMain), for: UIControlEvents.touchUpInside)
            scrollView.addSubview(rightBtn)
        }
    }
    
    func goToMain() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.initMain()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
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
