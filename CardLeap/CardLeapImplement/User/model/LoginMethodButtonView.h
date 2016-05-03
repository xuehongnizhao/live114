//
//  LoginMethodButtonView.h
//  CardLeap
//
//  Created by lin on 12/15/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol clickButtonDelegate <NSObject>

-(void)clickAction :(NSInteger)tag;

@end

@interface LoginMethodButtonView : UIView
@property (strong, nonatomic) id<clickButtonDelegate> delegate;
/**
 *  为button添加target
 *
 *  @param view     给哪个类添加监听
 *  @param selector 选择器
 */
-(void)addTarget:(id)view action:(SEL)selector;

/**
 获取tag值，区分每一个view的标记
 */
-(NSInteger)getButtonViewTag;
/**
 *  为buttonview中的button添加tag值
 *
 *  @param tag tag值
 */
-(void)setButtonViewTag:(NSInteger) tag;

/**
  设置button的image
 */
-(void)setButtonImage :(NSString*)image text:(NSString*)text;

@end
