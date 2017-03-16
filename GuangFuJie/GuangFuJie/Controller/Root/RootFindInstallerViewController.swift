//
//  RootFindInstallerViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/3/14.
//  Copyright © 2017年 颜超. All rights reserved.
//

import UIKit

class RootFindInstallerViewController: BaseViewController, UITextFieldDelegate {
    var dir = 10 * (PhoneUtils.kScreenWidth / 750)
    var times = PhoneUtils.kScreenWidth / 750
    
    var scrollView = UIScrollView()
    var searchView = UIView()
    var hotWordsView = UIView()
    var menuView = UIView()
    
    var searchTextField = UITextField()
    
    var hotwords = ["光伏", "太阳能", "新能源科技", "光电", "电气", "能源", "节能环保"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Texts.tab2
        
        //TODO: 这句话挺重要
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        initView()
    }
    
    func initView() {
        initRightNavButton()
        initLeftNavButton()
        initLoginView()
        
        scrollView.frame = CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - 50 - 64)
        scrollView.backgroundColor = UIColor.clear
        self.view.addSubview(scrollView)
        
        initSearchView()
        initHotWordsView()
        initMenuView()
        
        let viewMoreButton = UIButton.init(frame: CGRect(x: PhoneUtils.kScreenWidth * 0.1, y: menuView.frame.maxY + dir * 3, width: PhoneUtils.kScreenWidth * 0.8, height: 70 * times))
        viewMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        viewMoreButton.addTarget(self, action: #selector(self.viewMoreButtonClicked), for: UIControlEvents.touchUpInside)
        viewMoreButton.backgroundColor = Colors.installColor
        viewMoreButton.setTitle("查看全部认证安装商", for: UIControlState.normal)
        scrollView.addSubview(viewMoreButton)
    }
    
