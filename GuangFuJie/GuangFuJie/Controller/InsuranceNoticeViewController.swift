//
//  InsuranceNoticeViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/8/12.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class InsuranceNoticeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "保险说明"
        let width = PhoneUtils.kScreenWidth
        let height = (813 * width) / 716
        let imageView = UIImageView.init(frame: CGRectMake(0, 64, width, height))
        imageView.image = UIImage(named: "ic_insureinfo")
        self.view.addSubview(imageView)
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
