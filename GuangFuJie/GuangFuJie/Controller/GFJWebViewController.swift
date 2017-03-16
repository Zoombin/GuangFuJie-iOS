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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(urlTag == 0){
            self.title = "关于我们"
            loadData()
        } else if (urlTag == -1) {
            self.initWebView(url!)
        }
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
    }
    
    func addShareInfoButton(info : ShareInfo) {
        shareInfo = info
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "分享", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.shareNews))
    }
    
    func shareNews() {
        self.shareButtonClicked(shareInfo: shareInfo!)
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
        webView = UIWebView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - 64))
        webView.backgroundColor = UIColor.clear
        webView.loadRequest(URLRequest.init(url: URL.init(string: url)! as URL) as URLRequest)
        webView.scalesPageToFit = true
        webView.isOpaque = false
        self.view.addSubview(webView)
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
