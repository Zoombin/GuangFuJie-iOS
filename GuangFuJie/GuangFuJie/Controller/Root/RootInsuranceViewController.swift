//
//  RootInsuranceViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2017/7/6.
//  Copyright © 2017年 yc. All rights reserved.
//

import UIKit

class RootInsuranceViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var inTableView: UITableView!
    @IBOutlet weak var bannerScrollView: UIScrollView!
    
    var infoArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "光伏保险"
        self.loadData()
        self.initBannerImageView()
    }
    
    func initBannerImageView() {
        if (bannerScrollView.subviews.count > 0) {
            for view in bannerScrollView.subviews {
                view.removeFromSuperview()
            }
        }
        for i in 0..<2 {
            let imageView = UIImageView.init(frame: CGRect(x: CGFloat(i) * PhoneUtils.kScreenWidth, y: 0, width: PhoneUtils.kScreenWidth, height: bannerScrollView.frame.size.height))
            imageView.tag = i
            imageView.isUserInteractionEnabled = true
            if (i == 0) {
                imageView.image = UIImage(named: "ic_insure01")
            } else if (i == 1) {
                imageView.image = UIImage(named: "ic_insure02")
            }
            bannerScrollView.addSubview(imageView)
            
            let gesture = UITapGestureRecognizer()
            gesture.addTarget(self, action: #selector(self.bannerClicked(gesture:)))
            imageView.addGestureRecognizer(gesture)
            
        }
        bannerScrollView.contentSize = CGSize(width: PhoneUtils.kScreenWidth * CGFloat(2), height: 0)
    }
    
    func bannerClicked(gesture: UITapGestureRecognizer) {
        let index = gesture.view!.tag
        if (index == 0) {
            let vc = InsuranceGuideViewController()
            self.pushViewController(vc)
        } else if (index == 1) {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "NewsListViewController") as! NewsListViewController
            vc.title = "保险案例"
            vc.type = 22
            self.pushViewController(vc)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bannerScrollView.isPagingEnabled = true
        
        let buyBottomView = UIView.init(frame: CGRect(x: 0, y: PhoneUtils.kScreenHeight - 50, width: PhoneUtils.kScreenWidth, height: 50))
        buyBottomView.backgroundColor = UIColor.white
        self.view.addSubview(buyBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = buyBottomView.frame.size.height - 5 * 2
        
        let calButton = GFJBottomButton.init(type: UIButtonType.custom)
        calButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        calButton.setTitle("购买保险", for: UIControlState.normal)
        calButton.backgroundColor = Colors.appBlue
        calButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        calButton.titleLabel?.font = UIFont.systemFont(ofSize: FontUtils.getFontSize(size: 17))
        calButton.addTarget(self, action: #selector(self.buyNow), for: UIControlEvents.touchUpInside)
        buyBottomView.addSubview(calButton)
    }
    
    func loadData() {
        API.sharedInstance.usersHaveInsuranceList(0, pagesize: 1, success: { (array) in
            self.infoArray.addObjects(from: array as! [Any])
            self.inTableView.reloadData()
        }) { (msg) in
            
        }
    }
    
    func buyNow() {
        let vc = BuySafeViewController()
        self.pushViewController(vc)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InsuranceCell") as! InsuranceCell
        let info = infoArray[indexPath.row] as! InsuranceInfo
        cell.setData(info, isSelf: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
