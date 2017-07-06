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
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        initView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: 0, height: 800)
    }
    
    func initView() {
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
            button.verticalImageAndTitle(2)
            menuView.addSubview(button)
            
            index += 1
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
