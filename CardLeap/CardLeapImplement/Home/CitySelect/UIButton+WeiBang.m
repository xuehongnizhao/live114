//
//  UIButton+WeiBang.m
//  WeiBang
//
//  Created by songweipng on 15/3/3.
//  Copyright (c) 2015年 songweipng. All rights reserved.
//

#import "UIButton+WeiBang.h"

@implementation UIButton (WeiBang)


/**
 *  设置按钮的基本属性
 *
 *  @param button 需要设置的按钮
 *  @param title  按钮的文字
 *  @param size   字体大小
 *  @param color  字体默认颜色
 *  @param target 目标
 *  @param action 监听方法
 *  @param tag    按钮的标识
 */
- (void) settingButton:(UIButton *)button setTitle:(NSString *)title fontSize:(CGFloat)size fontColor:(UIColor *)color target:(id)target action:(SEL)action buttonTag:(NSInteger)tag {
    
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  设置提交按钮的基本属性
 *
 *  @param button          需要设置的按钮
 *  @param backgroundColor 按钮的背景色
 *  @param title           按钮的文字
 *  @param size            字体大小
 *  @param fontColor       字体颜色
 *  @param target          目标
 *  @param action          监听方法
 *  @param tag             按钮的标识
 */
- (void) settingSubmitButton:(UIButton *)button backgroundColor:(UIColor *)backgroundColor setTitle:(NSString *)title fontSize:(CGFloat)size fontColor:(UIColor *)fontColor target:(id)target action:(SEL)action buttonTag:(NSInteger)tag {
    
    button.layer.cornerRadius  = 2 / 1.0;
    button.layer.masksToBounds = YES;
    button.tag                 = tag;
    button.backgroundColor     = backgroundColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    [button setTitleColor:fontColor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


/**
 *  设置按钮为 checkBox
 *
 *  @param button           设置的按钮
 *  @param title            按钮名称
 *  @param imageName        默认图片
 *  @param selectedImagName 勾选图片
 *  @param size             字体大小
 *  @param color            字体颜色
 *  @param imageEdgeInsets  图片文字边距
 *  @param target           目标
 *  @param action           监听方法
 *  @param tag              按钮的标识
 */
- (void) settingCheckBox:(UIButton *)button setTitle:(NSString *)title imageName:(NSString *)imageName selectedImage:(NSString *)selectedImagName fontSize:(CGFloat)size setTitleColor:(UIColor *)color imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets target:(id)target action:(SEL)action buttonTag:(NSInteger)tag  {
    
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImagName] forState:UIControlStateSelected];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = imageEdgeInsets;
}

@end
