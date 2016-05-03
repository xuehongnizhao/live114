//
//  CityList.h
//  CardLeap
//
//  Created by songweiping on 14/12/26.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityList : NSObject


@property (copy, nonatomic) NSString *m_id;

/** 同城列表图片 */
@property (copy, nonatomic) NSString *message_pic;

/** 同城列表名称 */
@property (copy, nonatomic) NSString *message_name;

/** 同城列表详情 */
@property (copy, nonatomic) NSString *m_desc;

/** 同城列表时间 */
@property (copy, nonatomic) NSString *add_time;

/** 同城列表价格 */
@property (copy, nonatomic) NSString *price;


+ (instancetype) cityListWithDict:(NSDictionary *)dict;
- (instancetype) initWithDict:(NSDictionary *)dict;

@end
