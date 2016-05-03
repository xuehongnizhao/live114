//
//  shopInfo.m
//  CardLeap
//
//  Created by lin on 12/11/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "shopInfo.h"

@implementation shopInfo
@synthesize area_name = _area_name;
@synthesize cat_name = _cat_name;
@synthesize num = _num;
@synthesize score = _score;
@synthesize shop_action = _shop_action;
@synthesize shop_address = _shop_address;
@synthesize shop_id = _shop_id;
@synthesize shop_name = _shop_name;
@synthesize shop_pic = _shop_pic;
@synthesize shop_brief = _shop_brief;
@synthesize shop_lat = _shop_lat;
@synthesize shop_lng = _shop_lng;
@synthesize message_url = _message_url;

-(id)initWithDictionary :(NSDictionary*)dic
{
    if (!self)
    {
        self = [[shopInfo alloc] init];
    }
    _area_name = [NSString stringWithFormat:@"%@", dic[@"area_name"]];
    _cat_name = [NSString stringWithFormat:@"%@", dic[@"cat_name"]];
    _num = [NSString stringWithFormat:@"%@", dic[@"num"]];
    _score = [NSString stringWithFormat:@"%@", dic[@"score"] ];
    _shop_action = [NSString stringWithFormat:@"%@", dic[@"shop_action"]];
    _shop_address = [NSString stringWithFormat:@"%@", dic[@"shop_address"]];
    _shop_id = [NSString stringWithFormat:@"%@", dic[@"shop_id"]];
    _shop_name = [NSString stringWithFormat:@"%@", dic[@"shop_name"] ];
    _shop_pic = [NSString stringWithFormat:@"%@", dic[@"shop_pic"]];
    _shop_brief = [NSString stringWithFormat:@"%@",dic[@"shop_brief"]];
    _shop_lng = [NSString stringWithFormat:@"%@", dic[@"shop_lng"]];
    _shop_lat = [NSString stringWithFormat:@"%@",dic[@"shop_lat"]];
    _message_url = [NSString stringWithFormat:@"%@",dic[@"message_url"]];
    return self;
}
@end
