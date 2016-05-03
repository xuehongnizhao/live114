//
//  couponInfo.m
//  CardLeap
//
//  Created by lin on 1/7/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "couponInfo.h"

@implementation couponInfo

@synthesize user_end_time = _user_end_time;
@synthesize shop_id = _shop_id;
@synthesize message_url = _message_url;
@synthesize spike_pic = _spike_pic;
@synthesize spike_name = _spike_name;
@synthesize spike_num = _spike_num;
@synthesize spike_lastnum = _spike_lastnum;
@synthesize spike_brief = _spike_brief;
@synthesize spike_begin_time = _spike_begin_time;
@synthesize spike_end_time = _spike_end_time;
@synthesize spike_desc = _spike_desc;
@synthesize begin_hour = _begin_hour;
@synthesize end_hour = _end_hour;
@synthesize shop_address = _shop_address;
@synthesize shop_name = _shop_name;
@synthesize down = _down;
@synthesize distance = _distance;
@synthesize spike_id = _spike_id;
@synthesize share_url = _share_url;
-(id)initWithDictionary:(NSDictionary*)dic
{
    if (!self) {
        self = [[couponInfo alloc] init];
    }
    
    _user_end_time = [NSString stringWithFormat:@"%@",dic[@"use_end_time"]];
    _shop_id = [NSString stringWithFormat:@"%@",dic[@"shop_id"]];
    _message_url = [NSString stringWithFormat:@"%@",dic[@"message_url"]];
    _spike_pic = [NSString stringWithFormat:@"%@",dic[@"spike_pic"]];
    _spike_name = [NSString stringWithFormat:@"%@",dic[@"spike_name"]];
    _spike_num = [NSString stringWithFormat:@"%@",dic[@"spike_num"]];
    _spike_lastnum = [NSString stringWithFormat:@"%@",dic[@"spike_lastnum"]];
    _spike_brief = [NSString stringWithFormat:@"%@",dic[@"spike_brief"]];
    _spike_begin_time = [NSString stringWithFormat:@"%@",dic[@"spike_begin_time"]];
    _spike_end_time = [NSString stringWithFormat:@"%@",dic[@"spike_endtime"]];
    _spike_desc = [NSString stringWithFormat:@"%@",dic[@"spike_desc"]];
    _begin_hour = [NSString stringWithFormat:@"%@",dic[@"begin_hour"]];
    _end_hour = [NSString stringWithFormat:@"%@",dic[@"end_hour"]];
    _shop_address = [NSString stringWithFormat:@"%@",dic[@"shop_address"]];
    _shop_name = [NSString stringWithFormat:@"%@",dic[@"shop_name"]];
    _down = [NSString stringWithFormat:@"%@",dic[@"down"]];
    _distance = [NSString stringWithFormat:@"%@",dic[@"distance"]];
    _spike_id = [NSString stringWithFormat:@"%@",dic[@"spike_id"]];
    _share_url = [NSString stringWithFormat:@"%@",dic[@"share_url"]];
    return self;
}

@end
