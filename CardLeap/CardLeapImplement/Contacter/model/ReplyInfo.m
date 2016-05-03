//
//  ReplyInfo.m
//  CardLeap
//
//  Created by lin on 12/17/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "ReplyInfo.h"

@implementation ReplyInfo
@synthesize user_pic = _user_pic;
@synthesize user_name = _user_name;
@synthesize reply_text = _reply_text;
@synthesize com_text = _com_text;
@synthesize com_url = _com_url;
@synthesize com_id = _com_id;
-(id)initWithDictionary :(NSDictionary*)dic
{
    if (!self)
    {
        self = [[ReplyInfo alloc] init];
    }
    _com_id = [NSString stringWithFormat:@"%@", dic[@"com_id"] ];
    _user_pic = [NSString stringWithFormat:@"%@", dic[@"user_pic"] ];
    _user_name = [NSString stringWithFormat:@"%@", dic[@"user_nickname"] ];
    _reply_text = [NSString stringWithFormat:@"%@", dic[@"rev_text"] ];
    _com_text = [NSString stringWithFormat:@"%@", dic[@"com_text"] ];
    _com_url = [NSString stringWithFormat:@"%@", dic[@"com_pic"] ];
    if (_com_url == nil || [_com_url isKindOfClass:[NSNull class]] || [_com_url isEqualToString:@"(null)"]) {
        _com_url = @"";
    }else{
        _com_text = @"";
    }
    return self;
}
@end
