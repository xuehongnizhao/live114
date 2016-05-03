//
//  BaseViewController.h
//  CardLeap
//
//  Created by Sky on 14/11/21.
//  Copyright (c) 2014年 Sky. All rights reserved.
//
/**
 *  基础viewcontroller 设置背景图片以及相应的title
 */
#import <UIKit/UIKit.h>
#import "TabBarViewController.h"
@interface BaseViewController : UIViewController

/**
 *  根据ttf文件设置navbar的字体
 *
 *  @param navTitle 文字
 *  @param navFont  文字大小
 */
-(void)setNavBarTitle:(NSString*) navTitle withFont:(CGFloat) navFont;
/**
 隐藏tabbar
 */
-(void)setHiddenTabbar :(BOOL)hidden;
/**
 获取tabbar的状态
 */
-(BOOL)getHiddenTabbar;
/**
 隐藏navigationbar
 */
- (void)followScrollView:(UIView*)scrollableView;
@end
