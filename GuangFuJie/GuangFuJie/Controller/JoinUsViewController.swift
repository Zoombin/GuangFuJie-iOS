//
//  JoinUsViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/11.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit
//加盟商页面
class JoinUsViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "加盟商"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: 0, height: 780)
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
