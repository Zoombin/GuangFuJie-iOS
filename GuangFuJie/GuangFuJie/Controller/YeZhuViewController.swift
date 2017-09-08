//
//  YeZhuViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/14.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class YeZhuViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "业主"
        initView()
    }
    
    func initView() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "业主列表", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.showYeZhuList))
    }
    
    func showYeZhuList() {
        let vc = GFJRoofListViewController(nibName: "GFJRoofListViewController", bundle: nil)
        self.pushViewController(vc)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(button : UIButton) {
        let title = button.titleLabel?.text
        self.goToPageByTitle(title: title!)
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
