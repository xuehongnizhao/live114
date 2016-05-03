//
//  PublicAndPrivateMessageFrame.h
//  CardLeap
//
//  Created by songweiping on 15/1/29.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PublicAndPrivateMessage;
@interface PublicAndPrivateMessageFrame : NSObject


/** 公信 / 私信 显示详情的View的Frame */
@property (assign, nonatomic) CGRect messageDescViewFrame;

/** 公信 / 私信 显示时间的View的Frame */
@property (assign, nonatomic) CGRect messageAddTimeViewFrame;

/** 公信 / 私信 显示是否已读状态的Frame */
@property (assign, nonatomic) CGRect messageIsReadViewFrame;

/** 公信 / 私信 数据模型 */
@property (strong, nonatomic) PublicAndPrivateMessage *message;

@end
