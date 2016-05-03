//
//  ShopListInfo.m
//  CardLeap
//
//  Created by lin on 12/22/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "ShopListInfo.h"

@implementation ShopListInfo
@synthesize area_name = _area_name;
@synthesize cat_name = _cat_name;
@synthesize num = _num;
@synthesize score = _score;
@synthesize shop_action = _shop_action;
@synthesize shop_address = _shop_address;
@synthesize shop_id = _shop_id;
@synthesize shop_name = _shop_name;
@synthesize shop_pic = _shop_pic;
@synthesize shop_pic_list = _shop_pic_list;
@synthesize shop_pic_num = _shop_pic_num;
@synthesize shop_tel = _shop_tel;
@synthesize shop_desc = _shop_desc;
@synthesize distace = _distace;
@synthesize collect = _collect;
@synthesize shop_lat = _shop_lat;
@synthesize shop_lng = _shop_lng;
@synthesize distance = _distance;
@synthesize group_num = _group_num;
@synthesize spike_num = _spike_num;
@synthesize takeout_num = _takeout_num;
@synthesize activity_num = _activity_num;
@synthesize shop_brief = _shop_brief;
@synthesize message_url = _message_url;

-(id)initWithDictionary :(NSDictionary*)dic
{
    if (!self)
    {
        self = [[ShopListInfo alloc] init];
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
    _shop_pic_list = dic[@"shop_pic_list"];
    _shop_pic_num = [NSString stringWithFormat:@"%@", dic[@"shop_pic_num"]];
    _shop_tel = [NSString stringWithFormat:@"%@", dic[@"shop_tel"]];
    _shop_desc = dic[@"shop_desc"];
    _distace = dic[@"distance"];
    _collect = [NSString stringWithFormat:@"%@",dic[@"collection"]];
    _shop_lat = [NSString stringWithFormat:@"%@",dic[@"shop_lat"]];
    _shop_lng = [NSString stringWithFormat:@"%@",dic[@"shop_lng"]];
    
    _group_num = [NSString stringWithFormat:@"%@",dic[@"group_num"]];
    _spike_num = [NSString stringWithFormat:@"%@",dic[@"spike_num"]];
    _takeout_num = [NSString stringWithFormat:@"%@",dic[@"takeout_num"]];
    _activity_num = [NSString stringWithFormat:@"%@",dic[@"event_num"]];
    
    _shop_brief = [NSString stringWithFormat:@"%@",dic[@"shop_brief"]];
    _message_url = [NSString stringWithFormat:@"%@",dic[@"message_url"]];
    return self;
}

@end
