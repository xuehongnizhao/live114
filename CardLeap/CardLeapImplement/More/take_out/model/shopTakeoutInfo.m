//
//  shopTakeoutInfo.m
//  CardLeap
//
//  Created by lin on 12/26/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "shopTakeoutInfo.h"

@implementation shopTakeoutInfo
@synthesize num = _num;
@synthesize is_ship = _is_ship;
@synthesize shop_id = _shop_id;
@synthesize begin_price = _begin_price;
@synthesize shop_pic = _shop_pic;
@synthesize shop_name = _shop_name;
@synthesize score = _score;
@synthesize cate = _cate;
@synthesize accept_time = _accept_time;
@synthesize shipping = _shipping;
@synthesize timely = _timely;
@synthesize distance = _distance;
@synthesize review_num = _review_num;
@synthesize shop_address = _shop_address;
@synthesize shop_take_desc = _shop_take_desc;
@synthesize shop_price = _shop_price;//送餐费
@synthesize shop_lat = _shop_lat;
@synthesize shop_lng = _shop_lng;

-(id)initWithDic :(NSDictionary*)dic
{
    if (!self) {
        self = [[shopTakeoutInfo alloc] init];
    }
    _num = [NSString stringWithFormat:@"%@", dic[@"num"]];
    _is_ship = [NSString stringWithFormat:@"%@", dic[@"is_ship"]];
    _shop_id = [NSString stringWithFormat:@"%@", dic[@"shop_id"]];
    _begin_price = [NSString stringWithFormat:@"%@", dic[@"begin_price"] ];
    _shop_pic = [NSString stringWithFormat:@"%@", dic[@"shop_pic"]];
    _shop_name = [NSString stringWithFormat:@"%@", dic[@"shop_name"]];
    _score = [NSString stringWithFormat:@"%@", dic[@"score"]];
    _cate = dic[@"cate"];
    _accept_time = [NSString stringWithFormat:@"%@", dic[@"accept_time"]];
    _shipping = [NSString stringWithFormat:@"%@", dic[@"shipping"]];
    _timely = [NSString stringWithFormat:@"%@", dic[@"timely"]];
    _distance = [NSString stringWithFormat:@"%@", dic[@"distance"]];
    _review_num = [NSString stringWithFormat:@"%@", dic[@"review_num"]];
    _shop_address = [NSString stringWithFormat:@"%@", dic[@"shop_address"]];
    _shop_take_desc = [NSString stringWithFormat:@"%@", dic[@"shop_take_desc"]];
    _shop_price = [NSString stringWithFormat:@"%@", dic[@"shipp_price"]];
    _shop_lng = [NSString stringWithFormat:@"%@", dic[@"shop_lng"]];
    _shop_lat = [NSString stringWithFormat:@"%@", dic[@"shop_lat"]];
    return self;
}
@end
