//
//  InstallViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/7/30.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class InstallViewController: UIViewController {

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var installCityTextField: UITextField!
    @IBOutlet weak var roomTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我要安装"
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
