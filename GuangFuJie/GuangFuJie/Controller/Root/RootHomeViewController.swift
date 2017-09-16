//
//  RootHomeViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/6.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootHomeViewController: BaseViewController, ProviceCityViewDelegate, UIScrollViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var bannerScrollView: UIScrollView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var exampleButton1: UIButton!
    @IBOutlet weak var exampleButton2: UIButton!
    @IBOutlet weak var exampleButton3: UIButton!
    
    var exampleData = NSMutableArray()
    var bannerData = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "首页"
        initView()
        loadBannerData()
        loadExampleData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.delegate = self
        scrollView.contentSize = CGSize(width: 0, height: 800)
        self.navigationController?.tabBarItem.selectedImage = self.tabBarItem.selectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
    //加载案例数据
    func loadExampleData() {
        API.sharedInstance.articlesList(0, pagesize: 0, key: nil, provinceId: nil, cityId: nil, areaId: nil, type: 2, success: { (count, array) in
            if (array.count > 0) {
                self.exampleData.addObjects(from: array as! [Any])
                self.refreshExampleButtons()
            }
        }) { (msg) in
            
        }
    }
    
    func loadBannerData() {
        API.sharedInstance.articlesList(0, pagesize: 0, key: nil, provinceId: nil, cityId: nil, areaId: nil, type: 10, success: { (count, array) in
            if (array.count > 0) {
                self.bannerData.addObjects(from: array as! [Any])
                self.initBannerImageView()
            }
        }) { (msg) in
            
        }
    }
    
    func initView() {
        self.view.backgroundColor = UIColor.white
        loadMenusView()
    }
    
    func refreshExampleButtons() {
        exampleButton1.setBackgroundImage(nil, for: UIControlState.normal)
        exampleButton2.setBackgroundImage(nil, for: UIControlState.normal)
        exampleButton3.setBackgroundImage(nil, for: UIControlState.normal)
        
        exampleButton1.isUserInteractionEnabled = false
        exampleButton2.isUserInteractionEnabled = false
        exampleButton3.isUserInteractionEnabled = false
        
        for i in 0..<exampleData.count {
            let info = exampleData[i] as! ArticleInfo
            if (i == 0) {
                exampleButton1.isUserInteractionEnabled = true
                exampleButton1.setBackgroundImageFor(UIControlState.normal, with: URL.init(string: info.image!)!)
            } else if (i == 1) {
                exampleButton2.isUserInteractionEnabled = true
                exampleButton2.setBackgroundImageFor(UIControlState.normal, with: URL.init(string: info.image!)!)
            } else if (i == 2) {
                exampleButton3.isUserInteractionEnabled = true
                exampleButton3.setBackgroundImageFor(UIControlState.normal, with: URL.init(string: info.image!)!)
            }
        }
    }
    
    @IBAction func exampleButtonClicked(button: UIButton) {
        let data = exampleData[button.tag] as! ArticleInfo
        
        let shareInfo = ShareInfo()
        shareInfo.shareImg = StringUtils.getString(data.image)
        shareInfo.shareTitle = StringUtils.getString("资讯")
        shareInfo.shareDesc = StringUtils.getString(data.title)
        shareInfo.shareLink = Constants.httpHost.replacingOccurrences(of: "/api/", with: "") + "/articles/\(data.id!)"
        
        let vc = GFJWebViewController()
        vc.url = Constants.httpHost.replacingOccurrences(of: "/api/", with: "") + "/articles/\(data.id!)"
        vc.title = StringUtils.getString(data.title)
        vc.addShareInfoButton(info: shareInfo)
        self.pushViewController(vc)
    }
    
    @IBAction func locationSetting() {
        let vc = ProviceCityViewController()
        vc.delegate = self
        
        let nav = UINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func proviceAndCity(_ provice: ProvinceModel, city: CityModel, area: AreaModel) {
        locationButton.setTitle("\(StringUtils.getString(city.name))\(StringUtils.getString(area.name))", for: UIControlState.normal)
    }
    
    func loadMenusView() {
        let icons = ["ic_home_menu1", "ic_home_menu2", "ic_home_menu3", "ic_home_menu4", "ic_home_menu5", "ic_home_menu6", "ic_home_menu7", "ic_home_menu8"]
        let names = ["体验店", "政策咨询", "安装运维", "光伏保险", "光伏问答", "公司介绍", "活动通告", "客服"]
        
        let btnWidth = PhoneUtils.kScreenWidth / 4
        let btnHeight = menuView.frame.size.height / 2
        var index: CGFloat = 0
        var line: CGFloat = 0
        for i in 0..<icons.count {
            if (i != 0 && i%4==0) {
                index = 0
                line += 1
            }
            let button = ImageTitleButton.init(type: UIButtonType.custom)
            button.frame = CGRect(x: btnWidth * index, y: btnHeight * line , width:btnWidth , height: btnHeight)
            button.setImage(UIImage(named: icons[i]), for: UIControlState.normal)
            button.setTitle(names[i], for: UIControlState.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: FontUtils.getFontSize(size: 15))
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.tag = i
            button.addTarget(self, action: #selector(self.menuButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
            button.verticalImageAndTitle(2)
            menuView.addSubview(button)
            
            index += 1
        }
    }
    
    func menuButtonClicked(sender: UIButton) {
        if (sender.tag == 0) {
           //体验店
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ExperienceShopViewController")
            self.pushViewController(vc)
        } else if (sender.tag == 1) {
           //政策资讯
            self.tabBarController?.selectedIndex = 3
        } else if (sender.tag == 2) {
           //安装运维
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "NewsListViewController") as! NewsListViewController
            vc.type = 7
            vc.title = "安装运维"
            self.pushViewController(vc)
        } else if (sender.tag == 3) {
           //光伏保险
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            self.pushViewController(sb.instantiateViewController(withIdentifier: "RootInsuranceViewController"))
        } else if (sender.tag == 4) {
           //光伏问答
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            self.pushViewController(sb.instantiateViewController(withIdentifier: "GuangFuAskViewController"))
        } else if (sender.tag == 5) {
           //公司介绍
            API.sharedInstance.articlesList(0, pagesize: 1, key: nil, provinceId: nil, cityId: nil, areaId: nil, type: 8, success: { (count, array) in
                if (array.count >= 1) {
                    let article = array[0] as! ArticleInfo
                    let vc = GFJWebViewController()
                    vc.title = "公司介绍"
                    vc.url = Constants.httpHost.replacingOccurrences(of: "/api/", with: "") + "/articles/\(article.id!)"
                    self.pushViewController(vc)
                }
            }) { (msg) in
                self.showHint(msg)
            }
        } else if (sender.tag == 6) {
           //活动通告
            self.showHint("我们正在筹备中，暂未开放")
        } else if (sender.tag == 7) {
           //客服
            self.chat()
        }
    }
    
    @IBAction func moreExample() {
        //更多案例
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NewsListViewController") as! NewsListViewController
        vc.type = 2
        vc.title = "成功案例"
        self.pushViewController(vc)
    }
    
    func initBannerImageView() {
        if (bannerScrollView.subviews.count > 0) {
            for view in bannerScrollView.subviews {
                view.removeFromSuperview()
            }
        }
        for i in 0..<bannerData.count {
            let info = bannerData[i] as! ArticleInfo
            let imageView = UIImageView.init(frame: CGRect(x: CGFloat(i) * PhoneUtils.kScreenWidth, y: 0, width: PhoneUtils.kScreenWidth, height: bannerScrollView.frame.size.height))
            imageView.setImageWith(URL.init(string: StringUtils.getString(info.image))!)
            imageView.tag = i
            imageView.isUserInteractionEnabled = true
            bannerScrollView.addSubview(imageView)
            
            let gesture = UITapGestureRecognizer()
            gesture.addTarget(self, action: #selector(self.bannerClicked(gesture:)))
            imageView.addGestureRecognizer(gesture)
            
        }
        pageControl.numberOfPages = bannerData.count
        bannerScrollView.contentSize = CGSize(width: PhoneUtils.kScreenWidth * CGFloat(bannerData.count), height: 0)
    }
    
    func bannerClicked(gesture: UITapGestureRecognizer) {
        let index = gesture.view?.tag
        if (index == 0) {
            self.tabBarController?.selectedIndex = 3
        } else if (index == 1) {
            self.tabBarController?.selectedIndex = 2
        } else if (index == 2) {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            self.pushViewController(sb.instantiateViewController(withIdentifier: "RootInsuranceViewController"))
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        self.tabBarController?.selectedIndex = 3
        return false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = PhoneUtils.kScreenWidth
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        pageControl.currentPage = Int(page)
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
