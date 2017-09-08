//
//  MSLFrameUtil.h
//  MeEngine
//
//  Created by yc on 12-9-25.
//  Copyright (c) 2012年 xmload. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSLFrameUtil : NSObject
+ (CGFloat)setTop:(CGFloat)top UI:(UIView *)view;
+ (CGFloat)setLeft:(CGFloat)left UI:(UIView *)view;
+ (CGFloat)setRight:(CGFloat)right UI:(UIView *)view;
+ (CGFloat)setHeight:(CGFloat)height UI:(UIView *)view;
+ (CGFloat)setWidth:(CGFloat)width UI:(UIView *)view;
+ (CGFloat)getLabWidth:(NSString *)text FontSize:(CGFloat)size Height:(CGFloat)height;
+ (CGFloat)getLabHeight:(NSString *)text FontSize:(CGFloat)size Width:(CGFloat)width;
+ (CGFloat)getLabHeight:(NSString *)text Font:(UIFont *)font Width:(CGFloat)width;
+ (void)setCornerRadius:(CGFloat)width UI:(UIView *)view;
+ (void)setBorder:(CGFloat)width Color:(UIColor *)color UI:(UIView *)view;
+ (CGPoint)getViewCenter:(UIView *)view;
@end
