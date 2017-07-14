//
//  RootHomeViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/6.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootHomeViewController: BaseViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var bannerScrollView: UIScrollView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "首页"
        initView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: 0, height: 800)
        self.navigationController?.tabBarItem.selectedImage = self.tabBarItem.selectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
    func initView() {
        self.view.backgroundColor = UIColor.white
        loadMenusView()
        initBannerImageView()
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
        } else if (sender.tag == 1) {
           //政策咨询
        } else if (sender.tag == 2) {
           //安装运维
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
        } else if (sender.tag == 6) {
           //活动通告
        } else if (sender.tag == 7) {
           //客服
            let chatViewManager = MQChatViewManager()
            chatViewManager.chatViewStyle.statusBarStyle = UIStatusBarStyle.lightContent
            chatViewManager.chatViewStyle.navBarColor = Colors.appBlue
            chatViewManager.chatViewStyle.navTitleColor = UIColor.white
            chatViewManager.chatViewStyle.navBackButtonImage = UIImage(named: "ic_back")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            chatViewManager.pushMQChatViewController(in: self)
        }
    }
    
    func initBannerImageView() {
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: bannerScrollView.frame.size.height))
        imageView.image = UIImage(named: "ic_home_banner1")
        bannerScrollView.addSubview(imageView)
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
