//
//  PieChartView.m
//  PieChartView
//
//  Created by CSX on 2017/2/25.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import "PieChartView.h"



// 随机色
#define RandomColor  RGBACOLOR(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256),1)
// 颜色RGB
#define RGBACOLOR(r, g, b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

@implementation PieChartView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
    }
    return self;
}

/**
 *  画饼状图
 *  @param x_names      x轴值的所有值名称
 *  @param targetValues 所有目标值
 */
-(void)drawPieChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues{
    CGPoint point = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat startAngle = 0;
    CGFloat endAngle;
    CGFloat radius = 100;
    
    //计算总数 获取所有目标的评比数据之和
    __block CGFloat allValue = 0;
    [targetValues enumerateObjectsUsingBlock:^(NSNumber *targetNumber, NSUInteger idx, BOOL * _Nonnull stop) {
        allValue += [targetNumber floatValue];
    }];
    
    for (int i = 0; i<targetValues.count; i++) {
        CGFloat targetValue = [targetValues[i] floatValue];
        //获取占比范围以角度的样式展示
        endAngle = startAngle + targetValue/allValue*2*M_PI;
        /*
         参数一：圆的圆心
         参数二：半径
         参数三：开始角度
         参数四：结束角度
         参数五：是否顺时针画弧
         */
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:point radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        [bezierPath addLineToPoint:point];
        [bezierPath closePath];
        
        //添加文字
        CGFloat X = point.x + 120*cos(startAngle+(endAngle-startAngle)/2) - 10;
        CGFloat Y = point.y + 110*sin(startAngle+(endAngle-startAngle)/2) - 10;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(X, Y, 30, 20)];
        label.text = x_names[i];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = RGBACOLOR(13, 195, 176,1);
        [self addSubview:label];
        
        
        //渲染
        CAShapeLayer *shapeLayer=[CAShapeLayer layer];
        shapeLayer.lineWidth = 1;
        shapeLayer.fillColor = RandomColor.CGColor;
        shapeLayer.path = bezierPath.CGPath;
        [self.layer addSublayer:shapeLayer];
        
        startAngle = endAngle;
        
    }
    
    
    
}







/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
