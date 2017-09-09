//
//  QuestionAddViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/9/9.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class QuestionAddViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        let questionBottomView = UIView.init(frame: CGRect(x: 0, y: self.view.frame.size.height - 50, width: PhoneUtils.kScreenWidth, height: 50))
        questionBottomView.backgroundColor = UIColor.white
        self.view.addSubview(questionBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = questionBottomView.frame.size.height - 5 * 2
        
        let addButton = GFJBottomButton.init(type: UIButtonType.custom)
        addButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        addButton.setTitle("发表提问", for: UIControlState.normal)
        addButton.backgroundColor = Colors.appBlue
        addButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        addButton.addTarget(self, action: #selector(self.addQuestionButtonClicked), for: UIControlEvents.touchUpInside)
        questionBottomView.addSubview(addButton)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "我的提问", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.showMyQuestions))
    }
    
    func showMyQuestions() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        self.pushViewController(sb.instantiateViewController(withIdentifier: "MyQuestionListViewController"))
    }
    
    func addQuestionButtonClicked() {
        self.showHint("提交成功")
        self.navigationController?.popViewController(animated: true)
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
