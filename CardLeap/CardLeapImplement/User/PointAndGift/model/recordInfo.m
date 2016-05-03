//
//  recordInfo.m
//  cityo2o
//
//  Created by mac on 15/4/15.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "recordInfo.h"

@implementation recordInfo
@synthesize messge_url = _messge_url;
@synthesize img = _img;
@synthesize mall_name = _mall_name;
@synthesize order_id = _order_id;
@synthesize num = _num;
@synthesize is_use = _is_use;

-(id)initWithDictionary:(NSDictionary*)dic
{
    if (!self) {
        self = [[recordInfo alloc] init];
    }
    _messge_url = [NSString stringWithFormat:@"%@",dic[@"message_url"]];
    _img = [NSString stringWithFormat:@"%@",dic[@"img"]];
    _mall_name = [NSString stringWithFormat:@"%@",dic[@"mall_name"]];
    _order_id = [NSString stringWithFormat:@"%@",dic[@"order_id"]];
    _num = [NSString stringWithFormat:@"%@",dic[@"num"]];
    _is_use = [NSString stringWithFormat:@"%@",dic[@"is_use"]];
    return self;
}
@end
