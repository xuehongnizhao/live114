//
//  ROllLabel.m
//  RollLabel
//
//  Created by zhouxl on 12-11-2.
//  Copyright (c) 2012年 zhouxl. All rights reserved.
//


#import "ROllLabel.h"
typedef NS_ENUM(NSInteger, Direction) {
    directionLeft ,
    directionRight
};
@implementation ROllLabel
{
    int pos_x;
    int widthPix;
    Direction *direction;
    NSTimer *timer;
}
- (id)initWithFrame:(CGRect)frame Withsize:(CGSize)size
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator   = NO;
        self.showsHorizontalScrollIndicator = NO;//水平滚动条
        self.userInteractionEnabled = NO;
        self.bounces = NO;
        widthPix = frame.size.width;
        self.contentSize = size;//滚动大小
        self.backgroundColor = [UIColor clearColor];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        pos_x = 0;
        direction = directionRight;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0;
        //判断是否开启自动滚动功能
        NSLog(@"%f",size.width);
        if (size.width <= widthPix) {
            [timer invalidate];
        }
    }
    return self;
}

#pragma mark------自动滚动
-(void)onTimer
{
    if (direction == directionRight) {
        pos_x += 3;
        if (pos_x > (self.contentSize.width-widthPix+10) ) {
            direction = directionLeft;
        }
    }else{
        pos_x -= 3;
        if (pos_x < -10) {
            direction = directionRight;
        }
    }
    [self setContentOffset:CGPointMake(pos_x, 0) animated:YES];
}

+ (void)rollLabelTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font superView:(UIView *)superView fram:(CGRect)rect
{
    //文字大小，设置label的大小和uiscroll的大小
    CGSize size = [title  sizeWithFont:font constrainedToSize:kConstrainedSize lineBreakMode:NSLineBreakByWordWrapping];
    CGRect frame = CGRectMake(0, 0, size.width, rect.size.height);
    ROllLabel *roll = [[ROllLabel alloc]initWithFrame:rect Withsize:size];
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = title;
    label.font = font;
    label.textColor = color;
    [roll addSubview:label];
    [label release];
    [superView addSubview:roll];
    [roll release];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
