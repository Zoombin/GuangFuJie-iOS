//
//  ChartUtils.h
//  GuangFuJie
//
//  Created by 颜超 on 16/9/14.
//  Copyright © 2016年 颜超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"

@interface ChartUtils : NSObject

+ (PNLineChart *)addLineChartsWidthFrame:(NSMutableArray *)xDates yDates:(NSMutableArray *)yDates andFrame:(CGRect)frame;

+ (PNBarChart *)addBarChartsWidthFrame:(NSMutableArray *)xDates yDates:(NSMutableArray *)yDates andFrame:(CGRect)frame;
@end
