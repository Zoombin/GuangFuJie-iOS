//
//  BuySafeViewController.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/9/10.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

class BuySafeViewController: BaseViewController, UITextFieldDelegate, UIAlertViewDelegate, MediaDelegate {
    var priceLabel : UILabel!
    var guigeLabel : UILabel!
    var scrollView : UIScrollView!
    var yearsLabel : UILabel!
    var sizeLabel : UILabel!
    
    var salesTypeLabel : UILabel!
    
    var types = NSMutableArray()
    let BUTTON_TAG = 1000
    let YEAR_BUTTON_TAG = 2000
    let SALES_BUTTON_TAG = 3000
    
    let offSetX : CGFloat = 8
    let offSetY : CGFloat = 5
    let labelHeight = PhoneUtils.kScreenHeight / 9
    var insureModel : InsuranceType?
    
    var baoe1Label : UILabel!
    var baoe2Label : UILabel!
    var baoe3Label : UILabel!
    var baoe4Label : UILabel!
    var baoe5Label : UILabel!
    
    var baof1Label : UILabel!
    var baof2Label : UILabel!
    var baof3Label : UILabel!
    var baof4Label : UILabel!
    var baof5Label : UILabel!
    
    
    var typeView : UIView!
    var yearsView : UIView!
    var salesTypeView : UIView!
    
    var years = 0
    var currentSaleTypeIndex = -1
    
    var HScrollView: UIScrollView!
    
