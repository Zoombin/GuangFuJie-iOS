//
//  PhotoViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/20.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class PhotoViewController: BaseViewController {
    var type = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight))
        self.view.addSubview(scrollView)
        
        let imageView = UIImageView.init(frame : CGRect(x: 0,y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight))
        if (type == 1) {
            let width = PhoneUtils.kScreenWidth
            let height = (7758 * width) / 640
            self.title = "保险条款"
            imageView.frame = CGRect(x: 0,y: 0, width: width, height: height)
            imageView.image = UIImage(named: "ic_insurance_terms")
        } else if (type == 2) {
            self.title = "电子保单范本"
            let width = PhoneUtils.kScreenWidth
            let height = (1050 * width) / 640
            imageView.frame = CGRect(x: 0,y: 0, width: width, height: height)
            imageView.image = UIImage(named: "ic_elec_ex")
        } else {
            self.title = "纸质保单范本"
            let width = PhoneUtils.kScreenWidth
            let height = (853 * width) / 640
            imageView.frame = CGRect(x: 0,y: 0, width: width, height: height)
            imageView.image = UIImage(named: "ic_paper_ex")
        }
        scrollView.addSubview(imageView)
        scrollView.contentSize = CGSize(width: 0, height: imageView.frame.size.height)
        // Do any additional setup after loading the view.
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
