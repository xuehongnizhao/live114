//
//  ShopListInfo.h
//  CardLeap
//
//  Created by ; on 12/22/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopListInfo : NSObject
@property (strong, nonatomic) NSString *area_name;
@property (strong, nonatomic) NSString *cat_name;
@property (strong, nonatomic) NSString *num;
@property (strong, nonatomic) NSString *score;
@property (strong, nonatomic) NSString *shop_action;
@property (strong, nonatomic) NSString *shop_address;
@property (strong, nonatomic) NSString *shop_id;
@property (strong, nonatomic) NSString *shop_name;
@property (strong, nonatomic) NSString *shop_pic;
@property (strong, nonatomic) NSArray *shop_pic_list;
@property (strong, nonatomic) NSString *shop_pic_num;
@property (strong, nonatomic) NSString *shop_tel;
@property (strong, nonatomic) NSString *shop_desc;
@property (strong, nonatomic) NSString *distace;
@property (strong, nonatomic) NSString *collect;
@property (strong, nonatomic) NSString *shop_lat;
@property (strong, nonatomic) NSString *shop_lng;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSString *group_num;
@property (strong, nonatomic) NSString *spike_num;
@property (strong, nonatomic) NSString *takeout_num;
@property (strong, nonatomic) NSString *activity_num;
@property (strong, nonatomic) NSString *shop_brief;
/** 2016.1.12 商家详情的URL */
@property (nonatomic, strong) NSString * message_url;
-(id)initWithDictionary :(NSDictionary*)dic;
@end
