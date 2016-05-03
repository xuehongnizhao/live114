//
//  PublicAndPrivateMessage.h
//  CardLeap
//
//  Created by songweiping on 15/1/29.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicAndPrivateMessage : NSObject


/** 私信/公告 信息详情 */
@property (copy, nonatomic) NSString *m_desc;

/** 私信/公告 添加时间 */
@property (copy, nonatomic) NSString *add_time;

/** 私信/公告 是否已读 已读 1 未读0 */
@property (copy, nonatomic) NSString *is_read;

/** 私信/公告 跳转url */
@property (copy, nonatomic) NSString *message_url;


+ (instancetype) publicAndPrivateMessageWithDict:(NSDictionary *)dict;
- (instancetype) initWithDict:(NSDictionary *)dict;

@end
