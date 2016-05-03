//
//  myOrderSeatCenterInfo.m
//  CardLeap
//
//  Created by mac on 15/1/20.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myOrderSeatCenterInfo.h"

@implementation myOrderSeatCenterInfo
@synthesize use_name,seat_num,seat_tel,shop_name,shop_pic,ri,fen,confirm_status,shop_id,score,seat_id;

-(id)initWithDictionary:(NSDictionary*)dic
{
    if (!self) {
        self = [[myOrderSeatCenterInfo alloc] init];
    }
    self.use_name = [NSString stringWithFormat:@"%@",dic[@"use_name"]];
    self.seat_tel = [NSString stringWithFormat:@"%@",dic[@"seat_tel"]];
    self.shop_name = [NSString stringWithFormat:@"%@",dic[@"shop_name"]];
    self.shop_pic = [NSString stringWithFormat:@"%@",dic[@"shop_pic"]];
    self.seat_num = [NSString stringWithFormat:@"%@",dic[@"seat_num"]];
    self.ri = [NSString stringWithFormat:@"%@",dic[@"ri"]];
    self.fen = [NSString stringWithFormat:@"%@",dic[@"fen"]];
    self.confirm_status = [NSString stringWithFormat:@"%@",dic[@"seat_status"]];
    self.shop_id = [NSString stringWithFormat:@"%@",dic[@"shop_id"]];
    self.score = [NSString stringWithFormat:@"%@",dic[@"score"]];
    self.seat_id = [NSString stringWithFormat:@"%@",dic[@"seat_id"]];
    return self;
}
@end
