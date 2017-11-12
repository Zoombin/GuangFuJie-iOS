//
//  QuestionSearchViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/11/12.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class QuestionSearchViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var cellReuseIdentifier = "cellReuseIdentifier"
    var questionTableView: UITableView!
    var questionArray = NSMutableArray()
    var key = ""
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "搜索结果"
        initView()
        loadData()
    }
    
    func loadQuestionList() {
        API.sharedInstance.qaList(start: currentPage, pagesize: 10, isMy: false, key: key, success: { (count, array) in
            if (self.currentPage == 0) {
                self.hideHud()
                self.questionArray.removeAllObjects()
            } else {
                self.questionTableView.mj_footer.endRefreshing()
            }
            if (array.count > 0) {
                self.questionArray.addObjects(from: array as [AnyObject])
            }
            if (array.count < 10) {
                self.questionTableView.mj_footer.isHidden = true
            }
            self.questionTableView.reloadData()
        }) { (msg) in
            self.questionTableView.mj_footer.endRefreshing()
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    func initView() {
        questionTableView = UITableView.init(frame: CGRect(x: 0, y: self.navigationBarAndStatusBarHeight(), width: YCPhoneUtils.screenWidth, height: YCPhoneUtils.screenHeight - self.navigationBarAndStatusBarHeight()))
        questionTableView.delegate = self
        questionTableView.dataSource = self
        questionTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(questionTableView)
        questionTableView.register(QuestionCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        questionTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMore))
    }
    
    func loadMore() {
        currentPage = currentPage + 1
        loadQuestionList()
    }
    
    func loadData() {
        currentPage = 0
        self.questionTableView.mj_footer.isHidden = false
        self.showHud(in: self.view, hint: "加载中...")
        loadQuestionList()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return QuestionCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.questionArray.object(at: indexPath.row) as! QuestionInfo
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! QuestionCell
        cell.setData(questionInfo: data)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = self.questionArray.object(at: indexPath.row) as! QuestionInfo
        let vc = QuestionDetailViewController()
        vc.questionInfo = data
        self.pushViewController(vc)
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
