//
//  InstallerDetailViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 2016/12/12.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class InstallerDetailViewController: BaseViewController {
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var addressLabel : UILabel!
    @IBOutlet weak var phoneLabel : UILabel!
    @IBOutlet weak var sizeLabel : UILabel!
    @IBOutlet weak var tipsLabel : UILabel!
    
    @IBOutlet weak var logoImageView : UIImageView!
    @IBOutlet weak var zhizhaoImageView : UIImageView!
    
    @IBOutlet weak var introView : UIView!
    @IBOutlet weak var introLabel : UILabel!
    
    @IBOutlet weak var scrollView : UIScrollView!
    
    var installer_id : NSNumber!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
    }
    
    func loadData() {
        self.showHudInView(self.view, hint: "加载中")
        API.sharedInstance.installerDetail(installer_id, success: { (installerDetail) in
                self.hideHud()
                self.setData(installerDetail)
            }) { (msg) in
                self.hideHud()
                self.showHint(msg)
        }
    }
    
    func setData(installerDetail : InstallInfo) {
        var name = ""
        if (installerDetail.company_name != nil) {
            name = installerDetail.company_name!
        }
        nameLabel.text = name
        self.title = name
        
        var size = "公司规模："
        if (installerDetail.company_size != nil) {
            size = size + installerDetail.company_size! + "人"
        } else {
            size = size + "未填写"
        }
        sizeLabel.text = size
        
        var phone = "联系方式："
        if (installerDetail.contact_info != nil) {
            phone = phone + installerDetail.contact_info!
        } else {
            phone = phone + "未填写"
        }
        phoneLabel.text = phone
        
        var location = "公司地址："
        if ((installerDetail.province_label) != nil) {
            location = location + installerDetail.province_label!
        }
        if ((installerDetail.city_label) != nil) {
            location = location + installerDetail.city_label!
        }
        if ((installerDetail.address) != nil) {
            location = location + installerDetail.address!
        }
        addressLabel.text = location
        
        if (installerDetail.is_installer == 2) {
            tipsLabel.text = "已认证"
            tipsLabel.textColor = Colors.installColor
        } else {
            tipsLabel.text = "未认证"
            tipsLabel.textColor = Colors.installRedColor
        }
        
        if (installerDetail.logo != nil) {
            logoImageView.setImageWithURL(NSURL.init(string: installerDetail.logo!)!)
        }
        if (installerDetail.license_url != nil) {
            zhizhaoImageView.setImageWithURL(NSURL.init(string: installerDetail.license_url!)!)
        }
        
        var intro = ""
        if (installerDetail.company_intro != nil) {
           intro = installerDetail.company_intro!
        }
        introLabel.text = intro
        let originHeight = introLabel.frame.size.height
        var height = MSLFrameUtil.getLabHeight(intro, fontSize: 15, width: introLabel.frame.size.width)
        if (originHeight > height) {
            height = originHeight
        }
        
        introLabel.frame = CGRectMake(introLabel.frame.origin.x, introLabel.frame.origin.y, introLabel.frame.size.width, height)
        
        introView.frame = CGRectMake(introView.frame.origin.x, introView.frame.origin.y, introView.frame.size.width, introView.frame.size.height + height - originHeight)
        
        scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(introView.frame))
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
