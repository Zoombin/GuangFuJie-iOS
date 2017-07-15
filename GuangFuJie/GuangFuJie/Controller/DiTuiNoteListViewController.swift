//
//  DiTuiNoteListViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/15.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class DiTuiNoteListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
     @IBOutlet weak var noteListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        self.title = "地推笔记"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "+", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addNote))
    }
    
    func addNote() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        self.pushViewController(sb.instantiateViewController(withIdentifier: "AddNoteViewController"))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 1))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NoteCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NoteCell
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
