//
//  CityList.m
//  CardLeap
//
//  Created by songweiping on 14/12/26.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "CityList.h"

@implementation CityList


/**
 *  字典转模型方法 初始化模型数据
 *
 *  @param dict 转换的模型数据
 *
 *  @return     返回模型数据
 */
+ (instancetype) cityListWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

/**
 *  字典转换    模型方法
 *
 *  @param dict 转换的模型数据
 *
 *  @return     返回模型数据
 */
- (instancetype) initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.m_id         = dict[@"m_id"];
        self.message_pic  = dict[@"message_pic"];
        self.message_name = dict[@"message_name"];
        self.m_desc       = dict[@"m_desc"];
        self.add_time     = dict[@"add_time"];
        self.price        = dict[@"price"];
    }
    
    return self;
}

@end
