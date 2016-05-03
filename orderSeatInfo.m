//
//  orderSeatInfo.m
//  CardLeap
//
//  Created by mac on 15/1/12.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "orderSeatInfo.h"

@implementation orderSeatInfo
@synthesize cate_name = _cate_name;
@synthesize rev_num = _rev_num;
@synthesize score = _score;
@synthesize shop_id = _shop_id;
@synthesize shop_name = _shop_name;
@synthesize shop_pic = _shop_pic;
@synthesize shop_address = _shop_address;
@synthesize shop_tel = _shop_tel;
@synthesize shop_desc = _shop_desc;
@synthesize pic_list = _pic_list;
@synthesize pic_num = _pic_num;
@synthesize distance = _distance;
@synthesize shop_lat = _shop_lat;
@synthesize shop_lng = _shop_lng;
@synthesize message_url = _message_url;

-(id)initWithDictionary:(NSDictionary*)dic
{
    if (!self) {
        self = [[orderSeatInfo alloc] init];
    }
    _cate_name = [NSString stringWithFormat:@"%@",dic[@"cat_name"]];
    _rev_num = [NSString stringWithFormat:@"%@",dic[@"rev_num"]];
    _score = [NSString stringWithFormat:@"%@",dic[@"score"]];
    _shop_id = [NSString stringWithFormat:@"%@",dic[@"shop_id"]];
    _shop_name = [NSString stringWithFormat:@"%@",dic[@"shop_name"]];
    _shop_pic = [NSString stringWithFormat:@"%@",dic[@"shop_pic"]];
    _pic_num = [NSString stringWithFormat:@"%@",dic[@"pic_num"]];
    _shop_address = [NSString stringWithFormat:@"%@",dic[@"shop_address"]];
    _shop_tel = [NSString stringWithFormat:@"%@",dic[@"shop_tel"]];
    _shop_desc = [NSString stringWithFormat:@"%@",dic[@"shop_desc"]];
    _distance = [NSString stringWithFormat:@"%@",dic[@"distance"]];
    _shop_lng = [NSString stringWithFormat:@"%@",dic[@"shop_lng"]];
    _shop_lat = [NSString stringWithFormat:@"%@",dic[@"shop_lat"]];
    _message_url = [NSString stringWithFormat:@"%@",dic[@"message_url"]];
    _pic_list = dic[@"pic_list"];
    return self;
}
@end
