//
//  shopTakeCateInfo.m
//  CardLeap
//
//  Created by lin on 12/29/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "shopTakeCateInfo.h"
#import "dishCateInfo.h"

@implementation shopTakeCateInfo
@synthesize review_num = _review_num;
@synthesize shop_address = _shop_address;
@synthesize shop_take_desc = _shop_take_desc;
@synthesize ship_price = _ship_price;
@synthesize num = _num;
@synthesize shop_id = _shop_id;
@synthesize begin_price = _begin_price;
@synthesize shop_pic = _shop_pic;
@synthesize shop_name = _shop_name;
@synthesize cate = _cate;
@synthesize accept_time = _accept_time;
@synthesize shipping = _shipping;
@synthesize timely = _timely;
@synthesize is_ship = _is_ship;
@synthesize score = _score;
@synthesize share_url = _share_url;

-(id)initWithDictionary :(NSDictionary*)dict
{
    if (!self) {
        self = [[shopTakeCateInfo alloc] init];
    }
    _review_num = [NSString stringWithFormat:@"%@",dict[@"review_num"]];
    _shop_address = [NSString stringWithFormat:@"%@",dict[@"shop_address"]];
    _shop_take_desc = [NSString stringWithFormat:@"%@",dict[@"shop_take_desc"]];
    _ship_price = [NSString stringWithFormat:@"%@",dict[@"shipp_price"]];
    _num = [NSString stringWithFormat:@"%@",dict[@"num"]];
    _shop_id = [NSString stringWithFormat:@"%@",dict[@"shop_id"]];
    _begin_price = [NSString stringWithFormat:@"%@",dict[@"begin_price"]];
    _shop_pic = [NSString stringWithFormat:@"%@",dict[@"shop_pic"]];
    _shop_name = [NSString stringWithFormat:@"%@",dict[@"shop_name"]];
    _accept_time = [NSString stringWithFormat:@"%@",dict[@"accept_time"]];
    _shipping = [NSString stringWithFormat:@"%@",dict[@"shipping"]];
    _timely = [NSString stringWithFormat:@"%@",dict[@"timely"]];
    _is_ship = [NSString stringWithFormat:@"%@",dict[@"is_ship"]];
    _score = [NSString stringWithFormat:@"%@",dict[@"score"]];
    _share_url = [NSString stringWithFormat:@"%@",dict[@"share_url"]];
    _cate = [[NSMutableArray alloc] init];
    NSArray *array = dict[@"cate"];
    for (NSDictionary *dic in array) {
        dishCateInfo *info = [[dishCateInfo alloc] initWithDictionary:dic];
        [_cate addObject:info];
    }
    return self;
}

@end
