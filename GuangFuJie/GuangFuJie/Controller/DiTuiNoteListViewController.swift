//
//  DiTuiNoteListViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/15.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class DiTuiNoteListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var noteListTableView: UITableView!
    let cellIdentifier = "NoteCell"
    var noteList = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        self.title = "推广笔记"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "添加笔记", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addNote))
        
        noteListTableView = UITableView.init(frame: CGRect(x: 0, y: self.navigationBarAndStatusBarHeight(), width: YCPhoneUtils.screenWidth, height: YCPhoneUtils.screenHeight - self.navigationBarAndStatusBarHeight()))
        noteListTableView.delegate = self
        noteListTableView.dataSource = self
        noteListTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(noteListTableView)
        
        noteListTableView.register(NoteCell.self, forCellReuseIdentifier: cellIdentifier)
        loadNoteList()
    }
    
    func loadNoteList() {
        self.showHud(in: self.view, hint: "加载中...")
        API.sharedInstance.noteList(0, pagesize: 20, success: { (count, array) in
            self.hideHud()
            if (array.count > 0) {
                self.noteList.addObjects(from: array as! [Any])
            }
            self.noteListTableView.reloadData()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    func addNote() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        self.pushViewController(sb.instantiateViewController(withIdentifier: "AddNoteViewController"))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NoteCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NoteCell
        let noteInfo = noteList[indexPath.row] as! NoteInfo
        cell.setData(note: noteInfo)
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
