//
//  PieChartView.m
//  PieChartView
//
//  Created by CSX on 2017/2/25.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import "PieChartView.h"


#define MARGIN            30   // 坐标轴与画布间距
#define Y_EVERY_MARGIN    5   // y轴的间隔数量
#define X_MARGIN          30  //默认情况下的x轴两数据之间的间隔,如果自动生成x轴坐标间的间距为yes，那么这个不起效果

static CGRect myFrame;

// 随机色
#define RandomColor  RGBACOLOR(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256),1)
// 颜色RGB
#define RGBACOLOR(r, g, b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]


/*
 UIBezierPath ：画贝塞尔曲线的path类
 UIBezierPath定义 ： 贝赛尔曲线的每一个顶点都有两个控制点，用于控制在该顶点两侧的曲线的弧度。
 曲线的定义有四个点：起始点、终止点（也称锚点）以及两个相互分离的中间点。
 滑动两个中间点，贝塞尔曲线的形状会发生变化。
 UIBezierPath ：对象是CGPathRef数据类型的封装，可以方便的让我们画出 矩形 、 椭圆 或者 直线和曲线的组合形状
 
 初始化方法：
 + (instancetype)bezierPath;
 
 //创建一个矩形
 + (instancetype)bezierPathWithRect:(CGRect)rect;
 
 //创建圆形或者椭圆形
 + (instancetype)bezierPathWithOvalInRect:(CGRect)rect;
 + (instancetype)bezierPathWithRoundedRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius; // rounds all corners with the same horizontal and vertical radius
 + (instancetype)bezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;
 + (instancetype)bezierPathWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;
 + (instancetype)bezierPathWithCGPath:(CGPathRef)CGPath;
 
 最基本的使用方法是：
 //设置描绘的起点
 - (void)moveToPoint:(CGPoint)point;
 
 //画直线
 - (void)addLineToPoint:(CGPoint)point;
 
 //画曲线
 (1)绘制二次贝塞尔曲线   分别对应终点和一个控制点
 - (void)addQuadCurveToPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint
 
 (1)绘制三次贝塞尔曲线   分别对应终点和两个控制点
 - (void)addCurveToPoint:(CGPoint)endPoint controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2;
 
 //画圆弧
 - (void)addArcWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise
 
 使用贝塞尔曲线的基本步骤是：
 (1）创建一个Bezier path对象。
 （2）使用方法moveToPoint:去设置初始线段的起点。
 （3）添加line或者curve去定义一个或者多个subpaths。
 （4）改变UIBezierPath对象跟绘图相关的属性。
 */
@implementation PieChartView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {    
//        self.frame = frame;
        myFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    return self;
}

//初始化画布
+(instancetype)PieViewWithFrame:(CGRect)frame{
    return [[PieChartView alloc]initWithFrame:frame];
}

/*
   画饼状图
   @param x_values      x轴值的所有值名称
   @param targetValues 所有目标值
 */

