//
//  ImageTitleButton.m
//  HeTianYu
//
//  Created by 颜超 on 2017/5/11.
//  Copyright © 2017年 Zoombin. All rights reserved.
//

#import "ImageTitleButton.h"

@implementation ImageTitleButton

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)verticalImageAndTitle:(CGFloat)spacing
{
    self.titleLabel.backgroundColor = [UIColor clearColor];
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
}

@end
