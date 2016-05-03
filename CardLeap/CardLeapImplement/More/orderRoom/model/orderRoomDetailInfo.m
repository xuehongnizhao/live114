//
//  orderRoomDetailInfo.m
//  CardLeap
//
//  Created by mac on 15/1/14.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "orderRoomDetailInfo.h"
#import "roomInfo.h"
@implementation orderRoomDetailInfo
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
@synthesize goods_list = _goods_list;
@synthesize share_url = _share_url;
@synthesize message_url = _message_url;
@synthesize shop_lng = _shop_lng;
@synthesize shop_lat = _shop_lat;

-(id)initWithDictionary:(NSDictionary*)dic
{
    if (!self) {
        self = [[orderRoomDetailInfo alloc] init];
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
    _share_url = [NSString stringWithFormat:@"%@",dic[@"share_url"]];
    _message_url = [NSString stringWithFormat:@"%@",dic[@"message_url"]];
    _shop_lat = [NSString stringWithFormat:@"%@",dic[@"shop_lat"]];
    _shop_lng = [NSString stringWithFormat:@"%@",dic[@"shop_lng"]];
    _pic_list = dic[@"pic_list"];
    _goods_list = [[NSMutableArray alloc] init];
    NSArray *arr = dic[@"goods_list"];
    for (NSDictionary *dic in arr) {
        roomInfo *info = [[roomInfo alloc] initWithDictionary:dic];
        [_goods_list addObject:info];
    }
    return self;
}
@end
