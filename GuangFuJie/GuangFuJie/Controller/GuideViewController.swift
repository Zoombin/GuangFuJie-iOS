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
        self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view.
        let scrollView = UIScrollView.init(frame: CGRectMake(0, 0, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight))
        scrollView.contentSize = CGSizeMake(PhoneUtils.kScreenWidth * 3, 0)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        let tapGestrue = UITapGestureRecognizer.init(target: self, action: #selector(self.goToMain))
        scrollView.addGestureRecognizer(tapGestrue)
        
        let imgs = ["guide_01", "guide_02", "guide_03"]
        for i in 0..<imgs.count {
            let imageView = UIImageView.init(frame: CGRectMake(CGFloat(i) * PhoneUtils.kScreenWidth, 0, PhoneUtils.kScreenWidth, PhoneUtils.kScreenHeight))
            imageView.image = UIImage(named: imgs[i])
            scrollView.addSubview(imageView)
        }
    }
    
    func goToMain() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.initMain()
    }
    
    override func prefersStatusBarHidden() -> Bool {
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
