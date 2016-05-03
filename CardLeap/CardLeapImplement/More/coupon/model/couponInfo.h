//
//  couponInfo.h
//  CardLeap
//
//  Created by lin on 1/7/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface couponInfo : NSObject

@property (strong, nonatomic) NSString *user_end_time;
@property (strong, nonatomic) NSString *shop_id;
@property (strong, nonatomic) NSString *message_url;
@property (strong, nonatomic) NSString *spike_pic;
@property (strong, nonatomic) NSString *spike_name;
@property (strong, nonatomic) NSString *spike_num;
@property (strong, nonatomic) NSString *spike_lastnum;
@property (strong, nonatomic) NSString *spike_brief;
@property (strong, nonatomic) NSString *spike_begin_time;
@property (strong, nonatomic) NSString *spike_end_time;
@property (strong, nonatomic) NSString *spike_desc;
@property (strong, nonatomic) NSString *begin_hour;
@property (strong, nonatomic) NSString *end_hour;
@property (strong, nonatomic) NSString *shop_address;
@property (strong, nonatomic) NSString *shop_name;
@property (strong, nonatomic) NSString *down;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSString *spike_id;
@property (strong, nonatomic) NSString *share_url;

-(id)initWithDictionary:(NSDictionary*)dic;

@end
