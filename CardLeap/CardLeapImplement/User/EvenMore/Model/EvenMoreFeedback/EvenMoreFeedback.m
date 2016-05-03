//
//  EvenMoreFeedback.m
//  CardLeap
//
//  Created by songweiping on 15/1/26.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "EvenMoreFeedback.h"

@implementation EvenMoreFeedback


/**
 *  快速创建一个模型数据
 *
 *  @param dict
 *
 *  @return
 */
+ (instancetype) evenMoreFeedbackWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}



/**
 *  字典转模型数据
 *
 *  @param  dict
 *
 *  @return EvenMoreFeedback
 */
- (instancetype) initWithDict:(NSDictionary *)dict {

    if (self = [super init]) {
        self.feed_id     = dict[@"feed_id"];
        self.add_time    = dict[@"add_time"];
        self.feed_desc   = dict[@"feed_desc"];
        self.u_id        = dict[@"u_id"];
        self.is_return   = dict[@"is_return"];
        self.message_url = dict[@"message_url"];
    }
    return self;
}

@end
