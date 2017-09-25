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
    
    var fontOffSet: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "问题详情"
        if (PhoneUtils.kScreenWidth == 375) {
            fontOffSet = 0
        } else if (PhoneUtils.kScreenWidth == 320) {
            fontOffSet = -2
        } else {
            fontOffSet = 2
        }
        initView()
    }
    
    func initView() {
        let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight))
        self.view.addSubview(scrollView)
        
        let times = PhoneUtils.kScreenWidth / 375
        let offSetX: CGFloat = 5 * times
        let offSetY: CGFloat = 5 * times
        let iconWidth: CGFloat = 17 * times
        let iconHeight: CGFloat = 15 * times
        let bkgView = UIView.init(frame: CGRect(x: offSetX, y: offSetY, width: PhoneUtils.kScreenWidth - offSetX * 2, height: 0))
        bkgView.backgroundColor = UIColor.white
        scrollView.addSubview(bkgView)
        
        let width = bkgView.frame.size.width
        let questionLabelHeight = MSLFrameUtil.getLabHeight(questionInfo!.question, font: UIFont.systemFont(ofSize: 15 + fontOffSet), width: bkgView.frame.size.width - 2 * offSetX)
        let answerHeight = MSLFrameUtil.getLabHeight(questionInfo!.answer, font: UIFont.systemFont(ofSize: 15 + fontOffSet), width: bkgView.frame.size.width - offSetX * 3 - iconWidth)
        
        let questionLabel = UILabel.init(frame: CGRect(x: offSetX, y: 0, width: width - 2 * offSetX, height: questionLabelHeight))
        questionLabel.textAlignment = NSTextAlignment.left
        questionLabel.numberOfLines = 0;
        questionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        questionLabel.text = questionInfo!.question
        questionLabel.font = UIFont.systemFont(ofSize: 17 + fontOffSet)
        bkgView.addSubview(questionLabel)
        
        let askDateLabel = UILabel.init(frame: CGRect(x: offSetX, y: questionLabel.frame.maxY, width: width - offSetX, height: 20))
        let index = questionInfo!.created_date!.index(questionInfo!.created_date!.endIndex, offsetBy: -9)
        askDateLabel.text = "提问时间：\(questionInfo!.created_date!.substring(to: index))"
        askDateLabel.font = UIFont.systemFont(ofSize: 13 + fontOffSet)
        askDateLabel.textColor = UIColor.lightGray
        bkgView.addSubview(askDateLabel)
        
        let statusLabel = UILabel.init(frame: CGRect(x: offSetX, y: askDateLabel.frame.maxY + offSetY, width: 57 * times, height: 27 * times))
        statusLabel.text = questionInfo!.is_answered!.intValue == 1 ? "已解答" : "未解答"
        statusLabel.textAlignment = NSTextAlignment.center
        statusLabel.textColor = questionInfo!.is_answered!.intValue == 1 ? Colors.answerGreen : UIColor.red
        statusLabel.layer.cornerRadius = 6.0
        statusLabel.layer.masksToBounds = true
        statusLabel.layer.borderColor = statusLabel.textColor.cgColor
        statusLabel.layer.borderWidth = 0.5
        statusLabel.font = UIFont.systemFont(ofSize: 13 + fontOffSet)
        bkgView.addSubview(statusLabel)
        
        let line = UILabel.init(frame: CGRect(x: 0, y: statusLabel.frame.maxY + offSetY, width: bkgView.frame.size.width, height: 0.5))
        line.backgroundColor = Colors.bkgColor
        bkgView.addSubview(line)
        
        let imageIcon = UIImageView.init(frame: CGRect(x: (offSetX * 3 + iconWidth - iconWidth) / 2, y: line.frame.maxY + offSetY * 2.2, width: iconWidth, height: iconHeight))
        imageIcon.image = UIImage(named: "ic_gfask_repeat")
        bkgView.addSubview(imageIcon)
        
        let contentLabel = UILabel.init(frame: CGRect(x: iconWidth + offSetX * 3, y: line.frame.maxY + offSetY, width: width - offSetX * 3 - iconWidth, height: answerHeight))
        contentLabel.textAlignment = NSTextAlignment.left
        contentLabel.text = questionInfo!.answer
        contentLabel.textColor = UIColor.lightGray
        contentLabel.numberOfLines = 0;
        contentLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        contentLabel.font = UIFont.systemFont(ofSize: 15 + fontOffSet)
        bkgView.addSubview(contentLabel)
        
        bkgView.frame = CGRect(x: bkgView.frame.origin.x, y: bkgView.frame.origin.y, width: bkgView.frame.size.width, height: contentLabel.frame.maxY + offSetY)
        
        scrollView.contentSize = CGSize(width: 0, height: bkgView.frame.maxY + 5)
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
