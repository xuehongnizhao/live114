//
//  myOrderRoomCenterInfo.m
//  CardLeap
//
//  Created by mac on 15/1/20.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myOrderRoomCenterInfo.h"

@implementation myOrderRoomCenterInfo
@synthesize goods_cate,goods_desc,begin_time,end_time,use_name,hotel_num,hotel_tel,shop_name,shop_pic,seat_status,shop_id,hotel_id,score;

-(id)initWithDictionary:(NSDictionary*)dic
{
    if (!self) {
        self = [[myOrderRoomCenterInfo alloc] init];
    }
    self.goods_cate = [NSString stringWithFormat:@"%@",dic[@"goods_cate"]];
    self.goods_desc = [NSString stringWithFormat:@"%@",dic[@"goods_desc"]];
    self.begin_time = [NSString stringWithFormat:@"%@",dic[@"begin_time"]];
    self.end_time = [NSString stringWithFormat:@"%@",dic[@"end_time"]];
    self.use_name = [NSString stringWithFormat:@"%@",dic[@"use_name"]];
    self.hotel_num = [NSString stringWithFormat:@"%@",dic[@"hotel_num"]];
    self.hotel_tel = [NSString stringWithFormat:@"%@",dic[@"hotel_tel"]];
    self.shop_name = [NSString stringWithFormat:@"%@",dic[@"shop_name"]];
    self.shop_pic = [NSString stringWithFormat:@"%@",dic[@"shop_pic"]];
    self.seat_status = [NSString stringWithFormat:@"%@",dic[@"seat_status"]];
    self.shop_id = [NSString stringWithFormat:@"%@",dic[@"shop_id"]];
    self.hotel_id = [NSString stringWithFormat:@"%@",dic[@"hotel_id"]];
    self.score = [NSString stringWithFormat:@"%@",dic[@"score"]];
    return self;
}
@end
