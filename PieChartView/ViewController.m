//
//  ViewController.m
//  PieChartView
//
//  Created by CSX on 2017/2/25.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import "ViewController.h"
#import "PieChartView.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *x_names = @[@"语文",@"数学",@"英语",@"物理",@"化学",@"生物",@"政治",@"历史",@"地理"].copy;
    NSMutableArray *targets = @[@"20",@"40",@"20",@"50",@"30",@"90",@"30",@"100",@"70"].copy;
    NSMutableArray *rightTargets = @[@"50",@"90",@"60",@"50",@"80",@"90",@"10",@"100",@"70"].copy;
    
    
    PieChartView *pieView = [PieChartView PieViewWithFrame:CGRectMake(0, 180, self.view.frame.size.width, 300)];
//    [[PieChartView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    
//    //饼状图
//    [pieView drawPieChartViewWithXNames_Value:x_names TargetValues:targets];
    
    //折线图
//    [pieView drawLineChartViewWithXNames_Value:x_names TargetValues:targets LineType:LineType_Straight WithIsAutoXMagin:YES];
    
    //柱状图
    [pieView drawBarGraphViewWithXNames_Value:x_names TargetValues:targets WithIsAutoXMagin:YES];
    
    //折线图和柱状图的合并
//    [pieView drawLineAndBarGraphViewWithNames_Values:x_names LeftValues:targets AndRightValues:rightTargets LineType:LineType_Straight WithIsAutoXMagin:YES];
    
    pieView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    [self.view addSubview:pieView];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
