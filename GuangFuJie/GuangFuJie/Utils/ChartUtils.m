//
//  ChartUtils.m
//  GuangFuJie
//
//  Created by 颜超 on 16/9/14.
//  Copyright © 2016年 颜超. All rights reserved.
//

#import "ChartUtils.h"


@implementation ChartUtils

+ (PNLineChart *)addLineChartsWidthFrame:(NSMutableArray *)xDates yDates:(NSMutableArray *)yDates andFrame:(CGRect)frame {
    //For Line Chart
    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:frame];
    lineChart.backgroundColor = [UIColor whiteColor];
    [lineChart setXLabels:xDates];
    
    // Line Chart No.1
    NSArray * data01Array = yDates;
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    lineChart.chartData = @[data01];
    [lineChart strokeChart];
    return  lineChart;
}

+ (PNBarChart *)addBarChartsWidthFrame:(NSMutableArray *)xDates yDates:(NSMutableArray *)yDates andFrame:(CGRect)frame {
    PNBarChart *barChart = [[PNBarChart alloc] initWithFrame:frame];
    barChart.yChartLabelWidth = 36;
    [barChart setXLabels:xDates];
    [barChart setYValues:yDates];
    return barChart;
}
@end