    var selectorImg = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "购买保险"
        // Do any additional setup after loading the view.
        initView()
        loadInsuranceInfo()
    }
    
    func initView() {
        let buyBottomView = UIView.init(frame: CGRect(x: 0, y: self.view.frame.size.height - 50, width: PhoneUtils.kScreenWidth, height: 50))
        buyBottomView.backgroundColor = UIColor.white
        self.view.addSubview(buyBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = buyBottomView.frame.size.height - 5 * 2
        
        let buyNowButton = GFJBottomButton.init(type: UIButtonType.custom)
        buyNowButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        buyNowButton.setTitle("立即购买", for: UIControlState.normal)
        buyNowButton.backgroundColor = Colors.installColor
        buyNowButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        buyNowButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        buyNowButton.addTarget(self, action: #selector(self.buyNow), for: UIControlEvents.touchUpInside)
        buyBottomView.addSubview(buyNowButton)

        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 64, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - buyBottomView.frame.size.height - 64))
        self.view.addSubview(scrollView)
        
        let times = PhoneUtils.kScreenWidth / 320
        let dir = 5 * times
        var maxY: CGFloat = offSetY
        
        //设备照片
        let sectionView7 = UIView.init(frame: CGRect(x: 0, y: maxY, width: PhoneUtils.kScreenWidth, height: 60 * times))
        sectionView7.backgroundColor = UIColor.white
        scrollView.addSubview(sectionView7)
        
        let titleLabel7 = UIButton.init(frame: CGRect(x: offSetX, y: 0, width: 150, height: 30 * times))
        titleLabel7.setTitle("设备照片(非必须)", for: UIControlState.normal)
        titleLabel7.setImage(UIImage(named: "ic_safe_sbzp"), for: UIControlState.normal)
        titleLabel7.setTitleColor(UIColor.black, for: UIControlState.normal)
        titleLabel7.titleEdgeInsets = UIEdgeInsetsMake(0, dir, 0, 0)
        titleLabel7.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        titleLabel7.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        sectionView7.addSubview(titleLabel7)
        
        let uploadPhoto = UIButton.init(frame: CGRect(x: PhoneUtils.kScreenWidth - offSetX - 80, y: 0, width: 80, height: 30 * times))
        uploadPhoto.titleEdgeInsets = UIEdgeInsetsMake(0, dir, 0, 0)
        uploadPhoto.setImage(UIImage(named: "ic_photo_add"), for: UIControlState.normal)
        uploadPhoto.setTitle("上传照片", for: UIControlState.normal)
        uploadPhoto.setTitleColor(Colors.installColor, for: UIControlState.normal)
        uploadPhoto.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        sectionView7.addSubview(uploadPhoto)
        
        let photoTipsLabel = UILabel.init(frame: CGRect(x: PhoneUtils.kScreenWidth - offSetX - 300, y: titleLabel7.frame.maxY, width: 300, height: 30 * times))
        photoTipsLabel.text = "为了给您提供更好的服务，请上传设备照片"
        photoTipsLabel.textAlignment = NSTextAlignment.right
        photoTipsLabel.textColor = Colors.lightGray
        photoTipsLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        sectionView7.addSubview(photoTipsLabel)
        
        //HScrollView
        HScrollView = UIScrollView()
        HScrollView.frame = CGRect(x: titleLabel7.frame.maxX, y: 2, width: PhoneUtils.kScreenWidth - uploadPhoto.frame.size.width - offSetX - titleLabel7.frame.maxX, height: 35 * times)
        HScrollView.backgroundColor = UIColor.white
        sectionView7.addSubview(HScrollView)
        //添加图片
        setHScrollView()
        
        maxY = sectionView7.frame.maxY + offSetY
        
        //电站大小
        let sectionView3 = UIView.init(frame: CGRect(x: 0, y: maxY, width: PhoneUtils.kScreenWidth, height: 60 * times))
        sectionView3.backgroundColor = UIColor.white
        scrollView.addSubview(sectionView3)
        
        let titleLabel2 = UIButton.init(frame: CGRect(x: offSetX, y: 0, width: 100, height: sectionView3.frame.size.height * 0.5))
        titleLabel2.setTitle("电站大小", for: UIControlState.normal)
        titleLabel2.setImage(UIImage(named: "ic_safe_dzdx"), for: UIControlState.normal)
        titleLabel2.setTitleColor(UIColor.black, for: UIControlState.normal)
        titleLabel2.titleEdgeInsets = UIEdgeInsetsMake(0, dir, 0, 0)
        titleLabel2.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        titleLabel2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        sectionView3.addSubview(titleLabel2)
        
        guigeLabel = UILabel.init(frame: CGRect(x: PhoneUtils.kScreenWidth - 15 * times - offSetX - 105, y: 0, width: 100, height: 30 * times))
        guigeLabel.text = "请选择电站规格"
        guigeLabel.textColor = Colors.installColor
        guigeLabel.textAlignment = NSTextAlignment.right
        guigeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        sectionView3.addSubview(guigeLabel)
        
        let arrowImageButton1 = UIButton.init(frame: CGRect(x: PhoneUtils.kScreenWidth - 15 * times - offSetX, y:7.5 * times, width: 15 * times, height: 15 * times))
        arrowImageButton1.setImage(UIImage(named: "ic_blue_arrowdown"), for: UIControlState.normal)
        sectionView3.addSubview(arrowImageButton1)
        
        let tips3Label = UILabel.init(frame: CGRect(x: offSetX, y: titleLabel2.frame.maxY, width: PhoneUtils.kScreenWidth - 2 * offSetX, height: sectionView3.frame.size.height / 2))
        tips3Label.text = "特殊电站大小，请联系客服询价"
        tips3Label.textColor = Colors.lightGray
        tips3Label.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        tips3Label.textAlignment = NSTextAlignment.right
        sectionView3.addSubview(tips3Label)
        
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 30 * times))
        button.addTarget(self, action: #selector(self.showTypeView), for: UIControlEvents.touchUpInside)
        sectionView3.addSubview(button)
        
        maxY = sectionView3.frame.maxY + offSetY
        
        //保障时间
        let sectionView5 = UIView.init(frame: CGRect(x: 0, y: maxY, width: PhoneUtils.kScreenWidth, height: 60 * times))
        sectionView5.backgroundColor = UIColor.white
        scrollView.addSubview(sectionView5)
        
        let titleLabel4 = UIButton.init(frame: CGRect(x: offSetX, y: 0, width: 100, height: 30 * times))
        titleLabel4.setTitle("保障时间", for: UIControlState.normal)
        titleLabel4.setImage(UIImage(named: "ic_safe_bzsj"), for: UIControlState.normal)
        titleLabel4.setTitleColor(UIColor.black, for: UIControlState.normal)
        titleLabel4.titleEdgeInsets = UIEdgeInsetsMake(0, dir, 0, 0)
        titleLabel4.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        titleLabel4.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        sectionView5.addSubview(titleLabel4)
        
        yearsLabel = UILabel.init(frame: CGRect(x: PhoneUtils.kScreenWidth - 15 * times - offSetX - 105, y: 0, width: 100, height: 30 * times))
        yearsLabel.text = "请选择投保年限"
        yearsLabel.textColor = Colors.installColor
        yearsLabel.textAlignment = NSTextAlignment.right
        yearsLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        sectionView5.addSubview(yearsLabel)
        
        let arrowImageButton2 = UIButton.init(frame: CGRect(x: PhoneUtils.kScreenWidth - 15 * times - offSetX, y: 7.5 * times, width: 15 * times, height: 15 * times))
        arrowImageButton2.setImage(UIImage(named: "ic_blue_arrowdown"), for: UIControlState.normal)
        sectionView5.addSubview(arrowImageButton2)
        
        let takeEffectLabel = UILabel.init(frame: CGRect(x: PhoneUtils.kScreenWidth - offSetX - 270, y: titleLabel4.frame.maxY, width: 270, height: 30 * times))
        takeEffectLabel.text = "今日购买生效时间 " + PhoneUtils.getTommorrowDateStr(Date()) + " 00:00:00"
        takeEffectLabel.textAlignment = NSTextAlignment.right
        takeEffectLabel.textColor = Colors.lightGray
        takeEffectLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        sectionView5.addSubview(takeEffectLabel)
        
        let button5 = UIButton.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: 30 * times))
        button5.addTarget(self, action: #selector(self.showYearsView), for: UIControlEvents.touchUpInside)
        sectionView5.addSubview(button5)
        
        maxY = sectionView5.frame.maxY + offSetY
        
        //套餐类型
        let sectionView8 = UIView.init(frame: CGRect(x: 0, y: maxY, width: PhoneUtils.kScreenWidth, height: 60 * times))
        sectionView8.backgroundColor = UIColor.white
        scrollView.addSubview(sectionView8)
        
        let titleLabel8 = UIButton.init(frame: CGRect(x: offSetX, y: 0, width: 100, height: sectionView8.frame.size.height / 2))
        titleLabel8.setTitle("套餐类型", for: UIControlState.normal)
        titleLabel8.setImage(UIImage(named: "ic_safe_bfje"), for: UIControlState.normal)
        titleLabel8.setTitleColor(UIColor.black, for: UIControlState.normal)
        titleLabel8.titleEdgeInsets = UIEdgeInsetsMake(0, dir, 0, 0)
        titleLabel8.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        titleLabel8.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        sectionView8.addSubview(titleLabel8)
        
        salesTypeLabel = UILabel.init(frame: CGRect(x: PhoneUtils.kScreenWidth - 15 * times - offSetX - 280, y: 30 * times, width: 275, height: 30 * times))
        salesTypeLabel.text = "请选择套餐类型"
        salesTypeLabel.textColor = Colors.installColor
        salesTypeLabel.textAlignment = NSTextAlignment.right
        salesTypeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        sectionView8.addSubview(salesTypeLabel)
        
        let arrowImageButton8 = UIButton.init(frame: CGRect(x: PhoneUtils.kScreenWidth - 15 * times - offSetX, y:30 * times + 7.5 * times, width: 15 * times, height: 15 * times))
        arrowImageButton8.setImage(UIImage(named: "ic_blue_arrowdown"), for: UIControlState.normal)
        sectionView8.addSubview(arrowImageButton8)
        
        let button8 = UIButton.init(frame: CGRect(x: 0, y: 30 * times, width: PhoneUtils.kScreenWidth, height: 30 * times))
        button8.addTarget(self, action: #selector(self.showSalesTypeView), for: UIControlEvents.touchUpInside)
        sectionView8.addSubview(button8)
        
        maxY = sectionView8.frame.maxY + offSetY
        
        //保费金额
        let sectionView1 = UIView.init(frame: CGRect(x: 0, y: maxY, width: PhoneUtils.kScreenWidth, height: 60 * times))
        sectionView1.backgroundColor = UIColor.white
        scrollView.addSubview(sectionView1)
        
        let titleLabel1 = UIButton.init(frame: CGRect(x: offSetX, y: 0, width: 100, height: sectionView1.frame.size.height * 0.6))
        titleLabel1.setTitle("保费金额", for: UIControlState.normal)
        titleLabel1.setImage(UIImage(named: "ic_safe_bfje"), for: UIControlState.normal)
        titleLabel1.setTitleColor(UIColor.black, for: UIControlState.normal)
        titleLabel1.titleEdgeInsets = UIEdgeInsetsMake(0, dir, 0, 0)
        titleLabel1.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        titleLabel1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        sectionView1.addSubview(titleLabel1)
        
        priceLabel = UILabel.init(frame: CGRect(x: PhoneUtils.kScreenWidth - offSetX - 140, y: 0, width: 140, height: sectionView1.frame.size.height * 0.6))
        priceLabel.text = "￥:0"
        priceLabel.textColor = UIColor.init(red: 250/255.0, green: 0/255.0, blue: 8/255.0, alpha: 1.0)
        priceLabel.textAlignment = NSTextAlignment.right
        priceLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge)
        sectionView1.addSubview(priceLabel)
        
        let tipsLabel = UILabel.init(frame: CGRect(x: offSetX, y: priceLabel.frame.maxY, width: PhoneUtils.kScreenWidth - 2 * offSetX, height: sectionView1.frame.size.height * 0.4))
        tipsLabel.text = "注:一个屋顶电站只能购买一份保险，不可叠加。"
        tipsLabel.textColor = Colors.lightGray
        tipsLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
        tipsLabel.textAlignment = NSTextAlignment.right
        sectionView1.addSubview(tipsLabel)
        
        let sectionView2 = UIView.init(frame: CGRect(x: 0, y: sectionView1.frame.maxY + offSetY, width: PhoneUtils.kScreenWidth, height: 30 * times))
        sectionView2.backgroundColor = UIColor.white
        scrollView.addSubview(sectionView2)
        
        let tips2Label = UILabel.init(frame: CGRect(x: offSetX, y: 0, width: PhoneUtils.kScreenWidth - 2 * offSetX, height: sectionView2.frame.size.height))
        tips2Label.text = "累计投保：3000+"
        tips2Label.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        tips2Label.textAlignment = NSTextAlignment.right
        sectionView2.addSubview(tips2Label)
        
        maxY = sectionView1.frame.maxY + offSetY
        
        //保障金额
        let sectionView4 = UIView.init(frame: CGRect(x: 0, y: maxY, width: PhoneUtils.kScreenWidth, height: 240 * times))
        sectionView4.backgroundColor = UIColor.white
        scrollView.addSubview(sectionView4)
        
        let titleLabel3 = UIButton.init(frame: CGRect(x: offSetX, y: 0, width: 100, height: 30 * times))
        titleLabel3.setTitle("保障金额", for: UIControlState.normal)
        titleLabel3.setImage(UIImage(named: "ic_safe_bzje"), for: UIControlState.normal)
        titleLabel3.setTitleColor(UIColor.black, for: UIControlState.normal)
        titleLabel3.titleEdgeInsets = UIEdgeInsetsMake(0, dir, 0, 0)
        titleLabel3.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        titleLabel3.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        sectionView4.addSubview(titleLabel3)
        
        let titleWidth = (PhoneUtils.kScreenWidth - 2 * offSetX) / 3
        let titleHeight = ((240 - 30) * times - 2 * offSetY) / 6
        let titles = ["险种", "保额", "保费/年", "光伏发电设备", "", "", "第三者责任", "", "", "", "", "","", "", "","盗抢险","",""]
        var tline = 0
        var tindex = 0
        for i in 0..<titles.count {
            if (i != 0 && i%3 == 0) {
                tline += 1
                tindex = 0
            }
            var tmpHeight = titleHeight
            if (i == 6) {
                tmpHeight = 3 * titleHeight
            }
       
            let label = UILabel.init(frame: CGRect(x:offSetX + CGFloat(tindex) * titleWidth, y: titleLabel3.frame.maxY + CGFloat(tline) * titleHeight, width: titleWidth, height: tmpHeight))
            label.text = titles[i]
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont.systemFont(ofSize: Dimens.fontSizeSmall)
            label.layer.borderColor = UIColor.lightGray.cgColor
            label.layer.borderWidth = 0.5
            sectionView4.addSubview(label)
            if (i == 9 || i == 12) {
                label.isHidden = true
            }
            if (i == 0 || i == 1 || i == 2) {
                label.textColor = UIColor.white
                label.backgroundColor = Colors.installColor
            }
            if (i == 4) {
                baoe1Label = label
            }
            if (i == 7) {
                baoe2Label = label
            }
            if (i == 10) {
                baoe3Label = label
            }
            if (i == 13) {
                baoe4Label = label
            }
            if (i == 16) {
                baoe5Label = label
            }
            
            if (i == 5) {
                baof1Label = label
            }
            if (i == 8) {
                baof2Label = label
            }
            if (i == 11) {
                baof3Label = label
            }
            if (i == 14) {
                baof4Label = label
            }
            if (i == 17) {
                baof5Label = label
            }
            tindex += 1
        }
        
        maxY = sectionView4.frame.maxY + offSetY
        
        let sectionView6 = UIView.init(frame: CGRect(x: 0, y: maxY, width: PhoneUtils.kScreenWidth, height: 45 * times))
        sectionView6.backgroundColor = UIColor.white
        scrollView.addSubview(sectionView6)
        
        let pagerTitles = ["查看保险条款", "纸质保单范本"]
        let pagerOffSetX = 10 * times
        let pagerOffSetY = 10 * times
        let pagerBtnWidth = (PhoneUtils.kScreenWidth - pagerOffSetX * 4) / 2
        let pagerBtnHeight = 25 * times
        for i in 0..<pagerTitles.count {
            let btn = UIButton.init(frame: CGRect(x: pagerOffSetX * CGFloat(i + 1) + pagerBtnWidth * CGFloat(i), y: pagerOffSetY, width: pagerBtnWidth, height: pagerBtnHeight))
            if (i == 0) {
                btn.frame = CGRect(x: offSetX, y: pagerOffSetY, width: pagerBtnWidth, height: pagerBtnHeight)
            } else {
                btn.frame = CGRect(x: PhoneUtils.kScreenWidth - pagerBtnWidth - offSetX, y: pagerOffSetY, width: pagerBtnWidth, height: pagerBtnHeight)
            }
            btn.setTitle(pagerTitles[i], for: UIControlState.normal)
            btn.setTitleColor(UIColor.black, for: UIControlState.normal)
            btn.layer.cornerRadius = 5
            btn.layer.masksToBounds = true
            btn.layer.borderColor = Colors.lightBule.cgColor
            btn.layer.borderWidth = 1
            btn.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
            btn.titleLabel?.adjustsFontSizeToFitWidth = true
            btn.tag = i + 1
            btn.addTarget(self, action: #selector(self.viewButtonClicked(_:)), for: UIControlEvents.touchUpInside)
            sectionView6.addSubview(btn)
        }
        
        maxY = sectionView6.frame.maxY + offSetY
        
        scrollView.contentSize = CGSize(width: 0, height: sectionView6.frame.maxY)
    }
    
    func loadInsuranceInfo() {
        self.showHud(in: self.view, hint: "加载中...")
        API.sharedInstance.insuranceType({ (typeList, totalCount) in
                self.hideHud()
//                self.totalLabel.text = "累计投保:" + String(totalCount) + "份"
                self.types.addObjects(from: typeList as [AnyObject])
                self.addTypeView()
                self.addSalesView()
                self.addYearsView()
            }) { (msg) in
                self.hideHud()
                self.showHint(msg)
        }
    }
    
    //MediaDaletege
    func onBgClick(_ tag : Int){
        self.showPhotos(selectorImg, index: tag, isLocal: false)
    }
    
    func onDeleteClick(_ type:Int,tag : Int){
        if(0 == type){
            selectorImg.removeObject(at: tag)
        }
        setHScrollView()
    }
    
    func onPlayClick(_ tag:Int){
        
    }
    
    func sampleImageClicked() {
        self.showPhotos(["device_pic_sample"], index: 0, isLocal: true)
    }
    
    func addMediaClick(_ gesture : UITapGestureRecognizer) -> Void {
        let tag = gesture.view?.tag
        if (tag == 0 ){
            if(selectorImg.count >= 9){
                self.showHint("最多上传9张图片")
                return
            }
            uploadImage()
        }
    }
    
    //设置水平滚动的布局
    func setHScrollView() -> Void {
        //HScrollView
        if(HScrollView.subviews.count>0){
            for view in HScrollView.subviews {
                view.removeFromSuperview()
            }
        }
        
        let mediaW :CGFloat = HScrollView.frame.size.height
        let mediaH :CGFloat = HScrollView.frame.size.height
        let dir :CGFloat = 8
        
        let imgCount = selectorImg.count
        var lastX : CGFloat = dir
        //先添加可操作按钮
        if(imgCount < 9){
            let sampleImage = UIImageView()
            sampleImage.frame = CGRect(x: lastX, y: 0, width: mediaW, height: mediaH)
            sampleImage.image = UIImage.init(named: "ic_device_sample")
            sampleImage.tag = 0
            sampleImage.isUserInteractionEnabled = true
            let tagGesture1 : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(sampleImageClicked))
            sampleImage.addGestureRecognizer(tagGesture1)
            HScrollView.addSubview(sampleImage)
            
            lastX = sampleImage.frame.maxX + dir
            
            //Img
            let add_img = UIImageView()
            add_img.frame = CGRect(x: lastX, y: 0, width: mediaW, height: mediaH)
            add_img.image = UIImage.init(named: "btn_addnew")
            add_img.tag = 0
            add_img.isUserInteractionEnabled = true
            let tagGesture2 : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(addMediaClick(_:)))
            add_img.addGestureRecognizer(tagGesture2)
            HScrollView.addSubview(add_img)
            
            lastX = add_img.frame.maxX+dir
        }
        //实际图片数
        if(imgCount > 0){
            for index in 0...imgCount-1 {
                let ImgX = lastX
                let mediaView = PublishMediaView()
                mediaView.frame = CGRect(x: ImgX, y: 0, width: mediaW, height: mediaH)
                mediaView.initView(0, viewW: mediaW, viewH: mediaH)
                mediaView.tag = index
                mediaView.isUserInteractionEnabled = true
                mediaView.delegate = self
                let url = selectorImg.object(at: index) as! String
                mediaView.displayImageView(url+"?imageView2/1/w/400/h/400")
                HScrollView.addSubview(mediaView)
                
                lastX = mediaView.frame.maxX+dir
            }
        }
       
        HScrollView.contentSize = CGSize(width: lastX+10, height: mediaH)
    }

    deinit {
        typeView.removeFromSuperview()
        yearsView.removeFromSuperview()
        salesTypeView.removeFromSuperview()
    }
    
    func showYearsView() {
        if (yearsView != nil) {
            yearsView.isHidden = false
        }
    }
    
    func addYearsView() {
        let years = ["一年", "二年", "三年", "四年", "五年"]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        yearsView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight))
        yearsView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.2)
        yearsView.isHidden = true
        appDelegate.window?.addSubview(yearsView)
        
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self.closeYearsView))
        yearsView.isUserInteractionEnabled = true
        yearsView.addGestureRecognizer(gesture)
        
        let totalLine: CGFloat = CGFloat((years.count / 4) + 1)
        let dir: CGFloat = 5
        let width = (PhoneUtils.kScreenWidth - dir * 5) / 4
        let height = PhoneUtils.kScreenHeight / 15
        let bkgViewHeight = (totalLine * height) + (totalLine + 1) * dir
        
        let bkgView = UIView.init(frame: CGRect(x: 0, y: PhoneUtils.kScreenHeight - bkgViewHeight - 50, width: PhoneUtils.kScreenWidth, height: bkgViewHeight))
        bkgView.backgroundColor = UIColor.white
        yearsView.addSubview(bkgView)
        
        let closeBottomView = UIView.init(frame: CGRect(x: 0, y: bkgView.frame.maxY, width: PhoneUtils.kScreenWidth, height: 50))
        closeBottomView.backgroundColor = UIColor.white
        yearsView.addSubview(closeBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = closeBottomView.frame.size.height - 5 * 2
        
        let cancelButton = GFJBottomButton.init(type: UIButtonType.custom)
        cancelButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.backgroundColor = Colors.installColor
        cancelButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        cancelButton.addTarget(self, action: #selector(self.closeYearsView), for: UIControlEvents.touchUpInside)
        closeBottomView.addSubview(cancelButton)
        
        var line : CGFloat = 0
        var index : CGFloat = 0
        for i in 0..<years.count {
            print(i)
            if (i != 0 && i%4 == 0) {
                index = 0
                line += 1
            }
            let button = UIButton.init(type: UIButtonType.custom)
            button.frame = CGRect(x: dir + index * dir + width * index, y: (line + 1) * dir + height * line, width: width, height: height)
            button.setTitle(years[i], for: UIControlState.normal)
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.backgroundColor = UIColor.white
            button.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
            button.tag = i + YEAR_BUTTON_TAG
            button.addTarget(self, action: #selector(self.yearsButtonClicked(_:)), for: UIControlEvents.touchUpInside)
            bkgView.addSubview(button)
            index += 1
        }
    }
    
    func closeYearsView() {
        yearsView.isHidden = true
    }
    
    func yearsButtonClicked(_ button: UIButton) {
        for i in 0..<5 {
            let button = yearsView.viewWithTag(i + YEAR_BUTTON_TAG)
            button!.layer.borderColor = UIColor.black.cgColor
            button!.layer.borderWidth = 1
        }
        button.layer.borderColor = Colors.installColor.cgColor
        button.layer.borderWidth = 1
        
        years = button.tag - YEAR_BUTTON_TAG + 1
        yearsLabel.text = "投保\(years)年"
        closeYearsView()
        
        reSizePrice()
    }
    
    func showSalesTypeView() {
        if (salesTypeView != nil) {
            salesTypeView.isHidden = false
        } else {
            self.showHint("请先选择电站大小")
        }
    }
    
    func closeSaleTypeView() {
        salesTypeView.isHidden = true
    }
    
    func addTypeView() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        typeView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight))
        typeView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.2)
        typeView.isHidden = true
        appDelegate.window?.addSubview(typeView)
        
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self.closeTypeView))
        typeView.isUserInteractionEnabled = true
        typeView.addGestureRecognizer(gesture)
        
        let totalLine: CGFloat = CGFloat((types.count / 4) + 1)
        let dir: CGFloat = 5
        let width = (PhoneUtils.kScreenWidth - dir * 5) / 4
        let height = PhoneUtils.kScreenHeight / 15
        let bkgViewHeight = (totalLine * height) + (totalLine + 1) * dir
        
        let bkgView = UIView.init(frame: CGRect(x: 0, y: PhoneUtils.kScreenHeight - bkgViewHeight - 50, width: PhoneUtils.kScreenWidth, height: bkgViewHeight))
        bkgView.backgroundColor = UIColor.white
        typeView.addSubview(bkgView)
        
        let closeBottomView = UIView.init(frame: CGRect(x: 0, y: bkgView.frame.maxY, width: PhoneUtils.kScreenWidth, height: 50))
        closeBottomView.backgroundColor = UIColor.white
        typeView.addSubview(closeBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = closeBottomView.frame.size.height - 5 * 2
        
        let cancelButton = GFJBottomButton.init(type: UIButtonType.custom)
        cancelButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.backgroundColor = Colors.installColor
        cancelButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        cancelButton.addTarget(self, action: #selector(self.closeTypeView), for: UIControlEvents.touchUpInside)
        closeBottomView.addSubview(cancelButton)
        
        var line : CGFloat = 0
        var index : CGFloat = 0
        for i in 0..<types.count {
            print(i)
            if (i != 0 && i%4 == 0) {
                index = 0
                line += 1
            }
            let insureType = types[i] as! InsuranceType
            let button = UIButton.init(type: UIButtonType.custom)
            button.frame = CGRect(x: dir + index * dir + width * index, y: (line + 1) * dir + height * line, width: width, height: height)
            button.setTitle(StringUtils.getString(insureType.label), for: UIControlState.normal)
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.backgroundColor = UIColor.white
            button.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
            button.tag = BUTTON_TAG + i
            button.addTarget(self, action: #selector(self.buttonClicked(_:)), for: UIControlEvents.touchUpInside)
            bkgView.addSubview(button)
            index += 1
        }
    }
    
    func showTypeView() {
        if (typeView != nil) {
            typeView.isHidden = false
        }
    }
    
    func addSalesView() {
        let salesTypes = insureModel?.saleTypes
        if (salesTypes == nil) {
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if (salesTypeView == nil) {
            salesTypeView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight))
            salesTypeView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.2)
            salesTypeView.isHidden = true
            appDelegate.window?.addSubview(salesTypeView)
        }
        
        if(salesTypeView.subviews.count>0){
            for view in salesTypeView.subviews {
                view.removeFromSuperview()
            }
        }
        
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self.closeSaleTypeView))
        salesTypeView.isUserInteractionEnabled = true
        salesTypeView.addGestureRecognizer(gesture)
        
        let totalLine: CGFloat = CGFloat(salesTypes!.count)
        let dir: CGFloat = 5
        let width = (PhoneUtils.kScreenWidth - dir * 2)
        let height = PhoneUtils.kScreenHeight / 15
        let bkgViewHeight = (totalLine * height) + (totalLine + 1) * dir
        
        let bkgView = UIView.init(frame: CGRect(x: 0, y: PhoneUtils.kScreenHeight - bkgViewHeight - 50, width: PhoneUtils.kScreenWidth, height: bkgViewHeight))
        bkgView.backgroundColor = UIColor.white
        salesTypeView.addSubview(bkgView)
        
        let closeBottomView = UIView.init(frame: CGRect(x: 0, y: bkgView.frame.maxY, width: PhoneUtils.kScreenWidth, height: 50))
        closeBottomView.backgroundColor = UIColor.white
        salesTypeView.addSubview(closeBottomView)
        
        let buttonWidth = PhoneUtils.kScreenWidth - 5 * 2
        let buttonHeight = closeBottomView.frame.size.height - 5 * 2
        
        let cancelButton = GFJBottomButton.init(type: UIButtonType.custom)
        cancelButton.frame = CGRect(x: 5, y: 5, width: buttonWidth, height: buttonHeight)
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.backgroundColor = Colors.installColor
        cancelButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        cancelButton.addTarget(self, action: #selector(self.closeTypeView), for: UIControlEvents.touchUpInside)
        closeBottomView.addSubview(cancelButton)
        
        for i in 0..<salesTypes!.count {
            let salesType = salesTypes![i] as! NSDictionary
            let button = UIButton.init(type: UIButtonType.custom)
            button.frame = CGRect(x: dir, y: (CGFloat(i) + 1) * dir + height * CGFloat(i), width: width, height: height)
            button.setTitle(StringUtils.getString(salesType["typeName"] as? String), for: UIControlState.normal)
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.backgroundColor = UIColor.white
            button.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
            button.tag = i + SALES_BUTTON_TAG
            if (i == currentSaleTypeIndex) {
                button.layer.borderColor = Colors.installColor.cgColor
                button.layer.borderWidth = 1
            }
            button.addTarget(self, action: #selector(self.salesButtonClicked(_:)), for: UIControlEvents.touchUpInside)
            bkgView.addSubview(button)
        }
    }
    
    func closeTypeView() {
        typeView.isHidden = true
    }
    
    func valueChanged() {
        reSizePrice()
    }
    
    func reSizePrice() {
        if (insureModel == nil) {
            return
        }
        if (insureModel?.saleTypes == nil) {
            return
        }
        if (currentSaleTypeIndex == -1) {
            return
        }
        let salesType = insureModel!.saleTypes![currentSaleTypeIndex] as! NSDictionary
        let currentPrice = salesType["typePrice"] as! NSNumber
        priceLabel.text = String(format: "￥:%.2f元", currentPrice.floatValue * Float(years))
    }

    func viewButtonClicked(_ sender : UIButton) {
        let vc = PhotoViewController()
        if (sender.tag == 1) {
            vc.type = 1
        } else {
            vc.type = 3
        }
        self.pushViewController(vc)
    }
    
    func tellPhoneUsButtonClicked() {
        let alertView = UIAlertView.init(title: "提示", message: "是否拨打电话给客服？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertView.show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if (alertView.cancelButtonIndex != buttonIndex) {
            UIApplication.shared.openURL(URL.init(string: "tel://4006229666")! as URL)
        }
    }
    
    func salesButtonClicked(_ sender : UIButton) {
        for i in 0..<insureModel!.saleTypes!.count {
            let button = salesTypeView.viewWithTag(i + SALES_BUTTON_TAG)
            button!.layer.borderColor = UIColor.black.cgColor
            button!.layer.borderWidth = 1
        }
        sender.layer.borderColor = Colors.installColor.cgColor
        sender.layer.borderWidth = 1
        
        closeSaleTypeView()        
        currentSaleTypeIndex = sender.tag - SALES_BUTTON_TAG
        
        let salesType = insureModel!.saleTypes![currentSaleTypeIndex] as! NSDictionary
        salesTypeLabel.text = salesType["typeName"] as? String
        
        reSizePrice()
    }
    
    func buttonClicked(_ sender : UIButton) {
        closeTypeView()
        for i in 0..<types.count {
            let button = typeView.viewWithTag(i + BUTTON_TAG)
            button!.layer.borderColor = UIColor.black.cgColor
            button!.layer.borderWidth = 1
        }
        sender.layer.borderColor = Colors.installColor.cgColor
        sender.layer.borderWidth = 1
        
        let insureType = types[sender.tag - BUTTON_TAG] as! InsuranceType
        insureModel = insureType
        addSalesView()
        
        guigeLabel.text = StringUtils.getString(insureModel!.label)
        reSizePrice()
        
        baoe1Label.text = String(format: "%@万", StringUtils.getString(insureType.protect_device))
        baoe2Label.text = String(format: "%@万", StringUtils.getString(insureType.protect_third_two))
        baoe3Label.text = String(format: "%@万", StringUtils.getString(insureType.protect_third_five))
        baoe4Label.text = String(format: "%@万", StringUtils.getString(insureType.protect_third_ten))
        baoe5Label.text = String(format: "%@万", StringUtils.getString(insureType.protect_steal))
        
        baof1Label.text = String(format: "%@元", StringUtils.getString(insureType.price_device))
        baof2Label.text = String(format: "%@元", StringUtils.getString(insureType.price_third_two))
        baof3Label.text = String(format: "%@元", StringUtils.getString(insureType.price_third_five))
        baof4Label.text = String(format: "%@元", StringUtils.getString(insureType.price_third_ten))
        baof5Label.text = String(format: "%@元", StringUtils.getString(insureType.price_steal))
    }
    
    func buyNow() {
        if (years == 0) {
            self.showHint("请选择年限")
            return
        }
        if (insureModel == nil) {
            self.showHint("请选择电站大小")
            return
        }
        if (currentSaleTypeIndex == -1) {
            self.showHint("请选择套餐类型")
            return
        }
        let salesType = insureModel!.saleTypes![currentSaleTypeIndex] as! NSDictionary
        
        let currentPrice = salesType["typePrice"] as! NSNumber
        let price = String(format: "%.2f", currentPrice.floatValue * Float(years))
        let vc = ApplyForOrderViewController()
        vc.insuranceType = insureModel
        vc.salesType = salesType["typeId"] as! NSNumber
        vc.years = "\(years)"
        vc.totalprice = NSNumber(value: NSString(string: price).floatValue)
        vc.price = currentPrice
        vc.selectedImgs = selectorImg
        self.pushViewController(vc)
    }
    
    func uploadImage() {
        takePhoto()
    }
    
    override func pickerCallback(_ image: UIImage) {
        let imgData = UIImagePNGRepresentation(image)
        let time = Date().timeIntervalSince1970
        let key = "device_\(time).png"
        self.showHud(in: self.view, hint: "正在上传")
        API.sharedInstance.qnToken(key, success: { (info) in
            API.sharedInstance.uploadData(imgData!, key: key, token: info.token!, success: { (result) in
                self.hideHud()
                if (result.info?.error != nil) {
                    self.showHint("上传失败")
                } else {
                    self.showHint("上传成功")
                    let url = "http://ob4e8ww8r.bkt.clouddn.com/" + result.key!
                    self.selectorImg.add(url)
                    self.setHScrollView()
                }
            })
        }) { (error) in
            self.hideHud()
            self.showHint(error)
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
