//
//  mySpikeInfo.m
//  CardLeap
//
//  Created by lin on 1/8/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "mySpikeInfo.h"

@implementation mySpikeInfo
@synthesize is_pay = _is_pay;
@synthesize is_result = _is_result;
@synthesize spike_name = _spike_name;
@synthesize spike_pic = _spike_pic;
@synthesize use_end_time = _use_end_time;
@synthesize message_url = _message_url;
@synthesize is_delete = _is_delete;
@synthesize spike_id = _spike_id;
@synthesize spike_code = _spike_code;
@synthesize share_url = _share_url;
@synthesize is_use = _is_use;

-(id)initWithDictionary:(NSDictionary*)dic
{
    if (!self) {
        self = [[mySpikeInfo alloc] init];
    }
    _is_pay = [NSString stringWithFormat:@"%@",dic[@"is_pay"]];
    _is_result = [NSString stringWithFormat:@"%@",dic[@"is_result"]];
    _spike_name = [NSString stringWithFormat:@"%@",dic[@"spike_name"]];
    _spike_pic = [NSString stringWithFormat:@"%@",dic[@"spike_pic"]];
    _use_end_time = [NSString stringWithFormat:@"%@",dic[@"use_end_time"]];
    _message_url = [NSString stringWithFormat:@"%@",dic[@"message_url"]];
    _spike_id = [NSString stringWithFormat:@"%@",dic[@"spike_id"]];
    _is_delete = @"0";
    _spike_code = [NSString stringWithFormat:@"%@",dic[@"spike_pass"]];
    _share_url = [NSString stringWithFormat:@"%@",dic[@"share_url"]];
    _is_use = [NSString stringWithFormat:@"%@",dic[@"is_use"]];

    return self;
}

@end
