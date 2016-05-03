//
//  reviewDishInfo.m
//  CardLeap
//
//  Created by lin on 1/7/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "reviewDishInfo.h"

@implementation reviewDishInfo

@synthesize take_id,take_name,shop_id,order_id;

-(id)initWithDictinoary:(NSDictionary*)dic
{
    if (!self) {
        self = [[reviewDishInfo alloc] init];
    }
    self.take_id = [NSString stringWithFormat:@"%@",dic[@"take_id"]];
    self.take_name = [NSString stringWithFormat:@"%@",dic[@"take_name"]];
    self.shop_id = [NSString stringWithFormat:@"%@",dic[@"shop_id"]];
    self.order_id = [NSString stringWithFormat:@"%@",dic[@"order_id"]];
    return self;
}

@end