-(void)drawPieChartViewWithXNames_Value:(NSMutableArray *)x_values TargetValues:(NSMutableArray *)targetValues{
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
        label.text = x_values[i];
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
  画折线图
 */

-(void)drawLineChartViewWithXNames_Value:(NSMutableArray *)x_values TargetValues:(NSMutableArray *)targetValues LineType:(LineType) lineType WithIsCombine:(BOOL)isCombine WithXMagin:(CGFloat)xMagin{
    
    static CGFloat maxY = 0;
    
    for (NSString *numberStr in targetValues) {
        CGFloat doubleValue = [numberStr floatValue];
        maxY = MAX(maxY, doubleValue);
    }
    
    if (!isCombine) {
        //1.画坐标轴
        [self drawXYLine:x_values WithMaxY:maxY WithXMagin:xMagin]; //如果需要这里替换成调用画柱状图的方法，合二为一
    }
    
    //2.获取目标值点坐标
    NSMutableArray *allPoints = [NSMutableArray array];
    for (int i=0; i<targetValues.count; i++) {
        CGFloat doubleValue = [targetValues[i] floatValue]; //
        CGFloat X = MARGIN + xMagin*(i+1);
        CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-((CGRectGetHeight(myFrame)-2*MARGIN)/maxY*doubleValue);
        CGPoint point = CGPointMake(X,Y);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x-1, point.y-1, 2.5, 2.5) cornerRadius:2.5];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = [UIColor purpleColor].CGColor;
        layer.fillColor = [UIColor purpleColor].CGColor;
        layer.path = path.CGPath;
        [self.layer addSublayer:layer];
        [allPoints addObject:[NSValue valueWithCGPoint:point]];
    }
    
    //3.坐标连线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:[allPoints[0] CGPointValue]];
    CGPoint PrePonit;
    switch (lineType) {
        case LineType_Straight: //直线
            for (int i =1; i<allPoints.count; i++) {
                CGPoint point = [allPoints[i] CGPointValue];
                [path addLineToPoint:point];
            }
            break;
        case LineType_Curve:   //曲线
            for (int i =0; i<allPoints.count; i++) {
                if (i==0) {
                    PrePonit = [allPoints[0] CGPointValue];
                }else{
                    CGPoint NowPoint = [allPoints[i] CGPointValue];
                    [path addCurveToPoint:NowPoint controlPoint1:CGPointMake((PrePonit.x+NowPoint.x)/2, PrePonit.y) controlPoint2:CGPointMake((PrePonit.x+NowPoint.x)/2, NowPoint.y)]; //三次曲线
                    PrePonit = NowPoint;
                }
            }
            break;
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 2.0;
    [self.layer addSublayer:shapeLayer];
    
    //4.添加目标值文字
    for (int i =0; i<allPoints.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor purpleColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [self addSubview:label];
        
        if (i==0) {
            CGPoint NowPoint = [allPoints[0] CGPointValue];
            label.text = targetValues[i];
            label.frame = CGRectMake(NowPoint.x-xMagin/2, NowPoint.y-20, xMagin, 20);
            PrePonit = NowPoint;
        }else{
            CGPoint NowPoint = [allPoints[i] CGPointValue];
            if (NowPoint.y<PrePonit.y) {  //文字置于点上方
                label.frame = CGRectMake(NowPoint.x-xMagin/2, NowPoint.y-20, xMagin, 20);
            }else{ //文字置于点下方
                label.frame = CGRectMake(NowPoint.x-xMagin/2, NowPoint.y, xMagin, 20);
            }
            label.text = targetValues[i];
            PrePonit = NowPoint;
        }
    }
}


/*
   画柱状图
 */

-(void)drawBarGraphViewWithXNames_Value:(NSMutableArray *)x_values TargetValues:(NSMutableArray *)targetValues WithIsCombine:(BOOL)isCombine WithXMagin:(CGFloat)xMagin{
    
    static CGFloat maxY = 0;
    
    for (NSString *numberStr in targetValues) {
        CGFloat doubleValue = [numberStr floatValue];
        maxY = MAX(maxY, doubleValue);
    }
    
    if (!isCombine) {
        //1.画坐标轴
        [self drawXYLine:x_values WithMaxY:maxY WithXMagin:xMagin];   //根据需要同上处理
    }

//    小矩形的宽度
    static CGFloat barlittleWidth = 20.0;
    //2.每一个目标值点坐标
    for (int i=0; i<targetValues.count; i++) {
        CGFloat doubleValue = [targetValues[i] floatValue]; //目标值转换
        CGFloat X = MARGIN + xMagin*(i+1);
        CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-((CGRectGetHeight(myFrame)-2*MARGIN)*(doubleValue/maxY));
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(X-barlittleWidth/2, Y, barlittleWidth, (CGRectGetHeight(myFrame)-2*MARGIN)/maxY*doubleValue)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        shapeLayer.fillColor = RandomColor.CGColor;
        shapeLayer.borderWidth = 2.0;
        [self.layer addSublayer:shapeLayer];
        
        //3.添加文字
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(X-xMagin/2, Y-20, xMagin, 20)];
        label.text = targetValues[i];
        label.textColor = [UIColor purpleColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [self addSubview:label];
    }
}


-(void)drawLineChartViewWithXNames_Value:(NSMutableArray *)x_values TargetValues:(NSMutableArray *)targetValues LineType:(LineType) lineType WithIsAutoXMagin:(BOOL)isAuto{
    static CGFloat xMagin = 0;
    if (isAuto) {
        xMagin = (CGRectGetWidth(myFrame)-2*MARGIN)/x_values.count;
    }else{
        xMagin = X_MARGIN;
    }
    [self drawLineChartViewWithXNames_Value:x_values TargetValues:targetValues LineType:lineType WithIsCombine:NO WithXMagin:xMagin];
}
-(void)drawBarGraphViewWithXNames_Value:(NSMutableArray *)x_values TargetValues:(NSMutableArray *)targetValues WithIsAutoXMagin:(BOOL)isAuto{
    static CGFloat xMagin = 0;
    if (isAuto) {
        xMagin = (CGRectGetWidth(myFrame)-2*MARGIN)/x_values.count;
    }else{
        xMagin = X_MARGIN;
    }
    [self drawBarGraphViewWithXNames_Value:x_values TargetValues:targetValues WithIsCombine:NO WithXMagin:xMagin];
}

