//
//  GuangFuAskViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/14.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class GuangFuAskViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var anTableView: UITableView!
    var qaList = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        loadQuestionList()
    }
    
    func loadQuestionList() {
        API.sharedInstance.qaList(start: 0, pagesize: 10, isMy: false, success: { (count, array) in
            self.qaList.addObjects(from: array as! [Any])
            self.anTableView.reloadData()
        }) { (msg) in
            self.showHint(msg)
        }
    }
    
    func initView() {
        self.title = "光伏问答"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "提问", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.gotoAskQuestion))
    }
    
    func gotoAskQuestion() {
        if (shouldShowLogin() == true) {
            return
        }
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        self.pushViewController(sb.instantiateViewController(withIdentifier: "QuestionAddViewController"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return qaList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 1))
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GFAskCell") as! GFAskCell
        let qaInfo = qaList[indexPath.row] as! QuestionInfo
        cell.questionLabel.text = qaInfo.question
        cell.answerLabel.text = qaInfo.answer
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let info = qaList[indexPath.row] as! QuestionInfo
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "QuestionDetailViewController") as! QuestionDetailViewController
        vc.questionInfo = info
        self.pushViewController(vc)
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
