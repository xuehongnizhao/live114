//
//  ROllLabel.h
//  RollLabel
//
//  Created by zhouxl on 12-11-2.
//  Copyright (c) 2012年 zhouxl. All rights reserved.
//
/**
 温馨提示：
    该类使用方法如下
     [ROllLabel rollLabelTitle:@"听说这是一个可以滚动的标签是不是真的呀" color:[UIColor grayColor] font:[UIFont systemFontOfSize:12] superView:self.window fram:CGRectMake(40, 40, 120, 30)];
     [ROllLabel rollLabelTitle:@"看看你就知道" color:[UIColor grayColor] font:[UIFont systemFontOfSize:12] superView:self.window fram:CGRectMake(40, 100, 120, 30)];
     [ROllLabel rollLabelTitle:@"这是一个测试的数据，所以必须足够长才可以测试出到底能不能使用这个控件" color:[UIColor grayColor] font:[UIFont systemFontOfSize:12] superView:self.window fram:CGRectMake(40, 150, 120, 30)];
 */

#import <UIKit/UIKit.h>
#define kConstrainedSize CGSizeMake(10000,40)//字体最大
@interface ROllLabel : UIScrollView
/*title,要显示的文字
 *color,文字颜色
 *font , 字体大小
 *superView,要加载标签的视图
 *rect ,标签的frame
 */
+ (void)rollLabelTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font superView:(UIView *)superView fram:(CGRect)rect;
@end
