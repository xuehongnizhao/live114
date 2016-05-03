//
//  roomInfo.m
//  CardLeap
//
//  Created by mac on 15/1/14.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "roomInfo.h"

@implementation roomInfo
@synthesize goods_id = _goods_id;
@synthesize shop_id = _shop_id;
@synthesize goods_cate = _goods_cate;
@synthesize goods_desc = _goods_desc;
@synthesize goods_price = _goods_price;
@synthesize message_url = _message_url;

-(id)initWithDictionary:(NSDictionary*)dic
{
    if (!self) {
        self = [[roomInfo alloc] init];
    }
    _goods_id = [NSString stringWithFormat:@"%@",dic[@"goods_id"]];
    _shop_id = [NSString stringWithFormat:@"%@",dic[@"shop_id"]];
    _goods_cate = [NSString stringWithFormat:@"%@",dic[@"goods_cate"]];
    _goods_desc = [NSString stringWithFormat:@"%@",dic[@"goods_desc"]];
    _goods_price = [NSString stringWithFormat:@"%@",dic[@"goods_price"]];
    _message_url = [NSString stringWithFormat:@"%@",dic[@"message_url"]];
    return self;
}
@end
