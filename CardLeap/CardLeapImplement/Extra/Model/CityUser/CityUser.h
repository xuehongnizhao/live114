//
//  CityUser.h
//  CardLeap
//
//  Created by songweiping on 15/1/19.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityUser : NSObject

/** 浏览量 */
@property (copy, nonatomic) NSString *browse;

/** 消息名称 */
@property (copy, nonatomic) NSString *message_name;

/** 添加时间 */
@property (copy, nonatomic) NSString *add_time;

/** 消息ID */
@property (copy, nonatomic) NSString *m_id;

/** 详情URL */
@property (copy, nonatomic) NSString *message_url;

/** 分类名称 */
@property (copy, nonatomic) NSString *cate_name;

+ (instancetype) cityUserWithDict:(NSDictionary *)dict;
- (instancetype) initWithDict:(NSDictionary *)dict;


@end
