//
//  orderSeatSuccessInfo.m
//  CardLeap
//
//  Created by mac on 15/2/10.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "orderSeatSuccessInfo.h"

@implementation orderSeatSuccessInfo
@synthesize shop_name,use_name,use_time,seat_num,seat_tel,ri,fen,shop_id,share_url;

-(id)initWithDictionary:(NSDictionary*)dic
{
    if (!self) {
        self = [[orderSeatSuccessInfo alloc] init];
    }
    self.shop_name = [NSString stringWithFormat:@"%@",dic[@"shop_name"]];
    self.use_name = [NSString stringWithFormat:@"%@",dic[@"use_name"]];
    self.use_time = [NSString stringWithFormat:@"%@",dic[@"use_time"]];
    self.seat_num = [NSString stringWithFormat:@"%@",dic[@"seat_num"]];
    self.seat_tel = [NSString stringWithFormat:@"%@",dic[@"seat_tel"]];
    self.shop_id = [NSString stringWithFormat:@"%@",dic[@"shop_id"]];
    self.ri = [NSString stringWithFormat:@"%@",dic[@"ri"]];
    self.fen = [NSString stringWithFormat:@"%@",dic[@"fen"]];
    self.share_url = [NSString stringWithFormat:@"%@",dic[@"share_url"]];

    return self;
}
@end
