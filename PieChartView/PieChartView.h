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



/*
   画饼状图
   @param x_values      x轴值的所有值名称
   @param targetValues 所有目标值
 */
-(void)drawPieChartViewWithXNames_Value:(NSMutableArray *)x_values TargetValues:(NSMutableArray *)targetValues;



/*
   画折线图
   @param x_values      x轴值的所有值名称
   @param targetValues 所有目标值
   @param lineType     直线类型
   @param isAuto       是否自动计算x轴间的间距
 */
-(void)drawLineChartViewWithXNames_Value:(NSMutableArray *)x_values TargetValues:(NSMutableArray *)targetValues LineType:(LineType) lineType WithIsAutoXMagin:(BOOL)isAuto;


/*
   画柱状图
 */
-(void)drawBarGraphViewWithXNames_Value:(NSMutableArray *)x_values TargetValues:(NSMutableArray *)targetValues WithIsAutoXMagin:(BOOL)isAuto;



/*
 @param  x_values             x轴值的所有名字
 @param  leftTargetValues     左侧显示值的所有目标值
 @param  rightTargetValues    右侧显示值的所有目标值
 @param  isAuto               是否自动生成x轴数据间的间距
 */
- (void)drawLineAndBarGraphViewWithNames_Values:(NSMutableArray *)x_values LeftValues:(NSMutableArray *)leftTargetValues AndRightValues:(NSMutableArray *)rightTargetValues LineType:(LineType) lineType WithIsAutoXMagin:(BOOL)isAuto;



@end
