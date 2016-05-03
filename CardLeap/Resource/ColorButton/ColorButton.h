//
//  ColorButton.h
//  btn
//
//  Created by LYZ on 14-1-10.
//  Copyright (c) 2014年 LYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 使用：
 NSMutableArray *colorArray = [@[[UIColor colorWithRed:0.3 green:0.278 blue:0.957 alpha:1],[UIColor colorWithRed:0.114 green:0.612 blue:0.843 alpha:1]] mutableCopy];
	ColorButton *btn = [[ColorButton alloc]initWithFrame:CGRectMake(100, 100, 150, 50) FromColorArray:colorArray ByGradientType:topToBottom];
 [btn setTitle:@"Title" forState:UIControlStateNormal];
 [self.view addSubview:btn];
 */
typedef enum  {
    topToBottom = 0,//从上到小
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
}GradientType;

@interface ColorButton : UIButton

//!@brief 建议颜色设置为2个相近色为佳，设置3个相近色能形成拟物化的凸起感
- (id)initWithFrame:(CGRect)frame FromColorArray:(NSMutableArray*)colorArray ByGradientType:(GradientType)gradientType;

@end
