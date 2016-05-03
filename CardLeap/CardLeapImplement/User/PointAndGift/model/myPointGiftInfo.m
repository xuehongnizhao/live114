//
//  myPointGiftInfo.m
//  cityo2o
//
//  Created by mac on 15/4/14.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myPointGiftInfo.h"

@implementation myPointGiftInfo
@synthesize message_url = _message_url;
@synthesize mall_id = _mall_id;
@synthesize mall_name = _mall_name;
@synthesize how_use = _how_use;
@synthesize mall_integral = _mall_integral;
@synthesize img = _img;
@synthesize result = _result;
@synthesize color = _color;

-(id)initWithDictionary:(NSDictionary*)dic
{
    if (!self) {
        self = [[myPointGiftInfo alloc] init];
    }
    _message_url = [NSString stringWithFormat:@"%@",dic[@"message_url"]];
    _mall_id = [NSString stringWithFormat:@"%@",dic[@"mall_id"]];
    _mall_name = [NSString stringWithFormat:@"%@",dic[@"mall_name"]];
    _how_use = [NSString stringWithFormat:@"%@",dic[@"how_use"]];
    _mall_integral = [NSString stringWithFormat:@"%@",dic[@"mall_integral"]];
    _img = [NSString stringWithFormat:@"%@",dic[@"img"]];
    _result = [NSString stringWithFormat:@"%@",dic[@"result"]];
    _color = [NSString stringWithFormat:@"%@",dic[@"color"]];
    return self;
}
@end
