//
//  shopDetailInfo.m
//  CardLeap
//
//  Created by lin on 12/22/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "shopDetailInfo.h"

@implementation shopDetailInfo
@synthesize group_num = _group_num;
@synthesize num = _num;
@synthesize rev_type = _rev_type;
@synthesize review_index = _review_index;
@synthesize socre = _socre;
@synthesize shop_action = _shop_action;
@synthesize shop_address = _shop_address;
@synthesize shop_desc = _shop_desc;
@synthesize shop_id = _shop_id;
@synthesize shop_name = _shop_name;
@synthesize shop_pic = _shop_pic;
@synthesize shop_pic_list = _shop_pic_list;
@synthesize shop_pic_num = _shop_pic_num;
@synthesize shop_tel = _shop_tel;
@synthesize spike_num = _spike_num;
@synthesize takeout_num = _takeout_num;
@synthesize collection = _collection;
@synthesize event_num = _event_num;
@synthesize share_url = _share_url;
@synthesize shop_brief = _shop_brief;
@synthesize shop_lat = _shop_lat;
@synthesize shop_lng = _shop_lng;
@synthesize message_url = _message_url;

-(id)initWithDictionary :(NSDictionary*)dic
{
    if (!self)
    {
        self = [[shopDetailInfo alloc] init];
    }
    _group_num = [NSString stringWithFormat:@"%@", dic[@"group_num"]];
    _num = [NSString stringWithFormat:@"%@", dic[@"num"]];
    _rev_type = [NSString stringWithFormat:@"%@", dic[@"rev_type"]];
    _socre = [NSString stringWithFormat:@"%@", dic[@"score"] ];
    _shop_action = [NSString stringWithFormat:@"%@", dic[@"shop_action"]];
    _shop_address = [NSString stringWithFormat:@"%@", dic[@"shop_address"]];
    _shop_id = [NSString stringWithFormat:@"%@", dic[@"shop_id"]];
    _shop_name = [NSString stringWithFormat:@"%@", dic[@"shop_name"] ];
    _shop_pic = [NSString stringWithFormat:@"%@", dic[@"shop_pic"]];
    _shop_pic_list = dic[@"shop_pic_list"];
    _shop_pic_num = [NSString stringWithFormat:@"%@", dic[@"shop_pic_num"]];
    _shop_tel = [NSString stringWithFormat:@"%@", dic[@"shop_tel"]];
    _shop_desc = dic[@"shop_desc"];
    _takeout_num = [NSString stringWithFormat:@"%@", dic[@"takeout_num"]];
    _spike_num = [NSString stringWithFormat:@"%@", dic[@"spike_num"]];
    _review_index = dic[@"review_index"];
    _collection = [NSString stringWithFormat:@"%@", dic[@"collection"]];
    _event_num = [NSString stringWithFormat:@"%@", dic[@"event_num"]];
    _share_url = [NSString stringWithFormat:@"%@",dic[@"share_url"]];
    _shop_brief = [NSString stringWithFormat:@"%@",dic[@"shop_brief"]];
    _shop_lat = [NSString stringWithFormat:@"%@",dic[@"shop_lat"]];
    _shop_lng  = [NSString stringWithFormat:@"%@",dic[@"shop_lng"]];
    _message_url = [NSString stringWithFormat:@"%@",dic[@"message_url"]];
    return self;
}


@end
