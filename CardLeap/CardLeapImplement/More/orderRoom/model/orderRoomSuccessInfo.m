//
//  orderRoomSuccessInfo.m
//  CardLeap
//
//  Created by mac on 15/2/10.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "orderRoomSuccessInfo.h"

@implementation orderRoomSuccessInfo
@synthesize shop_name,use_name,hotel_tel,hotel_num,begin_time,end_time,goods_cate,shop_id,share_url;

-(id)initWithDictionary:(NSDictionary*)dic
{
    if (!self) {
        self = [[orderRoomSuccessInfo alloc] init];
    }
    self.shop_name = [NSString stringWithFormat:@"%@",dic[@"shop_name"]];
    self.shop_id = [NSString stringWithFormat:@"%@",dic[@"shop_id"]];
    self.use_name = [NSString stringWithFormat:@"%@",dic[@"use_name"]];
    self.hotel_tel = [NSString stringWithFormat:@"%@",dic[@"hotel_tel"]];
    self.begin_time = [NSString stringWithFormat:@"%@",dic[@"begin_time"]];
    self.end_time = [NSString stringWithFormat:@"%@",dic[@"end_time"]];
    self.goods_cate = [NSString stringWithFormat:@"%@",dic[@"goods_cate"]];
    self.hotel_num = [NSString stringWithFormat:@"%@",dic[@"hotel_num"]];
#pragma mark --- 2016.4 self.share_url = [NSString stringWithFormat:@"&@",dic[@"share_url"]];
    self.share_url = [NSString stringWithFormat:@"%@",dic[@"share_url"]];
    return self;
}
@end
