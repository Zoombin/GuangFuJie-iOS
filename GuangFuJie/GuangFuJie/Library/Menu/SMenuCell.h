//
//  SMenuCell.h
//  GuangFuJie
//
//  Created by 颜超 on 2016/10/18.
//  Copyright © 2016年 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMenuCell : UITableViewCell

@property(nonatomic, strong) UIButton *imageButton;
- (void)initView:(CGRect)frame;
- (void)setIsSelected:(BOOL)selected;
@end
