//
//  RootProjectCalViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/14.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootProjectCalViewController: BaseViewController {
    @IBOutlet weak var bkgXZView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "项目测算"
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bkgXZView.layer.shadowColor = UIColor.lightGray.cgColor
        bkgXZView.layer.shadowRadius = 5.0
        bkgXZView.layer.shadowOpacity = 0.8
        bkgXZView.layer.shadowOffset = CGSize(width: -5, height: 0)
        self.navigationController?.tabBarItem.selectedImage = self.tabBarItem.selectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
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
