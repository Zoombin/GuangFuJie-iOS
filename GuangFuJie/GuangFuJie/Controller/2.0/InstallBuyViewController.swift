//
//  InstallBuyViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/10.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class InstallBuyViewController: BaseViewController {

    var roofId : NSNumber!
    var scrollView : UIScrollView!  
    var rInfo : RoofInfo?
    var imageView : UIImageView!
    var nameLabel : UILabel!
    var phoneLabel : UILabel!
    var sizeLabel : UILabel!
    var priceLabel : UILabel!
    var typeLabel : UILabel!
    var createTimeLabel : UILabel!
    var locationButton : UIButton!
    
    var isSelf = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安装商接单"
        // Do any additional setup after loading the view.
        initView()
        loadRoofInfo()
    }
    
    func addFavButton(isFav : Bool) {
        if (isFav) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "取消收藏", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelFavButtonClicked))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "收藏屋顶", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.favButtonClicked))
        }
    }
    
    func favButtonClicked() {
        self.showHud(in: self.view, hint: "加载中")
        API.sharedInstance.favRoof(roofId, { (model) in
            self.hideHud()
            self.showHint("收藏成功")
            self.loadRoofInfo()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    func cancelFavButtonClicked() {
        self.showHud(in: self.view, hint: "加载中")
        API.sharedInstance.unFavRoof(roofId, { (model) in
            self.hideHud()
            self.showHint("取消收藏成功")
            self.loadRoofInfo()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    func loadRoofInfo() {
        self.showHud(in: self.view, hint: "加载中...")
        API.sharedInstance.getRoofInfo(roofId, success: { (roofInfo) in
                self.hideHud()
                self.rInfo = roofInfo
                self.title = roofInfo.fullname!
                self.loadData()
                self.addFavButton(isFav: roofInfo.is_favor!.boolValue)
            }) { (msg) in
                self.hideHud()
                self.showHint(msg)
        }
    }
    
    func loadData() {
        imageView.setImageWith(URL.init(string: rInfo!.area_image!)! as URL)
        nameLabel.text = rInfo!.fullname!
        phoneLabel.text = "****"
        sizeLabel.text = String(describing: rInfo!.area_size!) + "㎡"
        typeLabel.text = "屋顶类型:" + (rInfo!.type! == 2 ? "斜面" : "平面")
        priceLabel.text = String(describing: rInfo!.price!) + "元/㎡"
        createTimeLabel.text = rInfo!.created_date!
        
        var address = ""
        if (rInfo!.province_label != nil) {
            address = address + rInfo!.province_label!
        }
        if (rInfo!.city_label != nil) {
            address = address + rInfo!.city_label!
        }
        if (rInfo!.address != nil) {
            address = address + rInfo!.address!
        }

        locationButton.setTitle(address, for: UIControlState.normal)
    }
    
    let cellReuseIdentifier = "cellReuseIdentifier"
    func initView() {
        let buyBottomView = UIView.init(frame: CGRect(x: 0, y: self.view.frame.size.height - 50, width: PhoneUtils.kScreenWidth, height: 50))
        buyBottomView.backgroundColor = UIColor.white
        self.view.addSubview(buyBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = buyBottomView.frame.size.height - 5 * 2
        
        let buyNowButton = GFJBottomButton.init(type: UIButtonType.custom)
        buyNowButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        buyNowButton.setTitle("立即接单", for: UIControlState.normal)
        buyNowButton.backgroundColor = Colors.installColor
        buyNowButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        buyNowButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        buyNowButton.addTarget(self, action: #selector(self.orderNowButtonClicked), for: UIControlEvents.touchUpInside)
        buyBottomView.addSubview(buyNowButton)
        
        var offSetY : CGFloat = 0
        if (isSelf) {
            buyBottomView.isHidden = true
            offSetY = buyBottomView.frame.size.height - 100
        }
        
        scrollView = UITableView.init(frame: CGRect(x: 0, y: 64, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - offSetY - 64 - 50), style: UITableViewStyle.grouped)
        scrollView.backgroundColor = UIColor.clear
        self.view.addSubview(scrollView)

        let imgOrginWidth : CGFloat = 670
        let imgOrignHeight : CGFloat = 430
        let imgWidth = PhoneUtils.kScreenWidth
        let imgHeight = (imgWidth * imgOrignHeight) / imgOrginWidth
        imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: imgWidth, height: imgHeight))
        scrollView.addSubview(imageView)
        
        let titles = ["", "", "屋顶面积", "", "屋顶类型", "", "出租单价", "", "发布时间", ""]
        
        let labelWidth = PhoneUtils.kScreenWidth / 2
        let labelHeight = PhoneUtils.kScreenHeight / 14
        var index : CGFloat = 0
        var line : CGFloat = 0
        var labels = [UILabel]()
        var maxY = imageView.frame.maxY
        for i in 0..<titles.count {
            if (i != 0 && i%2 == 0) {
                line = line + 1
                index = 0
            }
            let label = UILabel.init(frame: CGRect(x: index * labelWidth ,y: (line * labelHeight) + imageView.frame.maxY, width: labelWidth, height: labelHeight))
            label.text = titles[i]
            label.layer.borderColor = UIColor.lightGray.cgColor
            label.layer.borderWidth = 0.5
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
            label.backgroundColor = UIColor.white
            scrollView.addSubview(label)
            labels.append(label)
            
            maxY = label.frame.maxY
            
            index = index + 1
        }
        nameLabel = labels[0]
        phoneLabel = labels[1]
        sizeLabel = labels[3]
        typeLabel = labels[5]
        priceLabel = labels[7]
        createTimeLabel = labels[9]
        
        locationButton = UIButton.init(type: UIButtonType.custom)
        locationButton.frame = CGRect(x:0, y:maxY, width: PhoneUtils.kScreenWidth, height: labelHeight)
        locationButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        locationButton.backgroundColor = UIColor.white
        locationButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        locationButton.setImage(UIImage(named: "roof_location"), for: UIControlState.normal)
        scrollView.addSubview(locationButton)
    }
    
    func orderNowButtonClicked() {
        if (shouldShowLogin()) {
            return
        }
        self.showHud(in: self.view, hint: "提交中...")
        API.sharedInstance.orderRoof(roofId, success: { (commonModel) in
                self.hideHud()
                self.showHint("接单成功!")
                self.navigationController?.popViewController(animated: true)
            }) { (msg) in
                self.hideHud()
                self.showHint(msg)
        }
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
