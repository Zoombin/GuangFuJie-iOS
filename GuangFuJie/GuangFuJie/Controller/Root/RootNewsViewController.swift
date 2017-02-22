//
//  RootNewsViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/2/22.
//  Copyright © 2017年 颜超. All rights reserved.
//

import UIKit

class RootNewsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Texts.tab5
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        initRightNavButton()
        initLeftNavButton()
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
