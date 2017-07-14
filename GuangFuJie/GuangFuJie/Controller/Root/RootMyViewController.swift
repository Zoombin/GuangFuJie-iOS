//
//  RootMyViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/6.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootMyViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.tabBarItem.selectedImage = self.tabBarItem.selectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell_\(indexPath.row + 1)")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.row == 0) {
            //分享光伏街
            shareApp()
        } else if (indexPath.row == 1) {
            //技术支持
        } else if (indexPath.row == 2) {
            //关于我们
        } else if (indexPath.row == 3) {
            //联系我们
        } else if (indexPath.row == 4) {
            //设置
        }
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
