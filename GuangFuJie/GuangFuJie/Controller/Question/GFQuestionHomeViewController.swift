//
//  GFQuestionHomeViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/11/10.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class GFQuestionHomeViewController: BaseViewController {
    let times = YCPhoneUtils.screenWidth / 375
    var hotSearchLabel: UILabel!
    let hotWords = ["热门问题", "如何安装", "如何保养", "投资回报", "国家政策", "拆迁补偿", "光伏养老"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "提问", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.askButtonClicked))
    }
    
    //提问
    func askButtonClicked() {
        if (shouldShowLogin() == true) {
            return
        }
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        self.pushViewController(sb.instantiateViewController(withIdentifier: "QuestionAddViewController"))
    }
    
    func initView() {
        self.title = "光伏问答"
        self.view.backgroundColor = UIColor.white
        
        let searchTextField = UITextField.init(frame: CGRect(x: 10 * times, y: 10 * times + self.navigationBarAndStatusBarHeight(), width: 290 * times, height: 35 * times))
        searchTextField.backgroundColor = Colors.bkgColor
        searchTextField.layer.cornerRadius = searchTextField.frame.size.height / 2
        searchTextField.layer.masksToBounds = true
        searchTextField.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        searchTextField.placeholder = "搜索关键词"
        searchTextField.leftViewMode = UITextFieldViewMode.always
        searchTextField.tintColor = UIColor.clear
        searchTextField.returnKeyType = UIReturnKeyType.search
        self.view.addSubview(searchTextField)
        
        let leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 35 * times, height: 35 * times))
        
        let leftIconImage = UIImageView.init(frame: CGRect(x: 10 * times, y: 7.5 * times, width: 20 * times, height: 20 * times))
        leftIconImage.image = UIImage(named: "ic_home_search")
        leftView.addSubview(leftIconImage)
        
        searchTextField.leftView = leftView
        
        let searchButton = UIButton.init(type: .custom)
        searchButton.frame = CGRect(x: searchTextField.frame.maxX + 10 * times, y: searchTextField.frame.minY, width: 55 * times, height: 35 * times)
        searchButton.setTitle("搜索", for: UIControlState.normal)
        searchButton.backgroundColor = Colors.appBlue
        searchButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        searchButton.addTarget(self, action: #selector(self.searchButtonClicked), for: UIControlEvents.touchUpInside)
        self.view.addSubview(searchButton)
    }
    
    func searchButtonClicked() {
        self.showHint("提示")
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
