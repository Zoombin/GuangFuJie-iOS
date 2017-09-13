//
//  QuestionDetailViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/9/13.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class QuestionDetailViewController: BaseViewController {
    var questionInfo: QuestionInfo?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "问题详情"
        initView()
        loadData()
    }
    
    func loadData() {
        if (questionInfo != nil) {
            titleLabel.text = questionInfo!.question
            createTimeLabel.text = "提问时间：\(questionInfo!.created_date!)"
            answerLabel.text = questionInfo!.answer
            updateLabel.text = "解答时间：\(questionInfo!.update_date!)"
        }
    }
    
    func initView() {
        statusLabel.layer.cornerRadius = 6.0
        statusLabel.layer.masksToBounds = true
        statusLabel.layer.borderColor = statusLabel.textColor.cgColor
        statusLabel.layer.borderWidth = 0.5
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
