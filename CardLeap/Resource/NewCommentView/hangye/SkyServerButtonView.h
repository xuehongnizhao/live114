//
//  SkyServerButtonView.h
//  cityo2o
//
//  Created by hm－02 on 15/7/8.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkyServerButtonView : UIView

/**
 *  给buttonview设置图片和相应的名称
 *
 *  @param url   图片地址
 *  @param title 名称
 */
-(void)setButtonImageurl:(NSString*)url andTitle:(NSString*)title;


/**
 *  为button添加target
 *
 *  @param view     给哪个类添加监听
 *  @param selector 选择器
 */
-(void)addTarget:(id)view action:(SEL)selector;


/**
 *  为buttonview中的button添加tag值
 *
 *  @param tag tag值
 */
-(void)setButtonViewTag:(NSInteger) tag;

@end
