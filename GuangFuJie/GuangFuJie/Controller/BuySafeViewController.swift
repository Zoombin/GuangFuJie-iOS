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
    var insureModel : InsuranceTypeV2?
    var insureItemModel : InsuranceItemInfo?
    
    var typeView : UIView!
    var yearsView : UIView!
    
    var years = 0
    var currentSaleTypeIndex = -1
    
    var HScrollView: UIScrollView!
    
    var selectorImg = NSMutableArray()
    
    var seaSwitch = UISwitch()
    
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
        buyNowButton.backgroundColor = Colors.appBlue
        buyNowButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        buyNowButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        buyNowButton.addTarget(self, action: #selector(self.buyNow), for: UIControlEvents.touchUpInside)
        buyBottomView.addSubview(buyNowButton)

        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: self.navigationBarAndStatusBarHeight(), width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight - buyBottomView.frame.size.height - self.navigationBarAndStatusBarHeight()))
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
        uploadPhoto.setTitleColor(Colors.appBlue, for: UIControlState.normal)
        uploadPhoto.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        sectionView7.addSubview(uploadPhoto)
        
        let photoTipsLabel = UILabel.init(frame: CGRect(x: PhoneUtils.kScreenWidth - offSetX - 300, y: titleLabel7.frame.maxY, width: 300, height: 30 * times))
        photoTipsLabel.text = "为了给您提供更好的服务，请上传设备照片"
        photoTipsLabel.textAlignment = NSTextAlignment.right
        photoTipsLabel.textColor = UIColor.lightGray
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
        guigeLabel.textColor = Colors.appBlue
        guigeLabel.textAlignment = NSTextAlignment.right
        guigeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        sectionView3.addSubview(guigeLabel)
        
        let arrowImageButton1 = UIButton.init(frame: CGRect(x: PhoneUtils.kScreenWidth - 15 * times - offSetX, y:7.5 * times, width: 15 * times, height: 15 * times))
        arrowImageButton1.setImage(UIImage(named: "ic_blue_arrowdown"), for: UIControlState.normal)
        sectionView3.addSubview(arrowImageButton1)
        
        let tips3Label = UILabel.init(frame: CGRect(x: offSetX, y: titleLabel2.frame.maxY, width: PhoneUtils.kScreenWidth - 2 * offSetX, height: sectionView3.frame.size.height / 2))
        tips3Label.text = "特殊电站大小，请联系客服询价"
        tips3Label.textColor = UIColor.lightGray
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
        yearsLabel.textColor = Colors.appBlue
        yearsLabel.textAlignment = NSTextAlignment.right
        yearsLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        sectionView5.addSubview(yearsLabel)
        
        let arrowImageButton2 = UIButton.init(frame: CGRect(x: PhoneUtils.kScreenWidth - 15 * times - offSetX, y: 7.5 * times, width: 15 * times, height: 15 * times))
        arrowImageButton2.setImage(UIImage(named: "ic_blue_arrowdown"), for: UIControlState.normal)
        sectionView5.addSubview(arrowImageButton2)
        
        let takeEffectLabel = UILabel.init(frame: CGRect(x: PhoneUtils.kScreenWidth - offSetX - 270, y: titleLabel4.frame.maxY, width: 270, height: 30 * times))
        takeEffectLabel.text = "今日购买生效时间 " + PhoneUtils.getTommorrowDateStr(Date()) + " 00:00:00"
        takeEffectLabel.textAlignment = NSTextAlignment.right
        takeEffectLabel.textColor = UIColor.lightGray
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
        
        seaSwitch.frame = CGRect(x: PhoneUtils.kScreenWidth - offSetX - 60, y: 2, width: 60, height: (sectionView8.frame.size.height / 2) - 4)
        seaSwitch.addTarget(self, action: #selector(self.switchValueChanged), for: UIControlEvents.valueChanged)
        sectionView8.addSubview(seaSwitch)
        
        let ifNearSeaLabel = UILabel.init(frame: CGRect(x: seaSwitch.frame.minX - 105, y: 0, width: 100, height: sectionView8.frame.size.height / 2))
        ifNearSeaLabel.text = "是否沿海"
        ifNearSeaLabel.textColor = Colors.appBlue
        ifNearSeaLabel.textAlignment = NSTextAlignment.right
        ifNearSeaLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        sectionView8.addSubview(ifNearSeaLabel)
        
        salesTypeLabel = UILabel.init(frame: CGRect(x: PhoneUtils.kScreenWidth - 15 * times - offSetX - 280, y: 30 * times, width: 275, height: 30 * times))
        salesTypeLabel.text = "请选择套餐类型"
        salesTypeLabel.textColor = Colors.appBlue
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
        tipsLabel.textColor = UIColor.lightGray
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
            btn.layer.borderColor = Colors.appBlue.cgColor
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
    
    func switchValueChanged() {
        if (seaSwitch.isOn) {
            //打开了
            let alertView = UIAlertController.init(title: "提示", message: "以下城市是沿海城市:海南省全省浙江省全省 福建省（宁德、福清、莆田、泉州、漳州）广东省（潮州、汕头、揭阳、汕尾、惠州、珠海、阳江、江门、茂名、湛江）江苏（盐城）广西（北部湾、钦州、防城港）。保费将根据地区发生变化，请正确选择您的地区，错误地区将导致保单不生效！", preferredStyle: UIAlertControllerStyle.alert)
            let actionSure = UIAlertAction.init(title: "我知道了", style: UIAlertActionStyle.default, handler: nil)
            alertView.addAction(actionSure)
            self.present(alertView, animated: true, completion: nil)
            if (years > 1) {
                years = 1
            }
        }
        addYearsView()
        yearsLabel.text = "投保\(years)年"
    
        reSizePrice()
        
        insureItemModel = nil
        salesTypeLabel.text = "请选择套餐类型"
        priceLabel.text = "￥:0"
    }
    
    func loadInsuranceInfo() {
        self.showHud(in: self.view, hint: "加载中...")
        API.sharedInstance.insuranceTypeV2List(success: { (count, typeList) in
            self.hideHud()
            self.types.addObjects(from: typeList as [AnyObject])
            self.addTypeView()
            self.addYearsView()
        }) { (msg) in
            self.hideHud()
            self.showHint(msg)
        }
    }
    
    //MediaDaletege
    func onBgClick(_ tag : Int) {
        self.showPhotos(selectorImg, index: tag, isLocal: false)
    }
    
    func onDeleteClick(_ type:Int,tag : Int) {
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
        if (typeView != nil) {
           typeView.removeFromSuperview()
        }
        if (yearsView != nil) {
            yearsView.removeFromSuperview()
        }
    }
    
    func showYearsView() {
        if (yearsView != nil) {
            yearsView.isHidden = false
        }
    }
    
    func addYearsView() {
        var yearsArray = ["一年"]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if (yearsView == nil) {
            yearsView = UIView.init(frame: CGRect(x: 0, y: 0, width: PhoneUtils.kScreenWidth, height: PhoneUtils.kScreenHeight))
            yearsView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.2)
            yearsView.isHidden = true
            appDelegate.window?.addSubview(yearsView)
        
            let gesture = UITapGestureRecognizer.init(target: self, action: #selector(self.closeYearsView))
            yearsView.isUserInteractionEnabled = true
            yearsView.addGestureRecognizer(gesture)
        } else {
            if (seaSwitch.isOn) {
                yearsArray = ["一年"]
            }
            
            if(yearsView.subviews.count>0){
                for view in yearsView.subviews {
                    view.removeFromSuperview()
                }
            }
        }
        
        let totalLine: CGFloat = CGFloat((yearsArray.count / 4) + 1)
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
        cancelButton.backgroundColor = Colors.appBlue
        cancelButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        cancelButton.addTarget(self, action: #selector(self.closeYearsView), for: UIControlEvents.touchUpInside)
        closeBottomView.addSubview(cancelButton)
        
        var line : CGFloat = 0
        var index : CGFloat = 0
        for i in 0..<yearsArray.count {
            if (i != 0 && i%4 == 0) {
                index = 0
                line += 1
            }
            let button = UIButton.init(type: UIButtonType.custom)
            button.frame = CGRect(x: dir + index * dir + width * index, y: (line + 1) * dir + height * line, width: width, height: height)
            button.setTitle(yearsArray[i], for: UIControlState.normal)
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1
            if (years > 0 && years - 1 == i) {
                button.layer.borderColor = Colors.appBlue.cgColor
                button.layer.borderWidth = 1
            }
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
        let count = 1
        for i in 0..<count {
            let button = yearsView.viewWithTag(i + YEAR_BUTTON_TAG)
            button!.layer.borderColor = UIColor.black.cgColor
            button!.layer.borderWidth = 1
        }
        button.layer.borderColor = Colors.appBlue.cgColor
        button.layer.borderWidth = 1
        
        years = button.tag - YEAR_BUTTON_TAG + 1
        yearsLabel.text = "投保\(years)年"
        closeYearsView()
        
        reSizePrice()
    }
    
    func showSalesTypeView() {
        if (insureModel == nil) {
            self.showHint("请先选择电站大小")
        } else {
            self.showHud(in: self.view, hint: "加载中...")
            API.sharedInstance.insuranceItemList(typeId: YCStringUtils.getNumber(insureModel?.id), isNearSea: seaSwitch.isOn ? "1" : "0", success: { (count, array) in
                self.hideHud()
                self.showSalesActionSheet(array: array)
            }, failure: { (msg) in
                self.hideHud()
                self.showHint(msg)
            })
        }
    }
    
    func showSalesActionSheet(array: NSArray) {
        let actionSheet = UIAlertController.init(title: "请选择套餐类型", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        for i in 0..<array.count {
            let itemInfo = array[i] as! InsuranceItemInfo
            let itemAction = UIAlertAction.init(title: YCStringUtils.getString(itemInfo.itemTitle), style: UIAlertActionStyle.default, handler: { (action) in
                self.insureItemModel = itemInfo
                self.salesTypeLabel.text = YCStringUtils.getString(itemInfo.itemTitle)
                self.reSizePrice()
            })
            actionSheet.addAction(itemAction)
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
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
        cancelButton.backgroundColor = Colors.appBlue
        cancelButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        cancelButton.addTarget(self, action: #selector(self.closeTypeView), for: UIControlEvents.touchUpInside)
        closeBottomView.addSubview(cancelButton)
        
        var line : CGFloat = 0
        var index : CGFloat = 0
        for i in 0..<types.count {
            if (i != 0 && i%4 == 0) {
                index = 0
                line += 1
            }
            let insureType = types[i] as! InsuranceTypeV2
            let button = UIButton.init(type: UIButtonType.custom)
            button.frame = CGRect(x: dir + index * dir + width * index, y: (line + 1) * dir + height * line, width: width, height: height)
            button.setTitle(YCStringUtils.getString(insureType.label), for: UIControlState.normal)
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
        if (insureItemModel == nil) {
            return
        }
        priceLabel.text = String(format: "¥:%.2f元", insureItemModel!.price!.floatValue)
    }

    func viewButtonClicked(_ sender : UIButton) {
        let vc = GFJWebViewController()
        if (sender.tag == 1) {
            vc.title = "保险条款"
            vc.url = "http://ob4e8ww8r.bkt.clouddn.com/gfj_insurance_rules.pdf"
        } else {
            vc.title = "保险范本"
            vc.url = "http://ob4e8ww8r.bkt.clouddn.com/gfj_insurance_sample.jpeg"
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
    
    func buttonClicked(_ sender : UIButton) {
        closeTypeView()
        for i in 0..<types.count {
            let button = typeView.viewWithTag(i + BUTTON_TAG)
            button!.layer.borderColor = UIColor.black.cgColor
            button!.layer.borderWidth = 1
        }
        sender.layer.borderColor = Colors.appBlue.cgColor
        sender.layer.borderWidth = 1
        
        let insureType = types[sender.tag - BUTTON_TAG] as! InsuranceTypeV2
        insureModel = insureType
        
        insureItemModel = nil
        salesTypeLabel.text = "请选择套餐类型"
        priceLabel.text = "￥:0"
        
        refreshBaoeBaofei()
    }
    
    func refreshBaoeBaofei() {
        guigeLabel.text = YCStringUtils.getString(insureModel!.label)
        reSizePrice()
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
        if (insureItemModel == nil) {
            self.showHint("请选择套餐类型")
            return
        }
        let vc = ApplyForOrderViewController()
        vc.insuranceTypeV2 = insureModel
        vc.years = "\(years)"
        vc.insuranceItemInfo = insureItemModel
        vc.selectedImgs = selectorImg
        vc.is_nearsea = seaSwitch.isOn ? "1" : "0"
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
