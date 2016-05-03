//
//  shopDetailInfo.h
//  CardLeap
//
//  Created by lin on 12/22/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shopDetailInfo : NSObject
@property (strong, nonatomic) NSString *group_num;
@property (strong, nonatomic) NSString *num;
@property (strong, nonatomic) NSString *rev_type;
@property (strong, nonatomic) NSArray  *review_index;
@property (strong, nonatomic) NSString *socre;
@property (strong, nonatomic) NSString *shop_action;
@property (strong, nonatomic) NSString *shop_address;
@property (strong, nonatomic) NSString *shop_desc;
@property (strong, nonatomic) NSString *shop_id;
@property (strong, nonatomic) NSString *shop_name;
@property (strong, nonatomic) NSString *shop_pic;
@property (strong, nonatomic) NSArray  *shop_pic_list;
@property (strong, nonatomic) NSString *shop_pic_num;
@property (strong, nonatomic) NSString *shop_tel;
@property (strong, nonatomic) NSString *spike_num;
@property (strong, nonatomic) NSString *takeout_num;
@property (strong, nonatomic) NSString *collection;
@property (strong, nonatomic) NSString *event_num;
@property (strong, nonatomic) NSString *share_url;
@property (strong, nonatomic) NSString *shop_brief;
@property (strong, nonatomic) NSString *shop_lat;
@property (strong, nonatomic) NSString *shop_lng;
/** 2016.1.12 添加商家详情URL  */
@property (nonatomic, strong) NSString * message_url;
-(id)initWithDictionary :(NSDictionary*)dic;
@end
