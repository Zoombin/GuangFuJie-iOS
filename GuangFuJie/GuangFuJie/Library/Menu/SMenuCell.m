//
//  SMenuCell.m
//  GuangFuJie
//
//  Created by 颜超 on 2016/10/18.
//  Copyright © 2016年 颜超. All rights reserved.
//

#import "SMenuCell.h"

@implementation SMenuCell {
    BOOL hasInit;
    UIButton *selectedMarkButton;
}

- (void)initView:(CGRect)frame {
    if (hasInit) {
        return;
    }
    hasInit = YES;
    
    _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _imageButton.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, frame.size.height);
    _imageButton.userInteractionEnabled = NO;
    [self.contentView addSubview:_imageButton];
    
    selectedMarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectedMarkButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - frame.size.height, 0, frame.size.height, frame.size.height);
    [selectedMarkButton setImage:nil forState:UIControlStateNormal];
    [selectedMarkButton setImage:[UIImage imageNamed:@"menu_selected_gray"] forState:UIControlStateSelected];
    selectedMarkButton.userInteractionEnabled = NO;
    [self.contentView addSubview:selectedMarkButton];
}

- (void)setIsSelected:(BOOL)selected {
    selectedMarkButton.selected = selected;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