    func initSearchView() {
        searchView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 80 * times))
        searchView.backgroundColor = UIColor.white
        scrollView.addSubview(searchView)
        
        let searchLeft = UIButton.init(frame: CGRect(x: 0, y: 0, width: (80 * times) * 0.8, height: (80 * times) * 0.8))
        searchLeft.setImage(UIImage(named: "ic_installer_search"), for: UIControlState.normal)
        
        searchTextField.frame = CGRect(x: dir * 4, y: (80 * times) * 0.1, width: (PhoneUtils.kScreenWidth - 6 * dir) - (80 * times) * 1.3, height: (80 * times) * 0.8)
        searchTextField.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        searchTextField.leftView = searchLeft
        searchTextField.leftViewMode = UITextFieldViewMode.always
        searchTextField.backgroundColor = UIColor.white
        searchTextField.returnKeyType = UIReturnKeyType.search
        searchTextField.delegate = self
        searchTextField.placeholder = "请输入安装商企业名称"
        searchTextField.clearButtonMode = UITextFieldViewMode.whileEditing
        searchView.addSubview(searchTextField)
        
        let searchRight = UIButton.init(frame: CGRect(x: searchTextField.frame.maxX + (80 * times) * 0.1, y: (80 * times) * 0.2, width: (80 * times) * 1.2, height: (80 * times) * 0.6))
        searchRight.setTitle("搜索", for: UIControlState.normal)
        searchRight.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        searchRight.addTarget(self, action: #selector(self.topSearchButtonClicked), for: UIControlEvents.touchUpInside)
        searchRight.backgroundColor = Colors.installColor
        searchView.addSubview(searchRight)
        
        let line = UILabel.init(frame: CGRect(x: searchTextField.frame.minX, y: searchTextField.frame.maxY, width: searchTextField.frame.size.width - dir, height: 0.5))
        line.backgroundColor = UIColor.lightGray
        searchView.addSubview(line)
    }
    
    func topSearchButtonClicked() {
        let searchValue = StringUtils.getString(searchTextField.text)
        let vc = InstallerSearchResultViewController()
        vc.searchValue = searchValue
        self.pushViewController(vc, animation: false)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.topSearchButtonClicked()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        topSearchButtonClicked()
        return true
    }
    
    func initHotWordsView() {
        hotWordsView = UIView.init(frame: CGRect(x: 0, y: searchView.frame.maxY, width: PhoneUtils.kScreenWidth, height: 200 * times))
        hotWordsView.backgroundColor = UIColor.white
        scrollView.addSubview(hotWordsView)
        
        let lineHeight = hotWordsView.frame.size.height / 4
        
        let tipsLabel = UILabel.init(frame: CGRect(x: dir * 4, y : 0, width: PhoneUtils.kScreenWidth / 2, height: lineHeight))
        tipsLabel.textColor = UIColor.lightGray
        tipsLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        tipsLabel.text = "热门搜索关键词"
        hotWordsView.addSubview(tipsLabel)
        
        var startY = tipsLabel.frame.maxY
        var startX = dir * 4
        for i in 0..<hotwords.count {
            let str = hotwords[i]
            let lineWidth = MSLFrameUtil.getLabWidth(str, fontSize: Dimens.fontSizeComm, height: lineHeight)
            
            if (lineWidth + startX > PhoneUtils.kScreenWidth || i == 4) {
                startX = dir * 4
                startY = tipsLabel.frame.maxY + 2 * dir + lineHeight * 1.1
            }
            
            let btn = UIButton.init(frame: CGRect(x: startX, y: startY, width: lineWidth + dir * 4, height: lineHeight * 1.1))
            btn.setTitle(str, for: UIControlState.normal)
            btn.setTitleColor(UIColor.black, for: UIControlState.normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
            btn.tag = i
            btn.layer.cornerRadius = 3.0
            btn.layer.borderColor = UIColor.black.cgColor
            btn.layer.borderWidth = 0.5
            btn.layer.masksToBounds = true
            btn.addTarget(self, action: #selector(self.searchButtonClicked(_:)), for: UIControlEvents.touchUpInside)
            hotWordsView.addSubview(btn)
            
            startX = btn.frame.maxX + 2 * dir
        }
    }
    
    func initMenuView() {
        menuView = UIView.init(frame: CGRect(x: 0, y: hotWordsView.frame.maxY + 2 * dir, width: PhoneUtils.kScreenWidth, height: 175 * times))
        menuView.backgroundColor = UIColor.white
        scrollView.addSubview(menuView)
        
        let icons = ["ic_installer_cala", "ic_installer_zu", "ic_installer_roof"]
        let names = ["屋顶评估", "屋顶出租", "屋顶地图"]
        
        let btnWidth = menuView.frame.size.width / 3
        let btnHeight = menuView.frame.size.height
        for i in 0..<icons.count {
            let btn = UIButton.init(frame: CGRect(x: btnWidth * CGFloat(i), y: 0, width: btnWidth, height: btnHeight))
            btn.setTitle(names[i], for: UIControlState.normal)
            btn.setImage(UIImage(named: icons[i]), for: UIControlState.normal)
            btn.setTitleColor(UIColor.black, for: UIControlState.normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
            btn.tag = i
            btn.addTarget(self, action: #selector(self.menuButtonClicked(_:)), for: UIControlEvents.touchUpInside)
            
            let imageSize:CGSize = btn.imageView!.frame.size
            let titleSize:CGSize = btn.titleLabel!.frame.size
            btn.titleEdgeInsets = UIEdgeInsets(top: 0, left:-imageSize.width, bottom: -imageSize.height - dir, right: 0)
            btn.imageEdgeInsets = UIEdgeInsets(top: -titleSize.height - dir, left: 0, bottom: 0, right: -titleSize.width)
            
            menuView.addSubview(btn)
        }
        
        let line1 = UILabel.init(frame: CGRect(x: btnWidth, y: btnHeight * 0.15, width: 0.5, height: btnHeight * 0.7))
        line1.backgroundColor = Colors.topButtonColor
        menuView.addSubview(line1)
        
        let line2 = UILabel.init(frame: CGRect(x: btnWidth * 2, y: btnHeight * 0.15, width: 0.5, height: btnHeight * 0.7))
        line2.backgroundColor = Colors.topButtonColor
        menuView.addSubview(line2)
    }
    
    func menuButtonClicked(_ sender: UIButton) {
        if (sender.tag == 0) {
            let vc = RoofPriceViewController()
            self.pushViewController(vc)
        } else if (sender.tag == 1) {
            if (shouldShowLogin()) {
                return
            }
            let vc = LeaseViewController(nibName: "LeaseViewController", bundle: nil)
            self.pushViewController(vc)
        } else if (sender.tag == 2) {
            let vc = MapViewController()
            self.pushViewController(vc)
        }
    }
    
    func searchButtonClicked(_ sender: UIButton) {
        let hotword = hotwords[sender.tag]
        let vc = InstallerSearchResultViewController()
        vc.searchValue = hotword
        self.pushViewController(vc, animation: false)
    }
    
    func viewMoreButtonClicked() {
        let vc = MoreInstallerViewController(nibName: "MoreInstallerViewController", bundle: nil)
        self.pushViewController(vc)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
