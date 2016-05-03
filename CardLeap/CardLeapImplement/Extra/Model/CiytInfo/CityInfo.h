//
//  CityInfo.h
//  CardLeap
//
//  Created by songweiping on 14/12/29.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityInfo : NSObject


/** 联系人 */
@property (copy, nonatomic)     NSString *contact;

/** 跳转web的url */
@property (copy, nonatomic)     NSString *message_url;

/** 联系电话 */
@property (copy, nonatomic)     NSString *tel;

/** 轮播图片数组 */
@property (strong, nonatomic)   NSArray  *city_pic;


+ (instancetype) cityInoftWithDict:(NSDictionary *)dict;
- (instancetype) initWithDict:(NSDictionary *)dict;

@end
