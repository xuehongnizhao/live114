//
//  PublicAndPrivateMessage.m
//  CardLeap
//
//  Created by songweiping on 15/1/29.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "PublicAndPrivateMessage.h"

@implementation PublicAndPrivateMessage


/**
 *  message 模型快速初始化方法
 *
 *  @param dict
 *
 *  @return
 */
+ (instancetype) publicAndPrivateMessageWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
}


/**
 *  message 模型初始化方法 字典转模型
 *
 *  @param dict
 *
 *  @return
 */
- (instancetype) initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        
        self.m_desc      = dict[@"m_desc"];
        self.add_time    = dict[@"add_time"];
        self.is_read     = dict[@"is_read"];
        self.message_url = dict[@"message_url"];
    }
    
    return self;
}


@end
