//
//  LoginView.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/7/30.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

protocol LoginViewDelegate : NSObjectProtocol {
    func registerButtonClicked()
    func forgetPasswordButtonClicked()
}

class LoginView: UIView {
    var delegate : LoginViewDelegate?
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
        let viewHeight = viewWidth * 0.7
        let height = viewHeight / 6
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
        
        let phoneTextField = CustomTextField.init(frame: CGRectMake(offSetX, CGRectGetMaxY(titleLabel.frame), viewWidth - offSetX * 2, height))
        phoneTextField.placeholder = "请输入手机号"
        phoneTextField.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        bkgView.addSubview(phoneTextField)
        
        let pwdTextField = CustomTextField.init(frame: CGRectMake(offSetX, CGRectGetMaxY(phoneTextField.frame), viewWidth - offSetX * 2, height))
        pwdTextField.placeholder = "请输入验证码"
        pwdTextField.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        pwdTextField.secureTextEntry = true
        bkgView.addSubview(pwdTextField)
        
        let registerButton = UIButton.init(frame: CGRectMake(offSetX, CGRectGetMaxY(pwdTextField.frame), 60, height))
        registerButton.setTitle("自助注册", forState: UIControlState.Normal)
        registerButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        registerButton.setTitleColor(Colors.lightBule, forState: UIControlState.Normal)
        registerButton.addTarget(self, action: #selector(self.registClick), forControlEvents: UIControlEvents.TouchUpInside)
        bkgView.addSubview(registerButton)
        
        let forgetButton = UIButton.init(frame: CGRectMake(CGRectGetMaxX(pwdTextField.frame) - 60, CGRectGetMaxY(pwdTextField.frame), 60, height))
        forgetButton.setTitle("忘记密码", forState: UIControlState.Normal)
        forgetButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeComm)
        forgetButton.setTitleColor(Colors.lightBule, forState: UIControlState.Normal)
        forgetButton.addTarget(self, action: #selector(self.forgetClick), forControlEvents: UIControlEvents.TouchUpInside)
        bkgView.addSubview(forgetButton)
        
//        let rememberAccountButton = UIButton.init(frame: CGRectMake(0, CGRectGetMaxY(forgetButton.frame), pwdTextField.frame.size.width / 3, height))
//        rememberAccountButton.setTitle("记住用户名", forState: UIControlState.Normal)
//        rememberAccountButton.setImage(UIImage(named: "checkbox"), forState: UIControlState.Normal)
//        rememberAccountButton.setImage(UIImage(named: "checkbox_hl"), forState: UIControlState.Selected)
//        rememberAccountButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizeSmall2)
//        rememberAccountButton.setTitleColor(Colors.lightGray, forState: UIControlState.Normal)
//        bkgView.addSubview(rememberAccountButton)
        
        let loginButtonHeight = height * 1.2
        let startY = ((height * 2) - loginButtonHeight) / 2
        let loginButton = UIButton.init(frame: CGRectMake(offSetX, CGRectGetMaxY(registerButton.frame) + startY, pwdTextField.frame.size.width, loginButtonHeight))
        loginButton.setTitle("确认", forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginButton.titleLabel?.font = UIFont.systemFontOfSize(Dimens.fontSizelarge2)
        loginButton.backgroundColor = Colors.lightBule
        loginButton.layer.cornerRadius = 6
        loginButton.layer.masksToBounds = true
        bkgView.addSubview(loginButton)
    }
    
    func registClick() {
        if (delegate != nil) {
            self.delegate?.registerButtonClicked()
        }
    }
    
    func forgetClick() {
        if (delegate != nil) {
            self.delegate?.forgetPasswordButtonClicked()
        }
    }
    
    func closeButtonClicked() {
        self.hidden = true
    }
}
