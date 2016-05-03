//
//  takeoutDishInfo.m
//  CardLeap
//
//  Created by lin on 12/29/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "takeoutDishInfo.h"

@implementation takeoutDishInfo
@synthesize take_id = _take_id;
@synthesize pay_num = _pay_num;
@synthesize score = _score;
@synthesize take_name = _take_name;
@synthesize take_pic = _take_pic;
@synthesize take_price = _take_price;
@synthesize review_url = _review_url;

-(id)initWithDictionary :(NSDictionary*)dict
{
    if (!self) {
        self = [[takeoutDishInfo alloc] init];
    }
    self.count = 0;
    _take_id = [NSString stringWithFormat:@"%@",dict[@"take_id"]];
    _pay_num = [NSString stringWithFormat:@"%@",dict[@"pay_num"]];
    _score = [NSString stringWithFormat:@"%@",dict[@"score"]];
    _take_name = [NSString stringWithFormat:@"%@",dict[@"take_name"]];
    _take_pic = [NSString stringWithFormat:@"%@",dict[@"take_pic"]];
    _take_price = [NSString stringWithFormat:@"%@",dict[@"take_price"]];
    _review_url = [NSString stringWithFormat:@"%@",dict[@"review_url"]];
    return self;
}
@end
