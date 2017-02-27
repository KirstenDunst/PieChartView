//
//  PieChartView.h
//  PieChartView
//
//  Created by CSX on 2017/2/25.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import <UIKit/UIKit.h>

// 折线条的线条类型
typedef NS_ENUM(NSInteger, LineType) {
    LineType_Straight, // 折线
    LineType_Curve     // 曲线
};

@interface PieChartView : UIView

//初始化
+(instancetype)PieViewWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame;




/**
 *  画饼状图
 *  @param x_names      x轴值的所有值名称
 *  @param targetValues 所有目标值
 */
-(void)drawPieChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues;

/**
 *  画折线图
 *  @param x_names      x轴值的所有值名称
 *  @param targetValues 所有目标值
 *  @param lineType     直线类型
 */
-(void)drawLineChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues LineType:(LineType) lineType;


/**
 *  画柱状图
 */
-(void)drawBarChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues;



@end
