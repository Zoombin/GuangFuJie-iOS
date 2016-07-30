//
//  BaseViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/7/30.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.bkgColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushViewController(to : UIViewController) {
        to.hidesBottomBarWhenPushed = true
        let image = UIImage(named: "ic_back")
        to.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.backButtonClicked))
        //注意: 加了这一句，自定义的返回按钮也可以用滑动返回了...
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.pushViewController(to, animated: true)
    }
    
    func backButtonClicked() {
        self.navigationController?.popViewControllerAnimated(true)
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
