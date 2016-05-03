//
//  PublicAndPrivateMessageFrame.m
//  CardLeap
//
//  Created by songweiping on 15/1/29.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "PublicAndPrivateMessageFrame.h"

#define padding 10

@implementation PublicAndPrivateMessageFrame



/**
 *  PublicAndPrivateMessage 数据模型的 set 方法 设置 控件的frame
 *
 *  @param message
 */
- (void)setMessage:(PublicAndPrivateMessage *)message {
    
    _message = message;
    
    // 详情的frame
    CGFloat descX = padding;
    CGFloat descY = 0;
    CGFloat descW = 280;
    CGFloat descH = 30;
    self.messageDescViewFrame = CGRectMake(descX, descY, descW, descH);
    
    // 时间的frame
    CGFloat timeX = descX;
    CGFloat timeY = CGRectGetMaxY(self.messageDescViewFrame);
    CGFloat timeW = descW;
    CGFloat timeH = descH;
    self.messageAddTimeViewFrame = CGRectMake(timeX, timeY, timeW, timeH);
    
    // 已读未读的 frame
    CGFloat imageX = CGRectGetMaxX(self.messageDescViewFrame) + padding / 2;
    CGFloat imageY = padding;
    CGFloat imageW = 10;
    CGFloat imageH = 10;
    self.messageIsReadViewFrame = CGRectMake(imageX, imageY, imageW, imageH);
}

@end
