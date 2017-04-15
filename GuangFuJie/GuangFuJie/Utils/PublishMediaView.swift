//
//  PublishMediaView.swift
//  HeTianYu
//
//  Created by LSD on 16/4/12.
//  Copyright © 2016年 Zoombin. All rights reserved.
//

import UIKit

protocol MediaDelegate : NSObjectProtocol {
    func onBgClick(_ tag : Int)
    func onDeleteClick(_ type:Int,tag : Int)
    func onPlayClick(_ tag:Int)
}

class PublishMediaView: UIView {
    var delegate : MediaDelegate?
    var displayType:Int?
    var showImageView : UIImageView?
    var deleteImageView : UIImageView?
    var playImageView : UIImageView?
    
    func initView(_ displayType:Int,viewW:CGFloat,viewH:CGFloat){
        if(showImageView != nil && deleteImageView != nil && playImageView != nil){
            return
        }
        self.displayType = displayType
        showImageView = UIImageView()
        showImageView?.frame = CGRect(x: 0, y: 0, width: viewW, height: viewH)
        showImageView!.isUserInteractionEnabled = true
//        showImageView?.layer.cornerRadius = 3
        self.addSubview(showImageView!)
        
        deleteImageView = UIImageView()
        deleteImageView?.frame = CGRect(x: viewW - 16 - 1, y: 1, width: 16, height: 16)
        deleteImageView?.image = UIImage.init(named: "ic_publish_mdel")
        deleteImageView!.isUserInteractionEnabled = true
        self.addSubview(deleteImageView!)
        
        playImageView = UIImageView()
        playImageView?.frame = CGRect(x: (viewW - 30) / 2 , y: (viewH - 30) / 2, width: 30, height: 30)
        playImageView?.image = UIImage.init(named: "ic_publish_play")
        playImageView!.isUserInteractionEnabled = true
        playImageView?.isHidden = true
        self.addSubview(playImageView!)
        
        let tagGesture1 : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(bgClick))
        showImageView!.addGestureRecognizer(tagGesture1)
        
        let tagGesture2 : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(delClick))
        deleteImageView!.addGestureRecognizer(tagGesture2)
        
        let tagGesture3 : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(pyClick))
        playImageView!.addGestureRecognizer(tagGesture3)
    }
    
    func displayImageView(_ imgUrl:String) {
        showImageView?.setImageWith(URL.init(string: imgUrl)!, placeholderImage: UIImage.init(named: "ic_placeholder_small"))
        if(0 == displayType){
            playImageView?.isHidden = true
        }else if(1 == displayType){
            playImageView?.isHidden = false
        }
    }
    
    func bgClick() {
        if(0 == displayType){
            if(delegate != nil){
                delegate?.onBgClick(self.tag)
            }
        }
    }
    func delClick() {
        if(delegate != nil){
            delegate?.onDeleteClick(displayType!, tag:self.tag)
        }
    }
    func pyClick() {
        if(delegate != nil){
            delegate?.onPlayClick(self.tag)
        }
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}
