//
//  CityTwoCate.m
//  CardLeap
//
//  Created by songweiping on 14/12/26.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "CityTwoCate.h"

@implementation CityTwoCate

/**
 *  提供一个类方法初始化模型
 *
 *  @param dict 转换的字典
 *
 *  @return     返回模型数据
 */
+ (instancetype)cityTwoCateWith:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

/**
 *  字典模型初始化方法
 *
 *  @param dict     需要转换的字典
 *
 *  @return         返回模型数据
 */
- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        self.cat_id       = dict[@"cat_id"];
        self.cat_name     = dict[@"cat_name"];
    }
    return self;
}
@end
