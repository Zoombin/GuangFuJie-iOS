//
//  LoginView.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/7/30.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

protocol LoginViewDelegate : NSObjectProtocol {
    func getCodeButtonClicked(phone : String)
    func loginButtonClicked(phone : String, code : String)
}

class LoginView: UIView {
    var delegate : LoginViewDelegate?
    var phoneTextField : UITextField!
    var codeTextField : UITextField!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func initView() {
        self.backgroundColor = Colors.halfColor
        let viewWidth = PhoneUtils.kScreenWidth * 0.8
        let viewHeight = viewWidth * 0.65
        let height = viewHeight / 5
        let offSetX : CGFloat = 10
        
        let bkgView = UIView.init(frame: CGRectMake(0, 0, viewWidth, viewHeight))
        bkgView.backgroundColor = UIColor.whiteColor()
        bkgView.layer.cornerRadius = 6
        bkgView.layer.masksToBounds = true
        bkgView.center = self.center
        self.addSubview(bkgView)
        
        let titleLabel = UILabel.init(frame: CGRectMake(0, 0, viewWidth, height))
        titleLabel.text = "登录"
        titleLabel.textColor = Colors.lightGray
        titleLabel.textAlignment = NSTextAlignment.Center
        bkgView.addSubview(titleLabel)
        
        let closeButton = UIButton.init(frame: CGRectMake(viewWidth - 50, 0, 50, height))
        closeButton.setTitleColor(Colors.bkgColor, forState: UIControlState.Normal)
        closeButton.setTitle("X", forState: UIControlState.Normal)
        closeButton.addTarget(self, action: #selector(self.closeButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        bkgView.addSubview(closeButton)
        
        phoneTextField = CustomTextField.init(frame: CGRectMake(offSetX, CGRectGetMaxY(titleLabel.frame), viewWidth - offSetX * 2, height))
        phoneTextField.placeholder = "请输入手机号"
        phoneTextField.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        bkgView.addSubview(phoneTextField)
        
        codeTextField = CustomTextField.init(frame: CGRectMake(offSetX, CGRectGetMaxY(phoneTextField.frame), viewWidth - offSetX * 2, height))
        codeTextField.placeholder = "请输入验证码"
        codeTextField.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        bkgView.addSubview(codeTextField)
        
        let getCodeButton = UIButton.init(frame: CGRectMake(CGRectGetMaxX(codeTextField.frame) - 80, CGRectGetMaxY(phoneTextField.frame), 80, height))
        getCodeButton.setTitle("获取验证码", forState: UIControlState.Normal)
        getCodeButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        getCodeButton.setTitleColor(Colors.lightBule, forState: UIControlState.Normal)
        getCodeButton.addTarget(self, action: #selector(self.getCode), forControlEvents: UIControlEvents.TouchUpInside)
        bkgView.addSubview(getCodeButton)
        
        let loginButtonHeight = height * 1.1
        let startY = ((height * 2) - loginButtonHeight) / 2
        let loginButton = UIButton.init(frame: CGRectMake(offSetX, CGRectGetMaxY(getCodeButton.frame) + startY, codeTextField.frame.size.width, loginButtonHeight))
        loginButton.setTitle("确认登录", forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge2)
        loginButton.backgroundColor = Colors.installColor
        loginButton.addTarget(self, action: #selector(self.loginButtonClicked), forControlEvents: UIControlEvents.TouchUpInside)
        bkgView.addSubview(loginButton)
    }
    
    func hiddenAllKeyBoard() {
        phoneTextField.resignFirstResponder()
        codeTextField.resignFirstResponder()
    }
    
    func loginButtonClicked() {
        if (delegate != nil) {
            self.delegate?.loginButtonClicked(phoneTextField.text!, code: codeTextField.text!)
        }
    }
    
    func getCode() {
        if (delegate != nil) {
            self.delegate?.getCodeButtonClicked(phoneTextField.text!)
        }
    }
    
    func closeButtonClicked() {
        self.hidden = true
        hiddenAllKeyBoard()
    }
}
