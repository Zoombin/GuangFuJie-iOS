//
//  GuideViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/15.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight))
        scrollView.contentSize = CGSize(width: PhoneUtils.kScreenWidth * 4, height: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        let imgs = ["guide_01", "guide_02", "guide_03", "guide_04"]
        for i in 0..<imgs.count {
            let imageView = UIImageView.init(frame: CGRect(x: CGFloat(i) * PhoneUtils.kScreenWidth, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight))
            imageView.image = UIImage(named: imgs[i])
            scrollView.addSubview(imageView)

            let tapGestrue = UITapGestureRecognizer.init(target: self, action: #selector(self.goToMain))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestrue)
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