/*
 画柱状图和折线图的合成图
 */
- (void)drawLineAndBarGraphViewWithNames_Values:(NSMutableArray *)x_values LeftValues:(NSMutableArray *)leftTargetValues AndRightValues:(NSMutableArray *)rightTargetValues LineType:(LineType) lineType WithIsAutoXMagin:(BOOL)isAuto{
    
    static CGFloat leftMaxY = 0;
    for (NSString *numberStr in leftTargetValues) {
        CGFloat doubleValue = [numberStr floatValue];
        leftMaxY = MAX(leftMaxY, doubleValue);
    }
    
    static CGFloat rightMaxY = 0;
    for (NSString *numberStr in rightTargetValues) {
        CGFloat doubleValue = [numberStr floatValue];
        rightMaxY = MAX(rightMaxY, doubleValue);
    }
    
    static CGFloat xMagin = 0;
    if (isAuto) {
        xMagin = (CGRectGetWidth(myFrame)-2*MARGIN)/(x_values.count+1);
    }else{
        xMagin = X_MARGIN;
    }
    [self drawXYLine:x_values WithLeftMaxY:leftMaxY andRightMaxY:rightMaxY WithXMagin:xMagin];
    
    [self drawBarGraphViewWithXNames_Value:x_values TargetValues:leftTargetValues WithIsCombine:YES WithXMagin:xMagin];
    [self drawLineChartViewWithXNames_Value:x_values TargetValues:rightTargetValues LineType:lineType WithIsCombine:YES WithXMagin:xMagin];
}

/*
 画普通坐标轴
 */
- (void)drawXYLine:(NSMutableArray *)x_names WithMaxY:(CGFloat)maxY WithXMagin:(CGFloat)xMagin{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //1.x y轴的直线
    [path moveToPoint:CGPointMake(MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN, MARGIN-10)];
    [path moveToPoint:CGPointMake(MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN+15, CGRectGetHeight(myFrame)-MARGIN)];
    
    //2.添加箭头
    [path moveToPoint:CGPointMake(MARGIN, MARGIN-10)];
    [path addLineToPoint:CGPointMake(MARGIN-5, MARGIN+5-10)];
    [path moveToPoint:CGPointMake(MARGIN, MARGIN-10)];
    [path addLineToPoint:CGPointMake(MARGIN+5, MARGIN+5-10)];
    
    [path moveToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN+15, CGRectGetHeight(myFrame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN-5+15, CGRectGetHeight(myFrame)-MARGIN-5)];
    [path moveToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN+15, CGRectGetHeight(myFrame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN-5+15, CGRectGetHeight(myFrame)-MARGIN+5)];
    
    //3.添加索引格
    //X轴
    for (int i=0; i<x_names.count; i++) {
        CGFloat X = MARGIN + xMagin*(i+1);
        CGPoint point = CGPointMake(X,CGRectGetHeight(myFrame)-MARGIN);
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x, point.y-3)];
    }
    //Y轴
    for (int i=0; i<Y_EVERY_MARGIN+1; i++) {
        CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-((CGRectGetHeight(myFrame)-2*MARGIN)/Y_EVERY_MARGIN)*i;
        CGPoint point = CGPointMake(MARGIN,Y);
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x+3, point.y)];
    }
    
    //4.添加索引格文字
    //X轴
    for (int i=0; i<x_names.count; i++) {
        CGFloat X = MARGIN + xMagin/2 + xMagin*i;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(X, CGRectGetHeight(myFrame)-MARGIN, xMagin, 20)];
        textLabel.text = x_names[i];
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor blueColor];
        [self addSubview:textLabel];
    }
    //Y轴
    for (int i=0; i<Y_EVERY_MARGIN+1; i++) {
        CGFloat Y = CGRectGetHeight(myFrame)-MARGIN-((CGRectGetHeight(myFrame)-2*MARGIN)/Y_EVERY_MARGIN)*i;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Y-5, MARGIN, 10)];
        textLabel.text = [NSString stringWithFormat:@"%.0f",(maxY/Y_EVERY_MARGIN)*i];
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor redColor];
        [self addSubview:textLabel];
    }
    
    //5.渲染路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 2.0;
    [self.layer addSublayer:shapeLayer];
    
}
/*
 画双y轴的坐标轴
 */
