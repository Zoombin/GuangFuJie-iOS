//
//  DiTuiHomeViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/14.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class DiTuiHomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "地推"
        // Do any additional setup after loading the view.
        initNoteButton()
    }
    
    func initNoteButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "地推笔记", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.noteListButtonClicked))
    }
    
    func noteListButtonClicked() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        self.pushViewController(sb.instantiateViewController(withIdentifier: "DiTuiNoteListViewController"))
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
