//
//  activityInfo.m
//  CardLeap
//
//  Created by lin on 1/9/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "activityInfo.h"

@implementation activityInfo

@synthesize activity_pic = _activity_pic;
@synthesize activity_id = _activity_id;
@synthesize activity_name = _activity_name;
@synthesize begin_time = _begin_time;
@synthesize end_time = _end_time;
@synthesize activity_brief = _activity_brief;
@synthesize activity_desc = _activity_desc;
@synthesize message_url = _message_url;

-(id)initWithDictionary:(NSDictionary*)dic
{
    if(!self){
        self = [[activityInfo alloc] init];
    }
    _activity_pic = [NSString stringWithFormat:@"%@",dic[@"activity_pic"]];
    _activity_id = [NSString stringWithFormat:@"%@",dic[@"activity_id"]];
    _activity_name = [NSString stringWithFormat:@"%@",dic[@"activity_name"]];
    _begin_time = [NSString stringWithFormat:@"%@",dic[@"begin_time"]];
    _end_time = [NSString stringWithFormat:@"%@",dic[@"end_time"]];
    _activity_brief = [NSString stringWithFormat:@"%@",dic[@"activity_brief"]];
    _activity_desc = [NSString stringWithFormat:@"%@",dic[@"activity_desc"]];
    _message_url = [NSString stringWithFormat:@"%@",dic[@"message_url"]];
    return self;
}
@end
