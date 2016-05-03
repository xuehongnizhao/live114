//
//  groupInfo.h
//  CardLeap
//
//  Created by mac on 15/1/23.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface groupInfo : NSObject
@property (strong, nonatomic) NSString *score;
@property (strong, nonatomic) NSString *group_people;
@property (strong, nonatomic) NSString *message_url;
@property (strong, nonatomic) NSString *area_id;
@property (strong, nonatomic) NSString *cat_id;
@property (strong, nonatomic) NSString *begin_hour;
@property (strong, nonatomic) NSString *end_hour;
@property (strong, nonatomic) NSString *shop_address;
@property (strong, nonatomic) NSString *shop_name;
@property (strong, nonatomic) NSString *shop_tel;
@property (strong, nonatomic) NSString *shop_lng;
@property (strong, nonatomic) NSString *shop_lat;
@property (strong, nonatomic) NSString *group_name;
@property (strong, nonatomic) NSString *group_brief;
@property (strong, nonatomic) NSString *group_endtime;
@property (strong, nonatomic) NSString *now_price;
@property (strong, nonatomic) NSString *before_price;
@property (strong, nonatomic) NSString *group_id;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSString *end_time;
@property (strong, nonatomic) NSString *pic;
@property (strong, nonatomic) NSString *review_people;
@property (strong, nonatomic) NSString *shop_id;
@property (strong, nonatomic) NSArray *pic_list;
@property (strong, nonatomic) NSString *group_cate;
@property (strong, nonatomic) NSString *group_url;
-(id)initWithDictionary:(NSDictionary*)dic;
@end
