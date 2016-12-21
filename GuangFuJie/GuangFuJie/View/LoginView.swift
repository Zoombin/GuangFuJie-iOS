//
//  LoginView.swift
//  GuangFuJie
//
//  Created by 颜超 on 16/7/30.
//  Copyright © 2016年 颜超. All rights reserved.
//

import UIKit

protocol LoginViewDelegate : NSObjectProtocol {
    func getCodeButtonClicked(_ phone : String)
    func loginButtonClicked(_ phone : String, code : String)
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
        
        let bkgView = UIView.init(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        bkgView.backgroundColor = UIColor.white
        bkgView.layer.cornerRadius = 6
        bkgView.layer.masksToBounds = true
        bkgView.center = self.center
        self.addSubview(bkgView)
        
        let titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: viewWidth, height: height))
        titleLabel.text = "登录"
        titleLabel.textColor = Colors.lightGray
        titleLabel.textAlignment = NSTextAlignment.center
        bkgView.addSubview(titleLabel)
        
        let closeButton = UIButton.init(frame: CGRect(x: viewWidth - 50, y: 0, width: 50, height: height))
        closeButton.setTitleColor(Colors.bkgColor, for: UIControlState.normal)
        closeButton.setTitle("X", for: UIControlState.normal)
        closeButton.addTarget(self, action: #selector(self.closeButtonClicked), for: UIControlEvents.touchUpInside)
        bkgView.addSubview(closeButton)
        
        phoneTextField = CustomTextField.init(frame: CGRect(x: offSetX, y: (titleLabel.frame).maxY, width: viewWidth - offSetX * 2, height: height))
        phoneTextField.placeholder = "请输入手机号"
        phoneTextField.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        phoneTextField.keyboardType = UIKeyboardType.numberPad
        bkgView.addSubview(phoneTextField)
        
        codeTextField = CustomTextField.init(frame: CGRect(x: offSetX, y: (phoneTextField.frame).maxY, width: viewWidth - offSetX * 2, height: height))
        codeTextField.placeholder = "请输入验证码"
        codeTextField.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        codeTextField.keyboardType = UIKeyboardType.numberPad
        bkgView.addSubview(codeTextField)
        
        let getCodeButton = UIButton.init(frame: CGRect(x: (codeTextField.frame).maxX - 80, y: (phoneTextField.frame).maxY, width: 80, height: height))
        getCodeButton.setTitle("获取验证码", for: UIControlState.normal)
        getCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeComm)
        getCodeButton.setTitleColor(Colors.lightBule, for: UIControlState.normal)
        getCodeButton.addTarget(self, action: #selector(self.getCode), for: UIControlEvents.touchUpInside)
        bkgView.addSubview(getCodeButton)
        
        let loginButtonHeight = height * 1.1
        let startY = ((height * 2) - loginButtonHeight) / 2
        let loginButton = UIButton.init(frame: CGRect(x: offSetX, y: (getCodeButton.frame).maxY + startY, width: codeTextField.frame.size.width, height: loginButtonHeight))
        loginButton.setTitle("确认登录", for: UIControlState.normal)
        loginButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizelarge2)
        loginButton.backgroundColor = Colors.installColor
        loginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: UIControlEvents.touchUpInside)
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
        self.isHidden = true
        hiddenAllKeyBoard()
    }
}
