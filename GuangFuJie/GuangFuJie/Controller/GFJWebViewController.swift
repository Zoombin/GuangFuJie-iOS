//
//  GFJWebViewController.swift
//  HeTianYu
//
//  Created by 颜超 on 16/4/29.
//  Copyright © 2016年 Zoombin. All rights reserved.
//

import UIKit

class GFJWebViewController: BaseViewController {

    var webView : UIWebView!
    var urlTag : Int = -1
    var url : String?
    var shareInfo: ShareInfo?
    var webSite = ""
    var isProduct = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(urlTag == 0){
            self.title = "关于我们"
            loadData()
        } else if (urlTag == -1) {
            self.initWebView(url!)
        }
    }
    
    func addShareInfoButton(info : ShareInfo) {
        if (Constants.project == "gaodeguangfu") {
            return
        }
        shareInfo = info
    }
  
    func loadData() {
        self.showHud(in: self.view, hint: "正在加载")
        if(urlTag == 0){
            API.sharedInstance.getContent("aboutus", success: { (msg, commonModel) in
                    self.hideHud()
                    self.initWebView(commonModel.con_url!)
                }, failure: { (msg) in
                    self.hideHud()
                    self.showHint(msg)
            })
        }
    }
    
    
    func initWebView(_ url:String) {
        self.automaticallyAdjustsScrollViewInsets = false
        let times = YCPhoneUtils.screenWidth / 375
        
        webView = UIWebView.init(frame: CGRect(x: 0, y: self.navigationBarAndStatusBarHeight(), width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - self.navigationBarAndStatusBarHeight()))
        webView.backgroundColor = UIColor.clear
        webView.loadRequest(URLRequest.init(url: URL.init(string: url)! as URL) as URLRequest)
        webView.scalesPageToFit = true
        webView.isOpaque = false
        self.view.addSubview(webView)
        
        if (isProduct && webSite.isEmpty == false) {
            let webSiteButton = UIButton.init(frame: CGRect(x: (YCPhoneUtils.screenWidth - 320 * times) / 2, y: PhoneUtils.kScreenHeight - self.navigationBarAndStatusBarHeight() - 20 * times, width: 320 * times, height: 40 * times))
            webSiteButton.layer.cornerRadius = webSiteButton.frame.size.height / 2
            webSiteButton.layer.masksToBounds = true
            webSiteButton.backgroundColor = Colors.appBlue
            webSiteButton.setTitle("访问官网", for: UIControlState.normal)
            webSiteButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            webSiteButton.titleLabel?.font = UIFont.systemFont(ofSize: YCPhoneUtils.getNewFontSize(fontSize: 15))
            webSiteButton.addTarget(self, action: #selector(self.showMainWebSite), for: UIControlEvents.touchUpInside)
            self.view.addSubview(webSiteButton)
        }
    }
    
    func showMainWebSite() {
        let vc = GFJWebViewController()
        vc.url = webSite
        self.pushViewController(vc)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
