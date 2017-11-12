//
//  GFQuestionHomeViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/11/10.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class GFQuestionHomeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    let times = YCPhoneUtils.screenWidth / 375
    var hotSearchLabel: UILabel!
    let hotWords = ["热门问题", "如何安装", "如何保养", "投资回报", "国家政策", "拆迁补偿", "光伏养老"]
    var hotWordsBtn = NSMutableArray()
    var hotWordsScrollView: UIScrollView!
    var cellReuseIdentifier = "cellReuseIdentifier"
    var questionTableView: UITableView!
    var questionArray = NSMutableArray()
    var typeId = "1"
    var searchTextField: UITextField!
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        addHotWords()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "提问", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.askButtonClicked))
        loadData()
    }
    
    func loadQuestionList() {
        API.sharedInstance.qaList(start: currentPage, pagesize: 10, isMy: false, type: typeId, success: { (count, array) in
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
    
    //提问
    func askButtonClicked() {
        if (shouldShowLogin() == true) {
            return
        }
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        self.pushViewController(sb.instantiateViewController(withIdentifier: "QuestionAddViewController"))
    }
    
    func hotButtonClicked(sender: UIButton) {
        for i in 0..<hotWordsBtn.count {
            let button = hotWordsBtn[i] as! UIButton
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.layer.borderColor = UIColor.clear.cgColor
            button.layer.borderWidth = 1
        }
        sender.setTitleColor(UIColor.red, for: UIControlState.normal)
        sender.layer.borderColor = UIColor.red.cgColor
        sender.layer.borderWidth = 1
        
        typeId = "\(sender.tag + 1)"
        loadData()
    }
    
    func addHotWords() {
        let btnWidth = 70 * times
        let btnHeight = 30 * times
        let offSetX = 5 * times
        for i in 0..<hotWords.count {
            let button = UIButton.init(frame: CGRect(x: offSetX * CGFloat(i + 1) + btnWidth * CGFloat(i), y: (hotWordsScrollView.frame.size.height - btnHeight) / 2, width: btnWidth, height: btnHeight))
            button.setTitleColor(i == 0 ? UIColor.red : UIColor.black, for: UIControlState.normal)
            button.layer.borderColor = i == 0 ? UIColor.red.cgColor : UIColor.clear.cgColor
            button.layer.borderWidth = 1
            button.tag = i
            button.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 13))
            button.setTitle(hotWords[i], for: UIControlState.normal)
            button.addTarget(self, action: #selector(self.hotButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
            hotWordsScrollView.addSubview(button)
            
            hotWordsBtn.add(button)
        }
        hotWordsScrollView.contentSize = CGSize(width: btnWidth * CGFloat(hotWords.count) + offSetX * CGFloat(hotWords.count), height: 0)
    }
    
    func initView() {
        self.title = "光伏问答"
        self.view.backgroundColor = UIColor.white
        
        searchTextField = UITextField.init(frame: CGRect(x: 10 * times, y: 10 * times + self.navigationBarAndStatusBarHeight(), width: 290 * times, height: 35 * times))
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
        
        hotWordsScrollView = UIScrollView.init(frame: CGRect(x: 0, y: searchTextField.frame.maxY + 3 * times, width: YCPhoneUtils.screenWidth, height: 45 * times))
        self.view.addSubview(hotWordsScrollView)
        
        let leftTitleLabel = UILabel.init(frame: CGRect(x: 0, y: hotWordsScrollView.frame.maxY + 5 * times, width: 160 * times, height: 30 * times))
        leftTitleLabel.text = "  最新光伏问题解答"
        leftTitleLabel.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        addLeftLine(view: leftTitleLabel)
        self.view.addSubview(leftTitleLabel)
        
        let moreButton = UIButton.init(type: UIButtonType.custom)
        moreButton.frame = CGRect(x: YCPhoneUtils.screenWidth - 105 * times, y: leftTitleLabel.frame.minY, width: 105 * times, height: 30 * times)
        moreButton.setTitle("查看更多>", for: UIControlState.normal)
        moreButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
        moreButton.setTitleColor(Colors.appBlue, for: UIControlState.normal)
        moreButton.addTarget(self, action: #selector(self.moreButtonClicked), for: UIControlEvents.touchUpInside)
        self.view.addSubview(moreButton)
        
        questionTableView = UITableView.init(frame: CGRect(x: 0, y: moreButton.frame.maxY + 5 * times, width: YCPhoneUtils.screenWidth, height: YCPhoneUtils.screenHeight - moreButton.frame.maxY - 5 * times))
        questionTableView.delegate = self
        questionTableView.dataSource = self
        questionTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(questionTableView)
        YCLineUtils.addTopLine(questionTableView, color: UIColor.lightGray, percent: 100)
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
    
    func moreButtonClicked() {
        let vc = QestionAllViewController()
        self.pushViewController(vc)
    }
    
    func addLeftLine(view: UIView) {
        let leftBorder = CALayer()
        let height = view.frame.size.height
        let width = 3 * times
        leftBorder.frame = CGRect(x: 0, y: height * 0.1, width: width, height: height * 0.8);
        leftBorder.backgroundColor = UIColor.red.cgColor
        view.layer.addSublayer(leftBorder)
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
    
    func searchButtonClicked() {
        if (searchTextField.text!.isEmpty) {
            self.showHint("请输入搜索内容")
            return
        }
        searchTextField.resignFirstResponder()
        let vc = QuestionSearchViewController()
        vc.key = searchTextField.text!
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
