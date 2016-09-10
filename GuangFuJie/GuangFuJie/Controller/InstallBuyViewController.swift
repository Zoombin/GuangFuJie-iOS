//
//  InstallBuyViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/10.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class InstallBuyViewController: UIViewController {

    var roofId : NSNumber!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安装商接单"
        // Do any additional setup after loading the view.
    }
    
    func loadRoofInfi() {
        API.sharedInstance.getRoofInfo(roofId, success: { (roofInfo) in
            
            }) { (msg) in
                
        }
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
