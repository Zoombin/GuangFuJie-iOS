//
//  InsuranceListViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/11.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class InsuranceListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var inTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "购买保险列表"
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InsuranceCell")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
