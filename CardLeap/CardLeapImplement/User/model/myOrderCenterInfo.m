//
//  myOrderCenterInfo.m
//  CardLeap
//
//  Created by mac on 15/1/20.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myOrderCenterInfo.h"

@implementation myOrderCenterInfo
@synthesize order_id,shop_name,shop_pic,total_price,confirm_status;

-(id)initWithDictionary:(NSDictionary*)dic
{
    if (!self) {
        self = [[myOrderCenterInfo alloc] init];
    }
    self.order_id = [NSString stringWithFormat:@"%@",dic[@"order_id"]];
    self.shop_name = [NSString stringWithFormat:@"%@",dic[@"shop_name"]];
    self.shop_pic = [NSString stringWithFormat:@"%@",dic[@"shop_pic"]];
    self.total_price = [NSString stringWithFormat:@"%@",dic[@"total_price"]];
    self.confirm_status = [NSString stringWithFormat:@"%@",dic[@"confirm_status"]];
    self.score = [NSString stringWithFormat:@"%@",dic[@"score"]];
    self.is_pay = [NSString stringWithFormat:@"%@",dic[@"cash"]];
    self.takeout_url = [NSString stringWithFormat:@"%@",dic[@"takeout_url"]];
    return self;
}
@end