- (void)drawXYLine:(NSMutableArray *)x_names WithLeftMaxY:(CGFloat)leftMaxY andRightMaxY:(CGFloat)rightMaxY WithXMagin:(CGFloat)xMagin{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //1.x y轴的直线
    [path moveToPoint:CGPointMake(MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN, MARGIN-10)];
    [path moveToPoint:CGPointMake(MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    [path addLineToPoint:CGPointMake(MARGIN+CGRectGetWidth(myFrame)-2*MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    [path moveToPoint:CGPointMake(CGRectGetWidth(myFrame)-MARGIN, CGRectGetHeight(myFrame)-MARGIN)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame)-MARGIN, MARGIN-10)];
    //2.添加箭头
    [path moveToPoint:CGPointMake(MARGIN, MARGIN-10)];
    [path addLineToPoint:CGPointMake(MARGIN-5, MARGIN+5-10)];
    [path moveToPoint:CGPointMake(MARGIN, MARGIN-10)];
    [path addLineToPoint:CGPointMake(MARGIN+5, MARGIN+5-10)];
    
    [path moveToPoint:CGPointMake(CGRectGetWidth(myFrame)-MARGIN, MARGIN-10)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame)-MARGIN-5, MARGIN-10+5)];
    [path moveToPoint:CGPointMake(CGRectGetWidth(myFrame)-MARGIN, MARGIN-10)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame)-MARGIN-5, MARGIN-10+5)];
    
    //3.添加索引格
    //X轴
    for (int i=0; i<x_names.count; i++) {
        CGFloat X = MARGIN + xMagin*(i+1);
        CGPoint point = CGPointMake(X,CGRectGetHeight(myFrame)-MARGIN);
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x, point.y-3)];
    }
    //Y轴（实际长度为200,此处比例缩小一倍使用）
    for (int i=0; i<Y_EVERY_MARGIN+1; i++) {
        CGFloat leftY = CGRectGetHeight(myFrame)-MARGIN-((CGRectGetHeight(myFrame)-2*MARGIN)/Y_EVERY_MARGIN)*i;
        CGPoint point = CGPointMake(MARGIN,leftY);
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x+3, point.y)];
        
        CGFloat rightY = CGRectGetHeight(myFrame)-MARGIN-((CGRectGetHeight(myFrame)-2*MARGIN)/Y_EVERY_MARGIN)*i;
        CGPoint pointRight = CGPointMake(CGRectGetWidth(myFrame)-MARGIN,rightY);
        [path moveToPoint:pointRight];
        [path addLineToPoint:CGPointMake(pointRight.x-3, pointRight.y)];
    }
    
    //4.添加索引格文字
    //X轴
    for (int i=0; i<x_names.count; i++) {
        CGFloat X = MARGIN + xMagin/2 + xMagin*i;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(X, CGRectGetHeight(myFrame)-MARGIN, xMagin, 20)];
        textLabel.text = x_names[i];
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor blueColor];
        [self addSubview:textLabel];
    }
    //Y轴
    for (int i=0; i<Y_EVERY_MARGIN+1; i++) {
        CGFloat leftY = CGRectGetHeight(myFrame)-MARGIN-((CGRectGetHeight(myFrame)-2*MARGIN)/Y_EVERY_MARGIN)*i;
        UILabel *leftTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, leftY-5, MARGIN, 10)];
        leftTextLabel.text = [NSString stringWithFormat:@"%.0f",(leftMaxY/Y_EVERY_MARGIN)*i];
        leftTextLabel.font = [UIFont systemFontOfSize:10];
        leftTextLabel.textAlignment = NSTextAlignmentCenter;
        leftTextLabel.textColor = [UIColor redColor];
        [self addSubview:leftTextLabel];
        
        CGFloat rightY = CGRectGetHeight(myFrame)-MARGIN-((CGRectGetHeight(myFrame)-2*MARGIN)/Y_EVERY_MARGIN)*i;
        UILabel *rightTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(myFrame)-MARGIN, rightY-5, MARGIN, 10)];
        rightTextLabel.text = [NSString stringWithFormat:@"%.0f",(rightMaxY/Y_EVERY_MARGIN)*i];
        rightTextLabel.font = [UIFont systemFontOfSize:10];
        rightTextLabel.textAlignment = NSTextAlignmentCenter;
        rightTextLabel.textColor = [UIColor redColor];
        [self addSubview:rightTextLabel];
        
    }
    
    //5.渲染路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 2.0;
    [self.layer addSublayer:shapeLayer];
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
