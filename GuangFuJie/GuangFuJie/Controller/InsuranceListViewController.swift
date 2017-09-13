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
    var infoArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "购买保险列表"
        // Do any additional setup after loading the view.
        loadData()
    }
    
    func loadData() {
        API.sharedInstance.usersHaveInsuranceList(0, pagesize: 10, success: { (array) in
            self.infoArray.addObjects(from: array as! [Any])
            self.inTableView.reloadData()
        }) { (msg) in
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InsuranceCell") as! InsuranceCell
        let info = infoArray[indexPath.row] as! InsuranceInfo
        cell.setData(info, isSelf: false)
        return cell
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
