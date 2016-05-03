//
//  EvenMoreFeedback.h
//  CardLeap
//
//  Created by songweiping on 15/1/26.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvenMoreFeedback : NSObject

/** 反馈时间 */
@property (copy, nonatomic) NSString *add_time;
/** 反馈详情 */
@property (copy, nonatomic) NSString *feed_desc;
/** 反馈ID */
@property (copy, nonatomic) NSString *feed_id;
/** 用户ID */
@property (copy, nonatomic) NSString *u_id;
/** 反馈是否恢复 */
@property (copy, nonatomic) NSString *is_return;
/** 跳转详情的Url */
@property (copy, nonatomic) NSString *message_url;


+ (instancetype) evenMoreFeedbackWithDict:(NSDictionary *)dict;
- (instancetype) initWithDict:(NSDictionary *)dict;
@end
